part of 'rules_view.dart';

class _RulesMobile extends StatefulWidget {
  const _RulesMobile(this.viewModel);
  final RulesViewModel viewModel;

  @override
  _RulesMobileState createState() => _RulesMobileState();
}

class _RulesMobileState extends State<_RulesMobile> {
  // Initialize all panels as closed.
  // This assumes the total number of panels to be 4 (for basics, take a drink when, down the hatch, additional rules)
  // + the number of Character.values
  final List<bool> _panelOpen =
      List<bool>.filled(5 + Character.values.length, false);

  final List<bool> _characterPanelOpen =
      List<bool>.filled(Character.values.length, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Rules'),
      ),
      body: ListView(
        children: [
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _panelOpen[index] = !isExpanded;
              });
            },
            expandedHeaderPadding: EdgeInsets.all(8),
            children: [
              _buildPanel('Basics', [GameRules.basicRules], 0),
              _buildPanel('Take a drink when', GameRules.normalRules, 1),
              _buildPanel('Down the Hatch', GameRules.dthRules, 2),
              _buildPanel(
                  'Additional Rules',
                  GameRules.additionalRules
                      .map((RuleWithName ruleWithName) =>
                          '${ruleWithName.ruleName}: ${ruleWithName.ruleDescription}')
                      .toList(),
                  3),
              ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(title: Text('Characters Rules'));
                },
                canTapOnHeader: true,
                body: Column(
                  children: Character.values
                      .asMap()
                      .entries
                      .map((MapEntry<int, Character> entry) {
                    final int index = entry.key;
                    final Character character = entry.value;
                    return ExpansionPanelList(
                      expansionCallback:
                          (int innerIndex, bool innerIsExpanded) {
                        setState(() {
                          _characterPanelOpen[index] = !innerIsExpanded;
                        });
                      },
                      children: [
                        _buildPanel(
                            character.displayName, character.rules, index,
                            isCharacterPanel: true)
                      ],
                    );
                  }).toList(),
                ),
                isExpanded: _panelOpen[4],
              ),
            ],
          ),
        ],
      ),
    );
  }

  ExpansionPanel _buildPanel(String header, List<dynamic> body, int index,
      {bool isCharacterPanel = false}) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(title: Text(header));
      },
      canTapOnHeader: true,
      body: Column(
        children: body.map((dynamic item) {
          if (item is RuleWithName) {
            final List<String>? examples = item.ruleExamples;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.ruleName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    item.ruleDescription,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                  if (examples != null)
                    ...examples.map(
                      (example) => Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          example,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            );
          } else if (item is String) {
            return ListTile(title: Text(item));
          } else {
            throw FormatException('Unsupported body item type');
          }
        }).toList(),
      ),
      isExpanded:
          isCharacterPanel ? _characterPanelOpen[index] : _panelOpen[index],
    );
  }
}
