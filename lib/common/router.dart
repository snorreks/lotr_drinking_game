import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lotr_drinking_game/models/user.dart';

import '../../ui/views/home/home_view.dart';
import '../services/api/auth_service.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/startup/startup_view.dart';

final GlobalKey<NavigatorState> _key = GlobalKey<NavigatorState>();

final Provider<GoRouter> routerProvider = Provider<GoRouter>((ref) {
  final User? currentUser = ref.read(authService).user;

  return GoRouter(
    navigatorKey: _key,
    debugLogDiagnostics: true,
    initialLocation: StartupView.routeLocation,
    routes: [
      GoRoute(
        path: StartupView.routeLocation,
        name: StartupView.routeName,
        builder: (context, state) {
          return const StartupView();
        },
      ),
      GoRoute(
        path: HomeView.routeLocation,
        name: HomeView.routeName,
        builder: (context, state) {
          return const HomeView();
        },
      ),
      GoRoute(
        path: LoginView.routeLocation,
        name: LoginView.routeName,
        builder: (context, state) {
          return const LoginView();
        },
      ),
    ],
    redirect: (context, state) {
      // If our async state is loading, don't perform redirects, yet
      if (state.location == StartupView.routeLocation) {
        return null;
      }

      // Here we guarantee that hasData == true, i.e. we have a readable value

      // This has to do with how the FirebaseAuth SDK handles the "log-in" state
      // Returning `null` means "we are not authorized"
      final isAuth = currentUser != null;

      final isLoggingIn = state.location == LoginView.routeLocation;
      if (isLoggingIn) {
        return isAuth ? HomeView.routeLocation : null;
      }
      return isAuth ? null : StartupView.routeLocation;
    },
  );
});
