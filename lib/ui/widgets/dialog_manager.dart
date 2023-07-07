import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/app/dialog_service.dart';
import '../../models/fellowship_member.dart';
import 'called_out/called_out_dialog.dart';
import 'callout/callout_dialog.dart';
import 'movie_summary/summary_dialog.dart';

/// This handles popup dialogs and snackbar in the application.
class DialogManager extends ConsumerStatefulWidget {
  const DialogManager(this._child, {super.key});
  final Widget _child;

  @override
  ConsumerState<DialogManager> createState() => _DialogManagerState();
}

class _DialogManagerState extends ConsumerState<DialogManager> {
  late DialogServiceModel _dialogService;

  @override
  void initState() {
    super.initState();
    _dialogService = ref.read(dialogService);
    _dialogService.registerNotificationListener(_showNotification);
    _dialogService.registerCalledOutListener(_showCalledOutDialog);
    _dialogService.registerCalloutListener(_showCalloutDialog);
    _dialogService.registerSummaryDialogListener(_showSummaryDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget._child;
  }

  Icon _getNotificationIcon(
    NotificationType notificationType, {
    double iconSize = 36.0,
  }) {
    switch (notificationType) {
      case NotificationType.error:
        return Icon(
          Icons.error,
          color: Colors.red,
          size: iconSize,
        );

      case NotificationType.warning:
        return Icon(
          Icons.warning,
          color: Colors.yellow,
          size: iconSize,
        );
      case NotificationType.success:
        return Icon(
          Icons.check_circle,
          color: Colors.green,
          size: iconSize,
        );
      case NotificationType.info:
        return Icon(
          Icons.info,
          color: Colors.blue,
          size: iconSize,
        );
    }
  }

  Future<void> _showNotification(NotificationRequest request) {
    return showFlash(
      context: context,
      duration: Duration(seconds: request.duration),
      builder: (_, FlashController<void> controller) {
        return FlashBar<void>(
          position: FlashPosition.top,
          controller: controller,
          icon: _getNotificationIcon(request.type),
          content: request.title != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(request.title!),
                    Text(request.message)
                  ],
                )
              : Text(request.message),
          primaryAction: IconButton(
            icon: const Icon(Icons.close),
            color: Colors.black,
            onPressed: () => controller.dismiss(),
          ),
        );
      },
    );
  }

  Future<void> _showCalledOutDialog(Callout callout) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CalledOutDialog(callout: callout);
      },
    );
  }

  Future<void> _showCalloutDialog(FellowshipMember? member) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CalloutDialog(member: member);
      },
    );
  }

  Future<void> _showSummaryDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return const SummaryDialog();
        });
  }
}
