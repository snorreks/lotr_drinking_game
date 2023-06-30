import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/splash_screen.dart';
import 'startup_view_model.dart';

class StartupView extends ConsumerWidget {
  const StartupView({super.key});
  static String get routeName => 'splash';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<void>(
          future: ref.watch(startupViewModel).initialize(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            return const SplashScreen();
          },
        ),
      ),
    );
  }
}
