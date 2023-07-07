import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'services/app/application_service.dart';
import 'services/app/preferences_service.dart';
import 'services/app/router_service.dart';
import 'ui/themes.dart';

Future<void> main() async {
  await Hive.initFlutter();
  final Box<dynamic> preferencesBox =
      await Hive.openBox<dynamic>('preferences');

  runApp(ProviderScope(child: App(preferencesBox)));
}

class App extends ConsumerWidget {
  const App(this._box, {super.key});
  final Box<dynamic> _box;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(preferencesService).setBox(_box);
    final ApplicationServiceModel application = ref.watch(applicationService);
    final GoRouter router = ref.read(routerService).router;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Fellowship Drinking Game',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: application.themeMode,
    );
  }
}
