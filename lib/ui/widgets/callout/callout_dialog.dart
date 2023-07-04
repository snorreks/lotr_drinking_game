import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/fellowship_member.dart';
import '../button.dart';
import 'callout_dialog_model.dart';

class CalloutDialog extends ConsumerWidget {
  const CalloutDialog({this.member, super.key});

  final FellowshipMember? member;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CalloutViewModel viewModel = ref.watch(calloutViewModel(member));

    return ColoredBox(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 5, left: 10),
                    child: Text(
                      'Call out a player',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5, right: 5),
                    child: Button(
                      onPressed: viewModel.canSubmit && !viewModel.busy
                          ? () {
                              viewModel.sendCallout();
                              Navigator.of(context).pop();
                            }
                          : null,
                      text: 'Send',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    text: 'The Eye Of Sauron\n',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                        text: 'Did you notice that a player has not been '
                            'drinking, despite their rules appearing? Call them '
                            'out and make them drink double!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              DropdownButton<FellowshipMember>(
                  value: viewModel.selectedPlayer,
                  hint: const Text('Select player'),
                  items: viewModel.players
                      .map<DropdownMenuItem<FellowshipMember>>(
                          (FellowshipMember player) {
                    return DropdownMenuItem<FellowshipMember>(
                      value: player,
                      child: Text(player.name),
                    );
                  }).toList(),
                  onChanged: viewModel.selectPlayer),
              DropdownButton<String>(
                value: viewModel.selectedCategory,
                hint: const Text('Select category'),
                items: viewModel.categories
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: viewModel.selectCategory,
              ),
              if (viewModel.rules != null)
                DropdownButton<String>(
                    value: viewModel.selectedRule,
                    hint: const Text('Select rule'),
                    items: viewModel.rules!
                        .map<DropdownMenuItem<String>>((String rule) {
                      return DropdownMenuItem<String>(
                        value: rule,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.8, // Here we are setting width of DropdownMenuItem to be 80% of screen width.
                          child: Text(
                            rule,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: viewModel.selectRule)
            ],
          ),
        ),
      ),
    );
  }
}
