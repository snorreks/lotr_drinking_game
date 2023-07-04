import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/base_service.dart';

/// AnalyticsService logs events to Google Analytics
abstract class AnalyticsServiceModel {
  /// Gets a FirebaseAnalyticsObserver instance to analyze the navigation in the app.
  FirebaseAnalyticsObserver get analyticsObserver;

  /// Log
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters});
}

class AnalyticsService extends BaseService implements AnalyticsServiceModel {
  AnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  @override
  FirebaseAnalyticsObserver get analyticsObserver =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  @override
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) =>
      _analytics.logEvent(name: name, parameters: parameters);
}

final Provider<AnalyticsServiceModel> analyticsService =
    Provider<AnalyticsServiceModel>(
  (ProviderRef<AnalyticsServiceModel> ref) =>
      AnalyticsService(FirebaseAnalytics.instance),
);
