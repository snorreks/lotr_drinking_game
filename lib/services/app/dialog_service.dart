import 'package:flutter/material.dart' show GlobalKey, NavigatorState;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/base_service.dart';
import '../../models/fellowship_member.dart';

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
  void registerNotificationListener(Function(NotificationRequest) listener);

  void registerCalloutListener(Function(FellowshipMember?) listener);

  void registerCalledOutListener(Function(Callout) listener);

  void registerSummaryDialogListener(Function() listener);

  /// Displays a notification dialog
  void showNotification(NotificationRequest notificationRequest);

  void showCalloutDialog(FellowshipMember? selectedPlayer);

  void showCalledOutDialog(Callout callout);

  void showSummaryDialog();
}

class DialogService extends BaseService implements DialogServiceModel {
  final GlobalKey<NavigatorState> _dialogNavigationKey =
      GlobalKey<NavigatorState>();

  // Listeners
  late Function(NotificationRequest) _showNotificationListener;
  late Function(FellowshipMember?) _showCalloutListener;
  late Function(Callout) _showCalledOutListener;
  late Function() _showSummaryDialogListener;

  @override
  GlobalKey<NavigatorState> get dialogNavigationKey => _dialogNavigationKey;

  @override
  void registerNotificationListener(Function(NotificationRequest) listener) {
    _showNotificationListener = listener;
  }

  @override
  void registerCalloutListener(Function(FellowshipMember?) listener) {
    _showCalloutListener = listener;
  }

  @override
  void registerCalledOutListener(Function(Callout) listener) {
    _showCalledOutListener = listener;
  }

  @override
  void registerSummaryDialogListener(Function() listener) {
    _showSummaryDialogListener = listener;
  }

  @override
  void showNotification(NotificationRequest notificationRequest) {
    _showNotificationListener(notificationRequest);
  }

  @override
  void showCalloutDialog(FellowshipMember? selectedPlayer) {
    _showCalloutListener(selectedPlayer);
  }

  @override
  void showCalledOutDialog(Callout callout) {
    _showCalledOutListener(callout);
  }

  @override
  void showSummaryDialog() {
    _showSummaryDialogListener();
  }
}

final Provider<DialogServiceModel> dialogService =
    Provider<DialogServiceModel>((_) => DialogService());
