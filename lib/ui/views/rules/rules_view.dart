library rules_view;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'rules_view_model.dart';

part 'rules_mobile.dart';

class RulesView extends ConsumerWidget {
  const RulesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RulesViewModel viewModel = ref.watch(rulesViewModel);

    return _RulesMobile(viewModel);
  }
}
