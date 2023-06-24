library drinking_setting_view;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/characters.dart';
import '../../../constants/game_rules.dart';
import '../../../models/fellowship.dart';
import '../character/character_view.dart';
import 'drinking_settings_view_model.dart';

part 'drinking_settings_mobile.dart';

class DrinkingSettingsView extends ConsumerWidget {
  const DrinkingSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DrinkingSettingsViewModel viewModel =
        ref.watch(drinkingSettingsViewModel);

    return StreamBuilder<bool>(
      stream: viewModel.showCharacterSelectStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return const CharacterView();
        } else {
          return _DrinkingSettingsMobile(viewModel);
        }
      },
    );
  }
}
