library home_view;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_view_model.dart';

part 'home_mobile.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});
  static String get routeName => 'home';
  static String get routeLocation => '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeViewModel viewModel = ref.watch(homeViewModel);

    return _HomeMobile(viewModel);
  }
}
