library home_view;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/characters.dart';
import '../../../constants/game_rules.dart';
import '../../../models/fellowship.dart';
import '../../../models/fellowship_member.dart';
import '../../widgets/avatar.dart';
import '../../widgets/loading.dart';
import 'home_view_model.dart';

part 'widgets/default_view.dart';
part 'widgets/zen_view.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeViewModel viewModel = ref.watch(homeViewModel);

    return StreamBuilder<bool>(
      stream: viewModel.zenModeEnabledStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return _ZenView(viewModel);
        }
        return _DefaultView(viewModel);
      },
    );
  }
}
