import 'package:flutter/material.dart' show GlobalKey, NavigatorState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/base_service.dart';
import '../../ui/views/home/home_view.dart';
import '../../ui/views/login/login_view.dart';
import '../../ui/views/startup/startup_view.dart';
import '../api/auth_service.dart';

enum NavItem {
  home,
}

/// This service handles the navigation within the app.
///
/// The different [GlobalKey]'s are appNavigatorKey, homeNavigatorKey, collectionNavigatorKey, profileNavigatorKey and localNavigatorKey.
/// If the [GlobalKey] is the appNavigatorKey the main MaterialApp handles the navigation.
/// If the [GlobalKey] are collectionNavigatorKey, profileNavigatorKey and localNavigatorKey, the selected rootview handles the navigation.
abstract class RouterServiceModel {
  bool disableNavigation = false;

  /// The navigation key of the main Material app
  GlobalKey<NavigatorState> get appNavigatorKey;

  /// The navigation key of the home view in the root view.
  GlobalKey<NavigatorState> get homeNavigatorKey;

  /// The navigate to a new scene.
  ///
  /// If navItem = null, it uses the appNavigatorKey.
  Future<void> go<T>(
    String location, {
    NavItem? navItem,
  });

  /// The navigate to a new scene removes the old scene.
  ///
  /// If navItem = null, it uses the appNavigatorKey.
  Future<T?> replace<T>(
    String location, {
    NavItem? navItem,
  });

  /// Pop the top-most route off the selected navItem.
  ///
  /// If navItem = null, it uses the appNavigatorKey.
  void pop<T>(T result, {NavItem? navItem});

  /// Get the navigation key that matches the navItem.
  ///
  /// If navItem = null, it return the appNavigatorKey.
  GlobalKey<NavigatorState> getKey(NavItem navItem);

  GoRouter get router;
}

class RouterService extends BaseService implements RouterServiceModel {
  RouterService(this._ref);

  static final GlobalKey<NavigatorState> _appNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>();

  final Ref _ref;

  @override
  bool disableNavigation = false;
  @override
  GlobalKey<NavigatorState> get appNavigatorKey => _appNavigatorKey;

  @override
  GlobalKey<NavigatorState> get homeNavigatorKey => _homeNavigatorKey;

  @override
  GlobalKey<NavigatorState> getKey(NavItem? navItem) {
    switch (navItem) {
      case NavItem.home:
        return homeNavigatorKey;
      case null:
        return appNavigatorKey;
    }
  }

  @override
  Future<void> go<T>(
    String location, {
    NavItem? navItem,
  }) async {
    if (disableNavigation) {
      return Future<void>.delayed(const Duration(microseconds: 1));
    }
    final GlobalKey<NavigatorState> key = getKey(navItem);
    logInfo('navigateToPage: pageRoute: $location, navItem: $navItem');
    if (key.currentState == null) {
      logWarning('navigateToPage: Navigator State is null');
      return;
    }
    return router.go(location);
  }

  @override
  Future<T?> replace<T>(
    String location, {
    NavItem? navItem,
  }) async {
    if (disableNavigation) {
      return Future<T>.delayed(const Duration(microseconds: 1));
    }
    final GlobalKey<NavigatorState> key = getKey(navItem);
    logInfo(
        'navigateToPageWithReplacement: pageRoute: $location, navItem: $navItem');
    if (key.currentState == null) {
      logWarning('navigateToPageWithReplacement: Navigator State is null');
      return null;
    }

    return router.replace(location);
  }

  @override
  void pop<T>(T result, {NavItem? navItem}) {
    if (disableNavigation) {
      return;
    }
    final GlobalKey<NavigatorState> key = getKey(navItem);
    logInfo('goBack: result=$result, navItem: $navItem');
    if (key.currentState == null) {
      logWarning('goBack: Navigator State is null');
      return;
    }
    router.pop();
  }

  @override
  GoRouter get router => GoRouter(
        navigatorKey: _appNavigatorKey,
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
          final isAuth = _ref.read(authService).user != null;

          final isLoggingIn = state.location == LoginView.routeLocation;
          if (isLoggingIn) {
            return isAuth ? HomeView.routeLocation : null;
          }
          return isAuth ? null : StartupView.routeLocation;
        },
      );
}

final Provider<RouterServiceModel> routerService =
    Provider<RouterServiceModel>((ref) => RouterService(ref));
