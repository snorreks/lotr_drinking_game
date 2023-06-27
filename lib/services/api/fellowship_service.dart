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

  Stream<Character?> get characterStream;

  Stream<Fellowship?> get fellowshipStream;

  Future<bool> joinFellowship(String fellowshipPIN);

  Future<bool> selectCharacter(
      {required String username,
      required Character character,
      required bool isFirst});

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
            _ref.read(preferencesService).character);

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

  @override
  Stream<Fellowship?> get fellowshipStream {
    if (_fellowshipId == null) {
      return const Stream<Fellowship?>.empty();
    }

    return _fellowshipRepository.stream(_fellowshipId!).map(
      (Fellowship? fellowship) {
        _fellowship = fellowship;
        return fellowship;
      },
    );
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
  Future<bool> incrementDrink() async {
    try {
      if (_fellowshipId == null) {
        return false;
      }

      final Fellowship? fellowship = _fellowship ??
          await _fellowshipRepository.get(
            _fellowshipId!,
          );

      if (fellowship == null) {
        return false;
      }

      final Character? character = _preferencesService.character;

      if (character == null) {
        return false;
      }

      await _fellowshipRepository.increment(_fellowshipId!, character, true);

      return true;
    } catch (e) {
      logError('incrementDrink', e);
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

      final Fellowship? fellowship = _fellowship ??
          await _fellowshipRepository.get(
            _fellowshipId!,
          );

      if (fellowship == null) {
        return false;
      }

      fellowship.members[character] = FellowshipMember(
        name: username,
        drinks: 0,
        saves: 0,
        callout: '',
        isAdmin: isFirst,
        character: Character.aragorn,
      );

      await _fellowshipRepository.update(
        _fellowshipId!,
        fellowship,
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
  Future<bool> incrementSaves() async {
    try {
      if (_fellowshipId == null) {
        return false;
      }

      final Fellowship? fellowship = _fellowship ??
          await _fellowshipRepository.get(
            _fellowshipId!,
          );

      if (fellowship == null) {
        return false;
      }

      final Character? character = _preferencesService.character;

      if (character == null) {
        return false;
      }

      await _fellowshipRepository.increment(_fellowshipId!, character, false);

      return true;
    } catch (e) {
      logError('incrementSaves', e);
      return false;
    }
  }

  @override
  Future<bool> sendCallout(FellowshipMember player, String rule) async {
    try {
      if (_fellowshipId == null) {
        return false;
      }

      if (rule == '') {
        return false;
      }

      await _fellowshipRepository.createCallout(_fellowshipId!, player, rule);
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
            _fellowshipId!, character, 2);
        return true;
      } else {
        //They reject the request
        await _fellowshipRepository.resolveCallout(
            _fellowshipId!, character, 0);
        return true;
      }
    } catch (e) {
      logError('resolveCallout', e);
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
