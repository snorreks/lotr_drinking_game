import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../common/base_view_model.dart';
import '../../../../../constants/characters.dart';
import '../../../../../services/api/fellowship_service.dart';
import '../../../models/fellowship.dart';
import '../../../models/fellowship_member.dart';

class CharacterViewModel extends BaseViewModel {
  CharacterViewModel(this._ref);
  final Ref _ref;

  final BehaviorSubject<bool?> _loadingSubject = BehaviorSubject<bool?>();
  final TextEditingController usernameController = TextEditingController();

  final BehaviorSubject<String> _usernameSubject = BehaviorSubject<String>();
  Stream<String> get username => _usernameSubject.stream;

  void changeUsername(String value) => _usernameSubject.add(value);

  List<Character> get characters => Character.values;

  Stream<Fellowship?> get fellowshipStream =>
      _ref.read(fellowshipService).fellowshipStream;

  Future<void> selectCharacter(Character character, bool isFirst) async {
    _loadingSubject.add(true);

    final String username = usernameController.text.isEmpty
        ? character.displayName
        : usernameController.text;

    await _ref.read(fellowshipService).selectCharacter(
        username: username, character: character, isFirst: isFirst);
    _loadingSubject.add(false);
  }

  bool isFirst(Fellowship fellowship) {
    if (fellowship.members.isEmpty) {
      return true;
    }
    return false;
  }

  bool isTaken(Fellowship fellowship, Character character) {
    if (character == Character.merrypippin) {
      return false;
    }

    final FellowshipMember? member = fellowship.members[character];
    return member != null;
  }
}

final AutoDisposeProvider<CharacterViewModel> homeViewModel =
    Provider.autoDispose((AutoDisposeProviderRef<CharacterViewModel> ref) {
  final CharacterViewModel viewModel = CharacterViewModel(ref);
  ref.onDispose(viewModel.dispose);
  return viewModel;
});
