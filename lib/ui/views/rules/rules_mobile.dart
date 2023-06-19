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
      List<bool>.filled(4 + Character.values.length, false);

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
              ...Character.values
                  .asMap()
                  .entries
                  .map((MapEntry<int, Character> entry) {
                final int index = 4 + entry.key;
                final Character character = entry.value;
                return _buildPanel('Character Rules - ${character.displayName}',
                    character.rules, index);
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  ExpansionPanel _buildPanel(String header, List<String> body, int index) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(title: Text(header));
      },
      body: Column(
        children:
            body.map((String item) => ListTile(title: Text(item))).toList(),
      ),
      isExpanded: _panelOpen[index],
    );
  }
}
