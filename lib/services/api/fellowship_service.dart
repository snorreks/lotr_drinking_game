import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/base_service.dart';
import '../../constants/characters.dart';
import '../../constants/game_rule.dart';
import '../../models/fellowship.dart';
import '../../models/fellowship_member.dart';
import '../app/dialog_service.dart';
import '../app/preferences_service.dart';
import '../repositories/fellowship_repository.dart';

/// FellowshipService handles the authentication of the app, by communicating with Firebase
///
/// The class will notify listeners when the auth is changed.
abstract class FellowshipServiceModel {
  bool get hasJoinedFellowship;

  /// The current fellowship character
  Stream<Character?> get characterStream;

  /// The current fellowship member
  Stream<FellowshipMember?> get memberStream;

  /// The current fellowship
  Stream<Fellowship?> get fellowshipStream;

  Fellowship? get fellowship;
  FellowshipMember? get member;
  Character? get character;
  RuleDifficulty get difficulty;

  Future<bool> joinFellowship(String fellowshipPIN);

  Future<bool> selectCharacter({
    required String username,
    required Character character,
    required RuleDifficulty difficulty,
  });

  Future<bool> changeDifficulty(RuleDifficulty difficulty);

  Future<bool> createFellowship(String fellowshipId);

  Future<bool> leaveFellowship();

  Future<bool> changeAdmin(
      FellowshipMember newAdmin, FellowshipMember oldAdmin);

  Future<bool> nextMovie();

  Future<bool> showSummaryIfNeeded([Fellowship? snapshot]);

  Future<bool> incrementDrink({int? amount});

  Future<bool> incrementSaves();

  Future<bool> sendCallout(FellowshipMember player, String rule);

  Future<bool> resolveCallout(bool hasAccepted);
}

class FellowshipService extends BaseService implements FellowshipServiceModel {
  FellowshipService(this._ref)
      : _characterSubject = BehaviorSubject<Character?>.seeded(
            _ref.read(preferencesService).character) {
    _memberStreamSubscription =
        Rx.combineLatest2<Fellowship?, Character?, FellowshipMember?>(
      _fellowshipSubject.stream,
      characterStream,
      (Fellowship? fellowship, Character? character) {
        if (fellowship == null || character == null) {
          return null;
        }
        return fellowship.findMember(
          _preferencesService.memberId,
          character,
        );
      },
    ).listen((FellowshipMember? member) {
      if (member?.callout != null) {
        _ref.read(dialogService).showCalledOutDialog(member!.callout!);
      }

      _memberSubject.add(member);
    });
  }

  final Ref _ref;

  late StreamSubscription<FellowshipMember?> _memberStreamSubscription;

  PreferencesServiceModel get _preferencesService =>
      _ref.read(preferencesService);

  FellowshipRepositoryModel get _fellowshipRepository =>
      _ref.read(fellowshipRepository);

  String? get _fellowshipId => _preferencesService.fellowshipId;
  //String? get _fellowshipPin => _preferencesService.fellowshipPin;

  @override
  bool get hasJoinedFellowship => _fellowshipId != null;

  @override
  Fellowship? get fellowship => _fellowshipSubject.valueOrNull;
  @override
  FellowshipMember? get member => _memberSubject.valueOrNull;
  @override
  Character? get character => _characterSubject.valueOrNull;
  @override
  RuleDifficulty get difficulty => _preferencesService.difficulty;

  final BehaviorSubject<Character?> _characterSubject;

  @override
  Stream<Character?> get characterStream => _characterSubject.stream;

  final BehaviorSubject<Fellowship?> _fellowshipSubject =
      BehaviorSubject<Fellowship?>();

  Stream<Fellowship?>? _fellowshipStream;
  final BehaviorSubject<FellowshipMember?> _memberSubject =
      BehaviorSubject<FellowshipMember?>();
  StreamSubscription<Fellowship?>? _fellowshipStreamListener;

  /// The movie the summary dialog was last shown for, so a movie transition
  /// only ever triggers the dialog once per client.
  String? _summaryShownForMovie;

  /// The member currently carrying the Ring: the one who has drunk the most.
  FellowshipMember? _ringbearer;

  /// The fellowship the ringbearer was last tracked for, so joining another
  /// fellowship starts over without announcing anything.
  String? _ringbearerFellowshipId;

  /// Whether the ringbearer has been synced with the fellowship at least
  /// once, so only live changes are announced, not the state on app start.
  bool _ringbearerInitialized = false;

  @override
  Stream<Fellowship?> get fellowshipStream {
    if (_fellowshipStream != null) {
      return _fellowshipSubject.stream;
    }

    if (_fellowshipId == null) {
      return const Stream<Fellowship?>.empty();
    }

    _fellowshipStream = _fellowshipRepository.stream(_fellowshipId!);
    _fellowshipStreamListener =
        _fellowshipStream!.listen((Fellowship? fellowship) {
      if (fellowship == null) {
        leaveFellowship();
      }
      _fellowshipSubject.add(fellowship);
      if (fellowship != null) {
        showSummaryIfNeeded(fellowship);
        _updateRingbearer(fellowship);
      }
    });

    return _fellowshipSubject.stream;
  }

  @override
  Stream<FellowshipMember?> get memberStream => _memberSubject.stream;

  /// The id of this client's membership in [fellowship].
  ///
  /// Prefers the persisted member id and falls back to matching the stored
  /// character, so sessions joined before member ids existed keep working.
  /// Throws if this client is not a member of the fellowship.
  String _resolveOwnMemberId(Fellowship fellowship) {
    final FellowshipMember? member = fellowship.findMember(
      _preferencesService.memberId,
      _preferencesService.character,
    );
    if (member == null) {
      throw Exception('Member not found in fellowship');
    }
    return member.id;
  }

  /// The current fellowship, from the live stream when available.
  Future<Fellowship?> _currentFellowship() async {
    return fellowship ?? await _fellowshipRepository.get(_fellowshipId!);
  }

  @override
  Future<bool> createFellowship(String fellowshipName) async {
    try {
      final String fellowshipId = await _fellowshipRepository.create(
        fellowshipName,
      );
      _preferencesService.fellowshipId = fellowshipId;
      return true;
    } catch (e) {
      logError('createFellowship', e);
      return false;
    }
  }

  @override
  Future<bool> incrementDrink({int? amount}) =>
      _increment(IncrementType.drinks, amount: amount);

  @override
  Future<bool> incrementSaves() => _increment(IncrementType.saves);
  Future<bool> _increment(IncrementType type, {int? amount}) async {
    try {
      if (_fellowshipId == null) {
        throw Exception('FellowshipId is null');
      }

      final Fellowship? fellowship = await _currentFellowship();

      if (fellowship == null) {
        throw Exception('Fellowship is null');
      }

      await _fellowshipRepository.increment(
        fellowshipId: _fellowshipId!,
        memberId: _resolveOwnMemberId(fellowship),
        type: type,
        amount: amount,
      );

      return true;
    } catch (e) {
      logError('_increment $type:', e);
      return false;
    }
  }

  @override
  Future<bool> selectCharacter({
    required String username,
    required Character character,
    required RuleDifficulty difficulty,
  }) async {
    try {
      if (_fellowshipId == null) {
        return false;
      }

      final Fellowship? fellowship = await _currentFellowship();
      final bool isFirst = fellowship != null && fellowship.members.isEmpty;

      // Every membership gets its own unique id, so players can share a
      // character without overwriting each other.
      final String memberId =
          _preferencesService.memberId ?? FellowshipMember.generateId();

      await _fellowshipRepository.addMember(
        _fellowshipId!,
        FellowshipMember(
          id: memberId,
          name: username,
          character: character,
          difficulty: difficulty,
          isAdmin: isFirst,
        ),
      );

      _preferencesService.memberId = memberId;
      _preferencesService.character = character;
      _preferencesService.difficulty = difficulty;
      _characterSubject.add(character);

      return true;
    } catch (e) {
      logError('selectCharacter', e);
      return false;
    }
  }

  @override
  Future<bool> changeDifficulty(RuleDifficulty difficulty) async {
    try {
      if (_fellowshipId == null) {
        return false;
      }

      final Fellowship? fellowship = await _currentFellowship();
      if (fellowship == null) {
        return false;
      }

      await _fellowshipRepository.updateDifficulty(
        fellowshipId: _fellowshipId!,
        memberId: _resolveOwnMemberId(fellowship),
        difficulty: difficulty,
      );
      _preferencesService.difficulty = difficulty;

      return true;
    } catch (e) {
      logError('changeDifficulty', e);
      return false;
    }
  }

  @override
  Future<bool> joinFellowship(String fellowshipPIN) async {
    try {
      final Fellowship? fellowship = await _fellowshipRepository.getByPin(
        fellowshipPIN,
      );
      if (fellowship == null) {
        return false;
      }

      _preferencesService.fellowshipId = fellowship.id;

      return true;
    } catch (e) {
      logError('joinFellowship', e);
      _ref.read(dialogService).showNotification(const NotificationRequest(
            message: 'Fellowship not found',
            type: NotificationType.error,
          ));
      return false;
    }
  }

  @override
  Future<bool> leaveFellowship() async {
    try {
      _preferencesService.fellowshipId = null;
      _preferencesService.character = null;
      _preferencesService.fellowshipPin = null;
      _preferencesService.memberId = null;
      _characterSubject.add(null);
      _fellowshipSubject.add(null);
      _fellowshipStreamListener?.cancel();
      _fellowshipStream = null;
      _fellowshipStreamListener = null;
      _ringbearer = null;
      _ringbearerFellowshipId = null;
      _ringbearerInitialized = false;

      return true;
    } catch (e) {
      logError('leaveFellowship', e);
      return false;
    }
  }

  /// Detects when someone new becomes the leader in drinks ("the Ringbearer")
  /// and announces it. Every client receives the same fellowship updates from
  /// Firestore, so each participant sees the notification.
  void _updateRingbearer(Fellowship fellowship) {
    if (_ringbearerFellowshipId != fellowship.id) {
      // First look at this fellowship: sync state silently.
      _ringbearerFellowshipId = fellowship.id;
      _ringbearerInitialized = false;
      _ringbearer = null;
    }

    final List<FellowshipMember> members = fellowship.membersList;
    if (members.isEmpty) {
      _ringbearer = null;
      _ringbearerInitialized = true;
      return;
    }

    final int topDrinks = members.fold<int>(
      0,
      (int max, FellowshipMember m) =>
          m.drinksAmount > max ? m.drinksAmount : max,
    );

    final List<FellowshipMember> leaders = topDrinks == 0
        ? const <FellowshipMember>[]
        : members
            .where((FellowshipMember m) => m.drinksAmount == topDrinks)
            .toList();

    FellowshipMember? newRingbearer;
    if (leaders.length == 1) {
      // A strict leader: the Ring is theirs.
      newRingbearer = leaders.single;
    } else {
      // Tied at the top: the incumbent keeps the Ring until someone
      // strictly overtakes. Members are compared by id, since multiple
      // players can share the same character.
      for (final FellowshipMember m in leaders) {
        if (m.id == _ringbearer?.id) {
          newRingbearer = m;
          break;
        }
      }
    }

    final bool wasInitialized = _ringbearerInitialized;
    _ringbearerInitialized = true;

    if (newRingbearer != null &&
        wasInitialized &&
        newRingbearer.id != _ringbearer?.id) {
      _ref.read(dialogService).showNotification(NotificationRequest(
            title: 'The Ring has changed hands',
            message: '${newRingbearer.name} has become the ringbearer',
            type: NotificationType.info,
          ));
    }

    _ringbearer = newRingbearer;
  }

  @override
  Future<bool> changeAdmin(
      FellowshipMember newAdmin, FellowshipMember oldAdmin) async {
    try {
      if (_fellowshipId == null) {
        throw Exception("Fellowship doesn't exist");
      }
      if (newAdmin.isAdmin) {
        throw Exception('New admin is already admin');
      }

      if (!oldAdmin.isAdmin) {
        throw Exception("Old admin isn't admin");
      }
      await _fellowshipRepository.changeAdmin(
          _fellowshipId!, newAdmin, oldAdmin);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> nextMovie() async {
    try {
      if (fellowship == null) {
        throw Exception("Fellowship doesn't exist");
      }
      await _fellowshipRepository.nextMovie(
          fellowship!.id, fellowship!.currentMovie);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> showSummaryIfNeeded([Fellowship? snapshot]) async {
    final Fellowship? current = snapshot ?? fellowship;
    if (current == null ||
        current.currentMovie == current.lastSummaryShown ||
        _summaryShownForMovie == current.currentMovie) {
      return false;
    }
    _summaryShownForMovie = current.currentMovie;

    // The movie that just ended is the one the summary was last shown for.
    final String endedMovie = current.lastSummaryShown ?? current.currentMovie;

    // Show the summary dialog
    _ref.read(dialogService).showSummaryDialog(endedMovie);
    // Update lastSummaryShown and start the new movie's drink window
    await _fellowshipRepository.updateLastSummaryShown(
      current.id,
      current.currentMovie,
    );
    return true;
  }

  @override
  Future<bool> sendCallout(FellowshipMember player, String rule) async {
    try {
      await _fellowshipRepository.createCallout(
        fellowshipId: _fellowshipId!,
        memberId: player.id,
        rule: rule,
        caller: member!.name,
      );
      return true;
    } catch (e) {
      logError('sendCallout', e);
      return false;
    }
  }

  @override
  Future<bool> resolveCallout(bool hasAccepted) async {
    try {
      if (_fellowshipId == null) {
        return false;
      }

      final Fellowship? fellowship = await _currentFellowship();
      if (fellowship == null) {
        return false;
      }

      final String memberId = _resolveOwnMemberId(fellowship);

      if (hasAccepted) {
        await _fellowshipRepository.resolveCallout(
          fellowshipId: _fellowshipId!,
          memberId: memberId,
          drinks: 2,
        );

        return true;
      } else {
        //They reject the request
        await _fellowshipRepository.resolveCallout(
          fellowshipId: _fellowshipId!,
          memberId: memberId,
          drinks: 0,
        );
        return true;
      }
    } catch (e) {
      logError('resolveCallout', e);
      return false;
    }
  }

  @override
  void dispose() {
    _fellowshipSubject.close();
    _memberSubject.close();
    _characterSubject.close();
    _memberStreamSubscription.cancel();
  }
}

final Provider<FellowshipServiceModel> fellowshipService =
    Provider<FellowshipServiceModel>(
  (Ref ref) => FellowshipService(
    ref,
  ),
);
