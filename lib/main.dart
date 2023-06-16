import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'services/app/application_service.dart';
import 'services/app/router_service.dart';

Future<void> main() async {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ApplicationServiceModel application = ref.watch(applicationService);
    final GoRouter router = ref.read(routerService).router;

    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      title: 'LOTR',
      theme: application.themeData,
    );
  }
}
