import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/base_service.dart';
import '../../constants/characters.dart';
import '../../models/fellowship.dart';
import '../../models/fellowship_member.dart';
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

  Future<bool> joinFellowship(String fellowshipPIN);

  Future<bool> selectCharacter({
    required String username,
    required Character character,
  });

  Future<bool> createFellowship(String fellowshipId);

  Future<bool> leaveFellowship();

  Future<bool> incrementDrink();

  Future<bool> incrementSaves();

  Future<bool> sendCallout(FellowshipMember player, String rule);

  Future<bool> resolveCallout(bool hasAccepted);
}

class FellowshipService extends BaseService implements FellowshipServiceModel {
  FellowshipService(this._ref)
      : _characterSubject = BehaviorSubject<Character?>.seeded(
            _ref.read(preferencesService).character) {
    Rx.combineLatest2<Fellowship?, Character?, FellowshipMember?>(
      fellowshipStream,
      characterStream,
      (Fellowship? fellowship, Character? character) {
        _updateMemberStream(fellowship, character);
        return null;
      },
    ).listen((_) {});
  }

  final Ref _ref;

  PreferencesServiceModel get _preferencesService =>
      _ref.read(preferencesService);

  FellowshipRepositoryModel get _fellowshipRepository =>
      _ref.read(fellowshipRepository);

  String? get _fellowshipId => _preferencesService.fellowshipId;
  //String? get _fellowshipPin => _preferencesService.fellowshipPin;

  @override
  bool get hasJoinedFellowship => _fellowshipId != null;

  Fellowship? _fellowship;

  final BehaviorSubject<Character?> _characterSubject;

  @override
  Stream<Character?> get characterStream => _characterSubject.stream;

  final BehaviorSubject<Fellowship?> _fellowshipSubject =
      BehaviorSubject<Fellowship?>();

  Stream<Fellowship?>? _fellowshipStream;
  final BehaviorSubject<FellowshipMember?> _memberSubject =
      BehaviorSubject<FellowshipMember?>();

  @override
  Stream<Fellowship?> get fellowshipStream {
    if (_fellowshipStream != null) {
      return _fellowshipSubject.stream;
    }

    if (_fellowshipId == null) {
      return const Stream<Fellowship?>.empty();
    }

    _fellowshipStream = _fellowshipRepository.stream(_fellowshipId!);
    _fellowshipStream!.listen((Fellowship? fellowship) {
      _fellowshipSubject.add(fellowship);
    }).onDone(() {
      _fellowshipStream = null; // Reset the stream reference when it's done
    });

    return _fellowshipSubject.stream;
  }

  @override
  Stream<FellowshipMember?> get memberStream => _memberSubject.stream;

  void _updateMemberStream(Fellowship? fellowship, Character? character) {
    if (fellowship == null || character == null) {
      _memberSubject.add(null);
      return;
    }

    final FellowshipMember? member = fellowship.members[character];
    _memberSubject.add(member);
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
  Future<bool> incrementDrink() => _increment(IncrementType.drinks);

  @override
  Future<bool> incrementSaves() => _increment(IncrementType.saves);
  Future<bool> _increment(IncrementType type) async {
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
  }) async {
    try {
      if (_fellowshipId == null) {
        return false;
      }

      await _fellowshipRepository.addMember(
        _fellowshipId!,
        FellowshipMember(name: username, character: character),
      );

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
      return false;
    }
  }

  @override
  Future<bool> leaveFellowship() async {
    try {
      if (_fellowshipId == null) {
        return false;
      }
      _fellowship = null;
      _preferencesService.fellowshipId = null;
      _preferencesService.character = null;
      _preferencesService.fellowshipPin = null;
      _characterSubject.add(null);

      return true;
    } catch (e) {
      logError('leaveFellowship', e);
      return false;
    }
  }

  @override
  Future<bool> sendCallout(FellowshipMember member, String rule) async {
    try {
      if (_fellowshipId == null) {
        return false;
      }

      if (rule == '') {
        return false;
      }

      await _fellowshipRepository.createCallout(
        fellowshipId: _fellowshipId!,
        character: member.character,
        rule: rule,
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
      logError('sendCallout', e);
      return false;
    }
  }
}

final Provider<FellowshipServiceModel> fellowshipService =
    Provider<FellowshipServiceModel>(
  (ProviderRef<FellowshipServiceModel> ref) => FellowshipService(
    ref,
  ),
);
