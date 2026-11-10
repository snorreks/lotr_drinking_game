import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/characters.dart';
import '../../../models/fellowship.dart';
import '../../../services/app/router_service.dart';
import '../../widgets/avatar.dart';
import '../../widgets/button.dart';
import '../../widgets/loading.dart';
import 'onboarding_view_model.dart';
import 'widgets/onboarding_scaffold.dart';

part 'character_mobile.dart';

class CharacterSelectionView extends ConsumerWidget {
  const CharacterSelectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OnboardingViewModel viewModel = ref.watch(onboardingViewModel);

    return _CharacterMobile(viewModel);
  }
}
