import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/fellowship_member.dart';
import 'called_out_dialog_model.dart';

class CalledOutDialog extends ConsumerWidget {
  const CalledOutDialog({required this.callout, super.key});

  final Callout callout;

  String get rule => callout.rule;
  String get caller => callout.caller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CalledOutViewModel viewModel = ref.watch(calledOutViewModel);

    return AlertDialog(
      title: const Text('Called out'),
      content: Text(
        'A player has seen that you have skipped a sip.\nThey claim you forgot to drink when:\n$rule\nBy $caller',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: viewModel.acceptCallout,
          child: const Text('Approve'),
        ),
        TextButton(
          onPressed: viewModel.refuseCallout,
          child: const Text('Kotowaru'),
        ),
      ],
    );
  }
}
