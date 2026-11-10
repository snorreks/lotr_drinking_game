import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/characters.dart';
import '../../../constants/game_rule.dart';
import '../../../services/app/router_service.dart';
import '../../widgets/button.dart';
import 'onboarding_view_model.dart';
import 'widgets/onboarding_scaffold.dart';

part 'difficulty_mobile.dart';

class DifficultyView extends ConsumerWidget {
  const DifficultyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OnboardingViewModel viewModel = ref.watch(onboardingViewModel);

    return _DifficultyMobile(viewModel);
  }
}
