library leader_board;

import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/characters.dart';
import '../../../constants/conversions.dart';
import '../../../models/fellowship.dart';
import '../../../models/fellowship_member.dart';
import '../../widgets/avatar.dart';
import '../../widgets/loading.dart';
import 'leader_board_view_model.dart';

part 'leader_board_mobile.dart';
part 'widgets/bar_chart.dart';
part 'widgets/line_chart.dart';

class LeaderBoardView extends ConsumerWidget {
  const LeaderBoardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LeaderBoardViewModel viewModel = ref.watch(leaderBoardViewModel);

    return _LeaderBoardMobile(viewModel);
  }
}
