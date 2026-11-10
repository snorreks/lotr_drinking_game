import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../common/base_view_model.dart';
import '../../../constants/characters.dart';
import '../../../constants/game_rule.dart';
import '../../../models/fellowship.dart';
import '../../../services/api/fellowship_service.dart';

class OnboardingViewModel extends BaseNotifierViewModel {
  OnboardingViewModel(this._ref);

  final Ref _ref;

  final TextEditingController nameController = TextEditingController();

  String? nameError;
  String? submitError;
  Character? selectedCharacter;
  RuleDifficulty selectedDifficulty = RuleDifficulty.easy;
  bool submitting = false;

  String get name => nameController.text.trim();

  bool get canContinueFromName => name.isNotEmpty && name.length <= 30;

  Stream<Fellowship?> get fellowshipStream =>
      _ref.read(fellowshipService).fellowshipStream;

  void onNameChanged(String value) {
    if (nameError != null) {
      nameError = null;
    }
    notifyListeners();
  }

  bool validateName() {
    if (name.isEmpty) {
      nameError = 'Please enter a name.';
      notifyListeners();
      return false;
    }
    if (name.length > 30) {
      nameError = 'Names can be at most 30 characters.';
      notifyListeners();
      return false;
    }
    nameError = null;
    notifyListeners();
    return true;
  }

  void selectCharacter(Character character) {
    selectedCharacter = character;
    notifyListeners();
  }

  void selectDifficulty(RuleDifficulty difficulty) {
    selectedDifficulty = difficulty;
    notifyListeners();
  }

  bool isTaken(Fellowship fellowship, Character character) {
    if (character == Character.merrypippin) {
      return false;
    }

    return fellowship.members.containsKey(character);
  }

  Future<bool> complete() async {
    if (!validateName()) {
      return false;
    }

    final Character? character = selectedCharacter;
    if (character == null) {
      submitError = 'Please select a character.';
      notifyListeners();
      return false;
    }

    final Fellowship? latestFellowship =
        await _ref.read(fellowshipService).fellowshipStream.first;
    if (latestFellowship != null &&
        character != Character.merrypippin &&
        latestFellowship.members.containsKey(character)) {
      selectedCharacter = null;
      submitError = 'That character was just taken. Go back and choose '
          'another one.';
      notifyListeners();
      return false;
    }

    submitting = true;
    submitError = null;
    notifyListeners();

    final bool success = await _ref.read(fellowshipService).selectCharacter(
          username: name,
          character: character,
          difficulty: selectedDifficulty,
        );

    submitting = false;
    if (!success) {
      submitError = 'Could not join the fellowship. Please try again.';
    }
    notifyListeners();

    return success;
  }

  Future<bool> leaveFellowship() async {
    final bool success = await _ref.read(fellowshipService).leaveFellowship();
    if (success) {
      reset();
    }
    return success;
  }

  void reset() {
    nameController.clear();
    nameError = null;
    submitError = null;
    selectedCharacter = null;
    selectedDifficulty = RuleDifficulty.easy;
    submitting = false;
    notifyListeners();
  }
}

final ChangeNotifierProvider<OnboardingViewModel> onboardingViewModel =
    ChangeNotifierProvider<OnboardingViewModel>(
  (Ref ref) => OnboardingViewModel(ref),
);
