import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../services/app/router_service.dart';
import '../../widgets/button.dart';
import 'onboarding_view_model.dart';
import 'widgets/onboarding_scaffold.dart';

part 'name_mobile.dart';

class NameView extends ConsumerWidget {
  const NameView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OnboardingViewModel viewModel = ref.watch(onboardingViewModel);

    return _NameMobile(viewModel);
  }
}
