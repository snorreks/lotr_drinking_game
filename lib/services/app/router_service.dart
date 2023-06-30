import 'package:flutter/material.dart'
    show BuildContext, GlobalKey, NavigatorObserver, NavigatorState, Widget;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/base_service.dart';
import '../../ui/views/home/home_view.dart';
import '../../ui/views/leader_board/leader_board_view.dart';
import '../../ui/views/login/login_view.dart';
import '../../ui/views/root/root_view.dart';
import '../../ui/views/rules/rules_view.dart';
import '../../ui/views/startup/startup_view.dart';
import '../../ui/widgets/dialog_manager.dart';
import '../api/analytics_service.dart';
import '../api/fellowship_service.dart';
import 'application_service.dart';

enum Location { login, home, leaderBoard, rules }

extension LocationExtension on Location {
  String get value {
    switch (this) {
      case Location.login:
        return '/login';
      case Location.home:
        return '/';
      case Location.leaderBoard:
        return '/leader-board';
      case Location.rules:
        return '/rules';
    }
  }

  String get name {
    switch (this) {
      case Location.login:
        return 'login';
      case Location.home:
        return 'home';
      case Location.leaderBoard:
        return 'leader-board';
      case Location.rules:
        return 'rules';
    }
  }
}

/// This service handles the navigation within the app.
///
/// The different [GlobalKey]'s are appNavigatorKey, homeNavigatorKey, collectionNavigatorKey, profileNavigatorKey and localNavigatorKey.
/// If the [GlobalKey] is the appNavigatorKey the main MaterialApp handles the navigation.
/// If the [GlobalKey] are collectionNavigatorKey, profileNavigatorKey and localNavigatorKey, the selected rootview handles the navigation.
abstract class RouterServiceModel {
  /// The navigate to a new scene.
  ///
  /// If navItem = null, it uses the appNavigatorKey.
  Future<void> go<T>(Location location);

  /// The navigate to a new scene removes the old scene.
  ///
  /// If navItem = null, it uses the appNavigatorKey.
  Future<T?> replace<T>(Location location);

  /// Pop the top-most route off the selected navItem.
  ///
  /// If navItem = null, it uses the appNavigatorKey.
  void pop<T>(T result);

  GoRouter get router;

  Location get location;
}

class RouterService extends BaseService implements RouterServiceModel {
  factory RouterService(Ref ref) {
    final GoRouter router = GoRouter(
      navigatorKey: _appNavigatorKey,
      debugLogDiagnostics: true,
      initialLocation: StartupView.routeLocation,
      observers: <NavigatorObserver>[
        if (ref.read(applicationService).initialized)
          ref.read(analyticsService).analyticsObserver,
        ref.read(applicationService).heroController,
      ],
      routes: <RouteBase>[
        GoRoute(
          path: StartupView.routeLocation,
          name: StartupView.routeName,
          builder: (BuildContext context, GoRouterState state) {
            return const StartupView();
          },
        ),
        GoRoute(
          path: Location.login.value,
          name: Location.login.name,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginView();
          },
        ),

        /// Application shell
        ShellRoute(
          navigatorKey: _rootNavigatorKey,
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return DialogManager(RootView(child: child));
          },
          routes: <RouteBase>[
            GoRoute(
              path: Location.home.value,
              name: Location.home.name,
              builder: (BuildContext context, GoRouterState state) {
                return const HomeView();
              },
            ),

            /// The first screen to display in the bottom navigation bar.
            GoRoute(
              path: Location.leaderBoard.value,
              name: Location.leaderBoard.name,
              builder: (BuildContext context, GoRouterState state) {
                return const LeaderBoardView();
              },
            ),
            GoRoute(
              path: Location.rules.value,
              name: Location.rules.name,
              builder: (BuildContext context, GoRouterState state) {
                return const RulesView();
              },
            ),
          ],
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final bool initialized = ref.read(applicationService).initialized;

        if (!initialized) {
          return StartupView.routeLocation;
        }

        if (state.location == StartupView.routeLocation) {
          return null;
        }

        final bool hasJoinedFellowship =
            ref.read(fellowshipService).hasJoinedFellowship;

        if (!hasJoinedFellowship) {
          return Location.login.value;
        }

        if (state.location == Location.login.value) {
          return Location.home.value;
        }

        return null;
      },
    );
    return RouterService._(router);
  }
  RouterService._(this._router);

  @override
  Location get location {
    final String location =
        _router.routerDelegate.currentConfiguration.uri.toString();
    return Location.values.firstWhere(
      (Location l) => l.value == location,
      orElse: () => Location.home,
    );
  }

  static final GlobalKey<NavigatorState> _appNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'app');
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  final GoRouter _router;

  @override
  GoRouter get router => _router;

  @override
  Future<void> go<T>(Location location) async {
    return router.go(location.value);
  }

  @override
  Future<T?> replace<T>(Location location) async {
    return router.replace(location.value);
  }

  @override
  void pop<T>(T result) {
    return router.pop();
  }
}

final Provider<RouterServiceModel> routerService = Provider<RouterServiceModel>(
  (ProviderRef<RouterServiceModel> ref) => RouterService(ref),
);
