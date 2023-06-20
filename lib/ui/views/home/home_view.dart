library home_view;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/characters.dart';
import '../../../constants/game_rules.dart';
import '../../../models/fellowship.dart';
import '../../../models/fellowship_member.dart';
import '../character/character_view.dart';
import 'home_view_model.dart';

part 'home_mobile.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeViewModel viewModel = ref.watch(homeViewModel);

    return StreamBuilder<bool>(
      stream: viewModel.showCharacterSelectStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return const CharacterView();
        } else {
          return _HomeMobile(viewModel);
        }
      },
    );
  }
}
