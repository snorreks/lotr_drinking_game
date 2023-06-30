import 'package:flutter/material.dart' show GlobalKey, NavigatorState;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/base_service.dart';

enum NotificationType {
  success,
  info,
  warning,
  error,
}

class NotificationRequest {
  const NotificationRequest({
    required this.message,
    this.type = NotificationType.success,
    this.title,
    this.duration = 4,
  });
  final String message;
  final NotificationType type;
  final String? title;
  final int duration;
}

/// This Service tells the [DialogManager] when and what notification/dialog to display.
abstract class DialogServiceModel {
  /// The navigation key to connect the service with the [DialogManager]
  GlobalKey<NavigatorState> get dialogNavigationKey;

  /// Register a listener to use display a notification in the [DialogManager]
  void registerNotificationListener(
      Function(NotificationRequest) showNotificationListener);

  /// Displays a notification dialog
  void showNotification(NotificationRequest notificationRequest);
}

class DialogService extends BaseService implements DialogServiceModel {
  final GlobalKey<NavigatorState> _dialogNavigationKey =
      GlobalKey<NavigatorState>();

  // Listeners
  late Function(NotificationRequest) _showNotificationListener;

  @override
  GlobalKey<NavigatorState> get dialogNavigationKey => _dialogNavigationKey;

  @override
  void registerNotificationListener(
      Function(NotificationRequest) showNotificationListener) {
    _showNotificationListener = showNotificationListener;
  }

  @override
  void showNotification(NotificationRequest notificationRequest) {
    _showNotificationListener(notificationRequest);
  }
}

final Provider<DialogServiceModel> dialogService =
    Provider<DialogServiceModel>((_) => DialogService());
