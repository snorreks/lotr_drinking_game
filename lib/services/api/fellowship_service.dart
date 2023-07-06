import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/base_service.dart';
import '../../constants/characters.dart';
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

  Future<bool> joinFellowship(String fellowshipPIN);

  Future<bool> selectCharacter(
      {required String username,
      required Character character,
      required bool isFirst});

  Future<bool> createFellowship(String fellowshipId);

  Future<bool> leaveFellowship();

  Future<bool> changeAdmin(
      FellowshipMember newAdmin, FellowshipMember oldAdmin);

  Future<bool> nextMovie();

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

        return fellowship.members[character];
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

  Fellowship? _fellowship;

  final BehaviorSubject<Character?> _characterSubject;

  @override
  Stream<Character?> get characterStream => _characterSubject.stream;

  final BehaviorSubject<Fellowship?> _fellowshipSubject =
      BehaviorSubject<Fellowship?>();

  Stream<Fellowship?>? _fellowshipStream;
  final BehaviorSubject<FellowshipMember?> _memberSubject =
      BehaviorSubject<FellowshipMember?>();
  StreamSubscription<Fellowship?>? _fellowshipStreamListener;

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
    });

    return _fellowshipSubject.stream;
  }

  @override
  Stream<FellowshipMember?> get memberStream => _memberSubject.stream;

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

      final Fellowship? fellowship = _fellowship ??
          await _fellowshipRepository.get(
            _fellowshipId!,
          );

      if (fellowship == null) {
        throw Exception('Fellowship is null');
      }

      final Character? character = _preferencesService.character;

      if (character == null) {
        throw Exception('Character is null');
      }

      await _fellowshipRepository.increment(
        fellowshipId: _fellowshipId!,
        character: character,
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
    required bool isFirst,
  }) async {
    try {
      if (_fellowshipId == null) {
        return false;
      }

      await _fellowshipRepository.addMember(
          _fellowshipId!,
          FellowshipMember(
              name: username, character: character, isAdmin: isFirst));

      _preferencesService.character = character;
      _characterSubject.add(character);

      return true;
    } catch (e) {
      logError('selectCharacter', e);
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
      _fellowship = null;
      _preferencesService.fellowshipId = null;
      _preferencesService.character = null;
      _preferencesService.fellowshipPin = null;
      _characterSubject.add(null);
      _fellowshipSubject.add(null);
      _fellowshipStreamListener?.cancel();
      _fellowshipStream = null;
      _fellowshipStreamListener = null;

      return true;
    } catch (e) {
      logError('leaveFellowship', e);
      return false;
    }
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
  Future<bool> sendCallout(FellowshipMember player, String rule) async {
    try {
      await _fellowshipRepository.createCallout(
        fellowshipId: _fellowshipId!,
        character: player.character,
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
      final Character? character = _preferencesService.character;

      if (character == null) {
        return false;
      }

      if (hasAccepted) {
        await _fellowshipRepository.resolveCallout(
          fellowshipId: _fellowshipId!,
          character: character,
          drinks: 2,
        );

        return true;
      } else {
        //They reject the request
        await _fellowshipRepository.resolveCallout(
          fellowshipId: _fellowshipId!,
          character: character,
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
  (ProviderRef<FellowshipServiceModel> ref) => FellowshipService(
    ref,
  ),
);
