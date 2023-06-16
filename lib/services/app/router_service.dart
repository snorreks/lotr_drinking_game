import 'package:flutter/material.dart'
    show BuildContext, GlobalKey, NavigatorState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/base_service.dart';
import '../../ui/views/home/home_view.dart';
import '../../ui/views/login/login_view.dart';
import '../../ui/views/startup/startup_view.dart';
import '../api/auth_service.dart';
import 'application_service.dart';

enum Location {
  login,
  home,
}

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
    Location location, {
    NavItem? navItem,
  });

  /// The navigate to a new scene removes the old scene.
  ///
  /// If navItem = null, it uses the appNavigatorKey.
  Future<T?> replace<T>(
    Location location, {
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
  factory RouterService(Ref ref) {
    final GoRouter router = GoRouter(
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
      redirect: (BuildContext context, GoRouterState state) {
        final bool initialized = ref.read(applicationService).initialized;

        if (!initialized) {
          return StartupView.routeLocation;
        }

        if (state.location == StartupView.routeLocation) {
          return null;
        }

        final bool isSignedIn = ref.read(authService).isSignedIn;

        if (!isSignedIn) {
          return LoginView.routeLocation;
        }

        if (state.location == LoginView.routeLocation) {
          return HomeView.routeLocation;
        }

        return null;
      },
    );
    return RouterService._(ref, router);
  }
  RouterService._(this._ref, this._router);

  static final GlobalKey<NavigatorState> _appNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>();

  final Ref _ref;
  final GoRouter _router;
  @override
  GoRouter get router => _router;

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
    Location location, {
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
    return router.go(_toLocationString(location));
  }

  @override
  Future<T?> replace<T>(
    Location location, {
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

    return router.replace(_toLocationString(location));
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

  String _toLocationString(Location location) {
    switch (location) {
      case Location.login:
        return LoginView.routeLocation;
      case Location.home:
        return HomeView.routeLocation;
    }
  }
}

final Provider<RouterServiceModel> routerService =
    Provider<RouterServiceModel>((ref) => RouterService(ref));
