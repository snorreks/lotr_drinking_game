import 'package:flutter/material.dart';

import '../../constants/characters.dart';
import '../../models/fellowship_member.dart';
import 'button.dart';

void showCalloutModal({
  ///CalloutModal which allows players to call out each other.
  required BuildContext context,
  required List<FellowshipMember> players,
  required Map<String, List<String>>
      rules, //TODO: APPEND RULES FROM PLAYERS INTO THE RULES LIST? HOW TO DO?
  required Function(FellowshipMember player, String category, String rule)
      onSend,
}) {
  FellowshipMember? playerValue;
  String? categoryValue;
  String? ruleValue;
  List<String>? selectedRules;

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
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color),
                                ),
                              ),
                              Container(
                                  margin:
                                      const EdgeInsets.only(top: 5, right: 5),
                                  child: Button(
                                    onPressed: () {
                                      if (playerValue != null &&
                                          categoryValue != null &&
                                          ruleValue != null) {
                                        onSend(playerValue!, categoryValue!,
                                            ruleValue!);
                                        Navigator.of(context).pop();
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
                          DropdownButton<FellowshipMember>(
                              //This will be used for which player.
                              value: playerValue,
                              items: players
                                  .map<DropdownMenuItem<FellowshipMember>>(
                                      (FellowshipMember player) {
                                return DropdownMenuItem<FellowshipMember>(
                                  value: player,
                                  child: Text(player.character.displayName),
                                );
                              }).toList(), //retrieve a list of all available players. Select the correct one.
                              onChanged: (FellowshipMember? value) {
                                setState(() {
                                  playerValue = value;
                                });
                              }),
                          DropdownButton<String>(
                              value: categoryValue,
                              items: rules.keys.map<DropdownMenuItem<String>>(
                                  (String value) {
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
                                value: ruleValue,
                                items: selectedRules!
                                    .map<DropdownMenuItem<String>>(
                                        (String rule) {
                                  return DropdownMenuItem<String>(
                                      value: rule,
                                      child: Flexible(
                                        //text wrap, rules can be long
                                        child: Text(rule),
                                      ));
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    ruleValue = value;
                                  });
                                }),
                        ],
                      ),
                    )));
          },
        );
      });
}
