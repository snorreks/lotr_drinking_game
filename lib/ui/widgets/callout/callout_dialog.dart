import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/fellowship_member.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/app/preferences_service.dart';
import '../button.dart';
import 'callout_dialog_model.dart';

final AutoDisposeProviderFamily<CalloutViewModel, CalloutParams>
    calloutViewModel =
    Provider.autoDispose.family<CalloutViewModel, CalloutParams>(
  (AutoDisposeProviderRef<CalloutViewModel> ref, CalloutParams params) {
    final PreferencesServiceModel prefs = ref.watch(preferencesService);
    final FellowshipServiceModel fellowship = ref.watch(fellowshipService);
    return CalloutViewModel(prefs, fellowship, params);
  },
);

class CalloutDialog extends ConsumerWidget {
  const CalloutDialog({super.key, this.member, this.currentMovie});

  final FellowshipMember? member;
  final String? currentMovie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CalloutParams viewModelState = ref
        .watch(
          calloutViewModel(
            CalloutParams(selectedPlayer: member, currentMovie: currentMovie),
          ),
        )
        .state;

    final CalloutViewModel viewModel = ref.read(calloutViewModel(
      CalloutParams(selectedPlayer: member, currentMovie: currentMovie),
    ));

    print('Player: ${viewModelState.selectedPlayer?.name}');
    print('Category: ${viewModelState.selectedCategory}');
    print('Rule: ${viewModelState.selectedRule}');

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
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5, right: 5),
                    child: Button(
                      onPressed: viewModel.canSubmit
                          ? () async {
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
                value: viewModelState.selectedPlayer,
                hint: const Text('Select player'),
                items: viewModel.players
                    .map<DropdownMenuItem<FellowshipMember>>(
                        (FellowshipMember player) {
                  return DropdownMenuItem<FellowshipMember>(
                    value: player,
                    child: Text(player.name),
                  );
                }).toList(),
                onChanged: (FellowshipMember? newPlayer) =>
                    viewModel.selectPlayer(newPlayer),
              ),
              DropdownButton<String>(
                value: viewModelState.selectedCategory,
                hint: const Text('Select category'),
                items: viewModel.categories
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newCategory) =>
                    viewModel.selectCategory(newCategory),
              ),
              if (viewModel.rules != null)
                DropdownButton<String>(
                  value: viewModelState.selectedRule,
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
                  onChanged: (String? newRule) => viewModel.selectRule(newRule),
                )
            ],
          ),
        ),
      ),
    );
  }
}
