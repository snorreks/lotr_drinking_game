import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_view_model.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/app/dialog_service.dart';
import '../../../services/app/router_service.dart';

class CalledOutViewModel extends BaseNotifierViewModel {
  CalledOutViewModel(this._ref);

  final Ref _ref;

  Future<void> refuseCallout() async {
    return _resolveCallout(false);
  }

  Future<void> acceptCallout() async {
    return _resolveCallout(true);
  }

  Future<void> _resolveCallout(bool hasAccepted) async {
    busy = true;

    await _ref.read(fellowshipService).resolveCallout(hasAccepted);
    busy = false;

    if (hasAccepted) {
      _ref.read(dialogService).showNotification(
            const NotificationRequest(
                message: 'You have accepted the callout. +2 drinks'),
          );
    } else {
      _ref.read(dialogService).showNotification(
            const NotificationRequest(
              type: NotificationType.error,
              title: 'Bitch',
              message: 'You have declined the callout',
            ),
          );
    }
    _ref.read(routerService).pop();
  }
}

final AutoDisposeChangeNotifierProvider<CalledOutViewModel> calledOutViewModel =
    ChangeNotifierProvider.autoDispose((
  AutoDisposeChangeNotifierProviderRef<Object?> ref,
) {
  final CalledOutViewModel viewModel = CalledOutViewModel(ref);
  return viewModel;
});
