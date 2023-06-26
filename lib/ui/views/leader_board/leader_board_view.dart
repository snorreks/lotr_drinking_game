library leader_board;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/characters.dart';
import '../../../constants/conversions.dart';
import '../../../models/fellowship.dart';
import '../../../models/fellowship_member.dart';
import '../character/character_view.dart';
import 'leader_board_view_model.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
part 'leader_board_mobile.dart';

class LeaderBoardView extends ConsumerWidget {
  const LeaderBoardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LeaderBoardViewModel viewModel = ref.watch(leaderBoardViewModel);

    if (viewModel.showCharacterSelectView) {
      return const CharacterView();
    }

    return _LeaderBoardMobile(viewModel);
  }
}
