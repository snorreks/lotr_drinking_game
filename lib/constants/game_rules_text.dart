import 'package:flutter/material.dart';

///This will be used for reformatted logic of rules_mobile. This is a WIP,
///but allows for further customization of how the rules text can be expressed.
///Will be finished at some point
class GameRulesText {
  static final RichText basicRules = RichText(
    text: const TextSpan(
      text:
          'This drinking game works by there being collective rules, meaning rules effecting everyone and character-based rules, effecting only the specific character a player has chosen. When a "Take a drink" or a character-based rule occurs, take only a singular drink out of your drink and press the plus button. If a "Down the Hatch" rule occurs, you must finish whatever contents there are left in the vessel you pour your drink in. There are also additional rules, which are optional rules which the creator of the room selected. These can have varying effects, like having to take extra drinks, taking fewer drinks or being punished for breaking rules.',
      style: TextStyle(fontSize: 12),
    ),
  );

  static final List<RichText> normalRules = <RichText>[
    RichText(
      text: const TextSpan(
        text: 'There is a close up of the Eye of Sauron.',
        style: TextStyle(fontSize: 12),
      ),
    ),
    RichText(
      text: const TextSpan(
        text: 'A main bad guy dies',
        style: TextStyle(fontSize: 12),
      ),
    ),
    RichText(
      text: const TextSpan(
        text:
            'When victory is achieved in a battle, everyone raises a toast and takes a sip.',
        style: TextStyle(fontSize: 12),
      ),
    ),
    RichText(
      text: const TextSpan(
        text: 'A character gives an epic speech or monologue.',
        style: TextStyle(fontSize: 12),
      ),
    ),
    RichText(
      text: const TextSpan(
        text:
            'Memes like "One does not simply walk into Mordor", "You Shall Not Pass" or "...and my axe!"',
        style: TextStyle(fontSize: 12),
      ),
    )
    // Add all your normal rules here
  ];

  static final List<RichText> dthRules = <RichText>[
    RichText(
      text: const TextSpan(
        text: 'The fellowship is founded.',
        style: TextStyle(fontSize: 14),
      ),
    ),
    RichText(
      text: const TextSpan(
        text: 'Gandalf the White debuts.',
        style: TextStyle(fontSize: 14),
      ),
    ),
    RichText(
      text: const TextSpan(
        text: 'The wall falls.',
        style: TextStyle(fontSize: 14),
      ),
    ),
    RichText(
      text: const TextSpan(
        text: 'The ring is destroyed (for those who are still alive)',
        style: TextStyle(fontSize: 14),
      ),
    )
  ];

  static final List<RichText> additionalRules = <RichText>[
    RichText(
      text: const TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'The Eye of Sauron',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          TextSpan(
            text:
                "\nIf a viewer (known as the sneaky hobbit) does not drink when clearly prompted to by the rules, another viewer (Sauron) may call the sneaky hobbit out. If the other viewers agree with Sauron's call-out, the sneaky hobbit has to drink two.",
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    ),
    // Add all your additionalRules here
  ];
}
