import 'package:flutter/material.dart';

import 'button.dart';

class CalloutModal extends StatelessWidget {
  const CalloutModal({
    required this.players,
    required this.rules,
    required this.onSend,
    super.key,
  });
  final List<String> players;
  final Map<String, List<String>> rules;
  final Function(String player, String category, String rule) onSend;

  @override
  Widget build(BuildContext context) {
    String? playerValue;
    String? categoryValue;
    String? ruleValue;
    List<String>? selectedRules;

    List<String> ruleCategories = [
      'Take a drink',
      'Down the Hatch',
      'Character rules'
    ];
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                  color: Colors.transparent,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0, //Soft and cute shadow
                        )
                      ],
                    ),
                    alignment: Alignment.topLeft,
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
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color),
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 5, right: 5),
                                child: Button(
                                  onPressed: () {
                                    if (playerValue != null &&
                                        categoryValue != null &&
                                        ruleValue != null) {
                                      onSend(playerValue!, categoryValue!,
                                          ruleValue!);
                                    }
                                  },
                                  text: 'Send',
                                )),
                          ],
                        ),
                        const SizedBox(height: 5),
                        RichText(
                            text: TextSpan(
                          text: 'The Eye Of Sauron\n',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color),
                        )),
                        RichText(
                            text: TextSpan(
                          text:
                              'Did you notice that a player has not been drinking, despite their rules appearing? Call them out and make them drink double!',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color),
                        )),
                        DropdownButton<String>(
                            //This will be used for which player.
                            items: players
                                .map<DropdownMenuItem<String>>((String player) {
                              return DropdownMenuItem<String>(
                                value: player,
                                child: Text(player),
                              );
                            }).toList(), //retrieve a list of all available players. Select the correct one.
                            onChanged: (String? value) {
                              setState(() {
                                playerValue = value;
                              });
                            }),
                        DropdownButton<String>(
                            items: rules.keys
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                categoryValue = value;
                                selectedRules = rules[value];
                              });
                            }),
                        if (selectedRules != null)
                          DropdownButton<String>(
                              items: selectedRules!
                                  .map<DropdownMenuItem<String>>((String rule) {
                                return DropdownMenuItem<String>(
                                  value: rule,
                                  child: Text(rule),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  ruleValue = value;
                                });
                              }),
                      ],
                    ),
                  ));
            },
          );
        });

    // Return an empty container. This widget doesn't need to display anything itself.
    return Container();
  }
}
