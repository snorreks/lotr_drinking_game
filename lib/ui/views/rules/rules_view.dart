library rules_view;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/characters.dart';
import '../../../constants/game_rules.dart';
import '../character/character_view.dart';
import 'rules_view_model.dart';

part 'rules_mobile.dart';

class RulesView extends ConsumerWidget {
  const RulesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RulesViewModel viewModel = ref.watch(rulesViewModel);

    return StreamBuilder<bool>(
      stream: viewModel.showCharacterSelectStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return const CharacterView();
        } else {
          return _RulesMobile(viewModel);
        }
      },
    );
  }
}
