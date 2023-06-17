import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Stream<Fellowship?> get fellowshipStream;

  Future<bool> joinFellowship(String fellowshipId);

  Future<bool> selectCharacter({
    required String username,
    required Character character,
  });

  Future<bool> createFellowship(String fellowshipId);

  Future<bool> leaveFellowship();
}

class FellowshipService extends BaseService implements FellowshipServiceModel {
  FellowshipService(this._ref);
  final Ref _ref;

  PreferencesServiceModel get _preferencesService =>
      _ref.read(preferencesService);

  FellowshipRepositoryModel get _fellowshipRepository =>
      _ref.read(fellowshipRepository);

  String? get _fellowshipId => _preferencesService.fellowshipId;

  @override
  bool get hasJoinedFellowship => _fellowshipId != null;

  Fellowship? _fellowship;

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
  Future<bool> selectCharacter({
    required String username,
    required Character character,
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
        given: 0,
      );

      await _fellowshipRepository.update(
        _fellowshipId!,
        fellowship,
      );

      _preferencesService.character = character;

      return true;
    } catch (e) {
      logError('selectCharacter', e);
      return false;
    }
  }

  @override
  Future<bool> joinFellowship(String fellowshipId) async {
    try {
      final Fellowship? fellowship = await _fellowshipRepository.get(
        fellowshipId,
      );

      if (fellowship == null) {
        return false;
      }

      _preferencesService.fellowshipId = fellowshipId;
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
      return true;
    } catch (e) {
      logError('leaveFellowship', e);
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
