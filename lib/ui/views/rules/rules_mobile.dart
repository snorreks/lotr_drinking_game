part of 'rules_view.dart';

class _RulesMobile extends StatelessWidget {
  const _RulesMobile(this.viewModel);
  final RulesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Rule difficulty',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Easy rules are always active. Medium adds the medium '
                      'rules on top, and Hard includes every rule. Choose your '
                      'own difficulty when you join a fellowship.',
                    ),
                    const SizedBox(height: 12.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: RuleDifficulty.values
                          .map(
                            (RuleDifficulty difficulty) =>
                                DifficultyBadge(difficulty),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _expansionList(context, viewModel.rules),
        ],
      ),
    );
  }

  ExpansionPanel _expansionItem(BuildContext context, RuleItem ruleItem) {
    final List<RuleItem>? subRuleItems = ruleItem.subRuleItems;
    if (subRuleItems != null) {
      return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(title: Text(ruleItem.title));
        },
        canTapOnHeader: true,
        body: _expansionList(
          context,
          subRuleItems,
          parent: ruleItem,
        ),
        isExpanded: ruleItem.isExpanded,
      );
    }
    final List<GameRule>? rules = ruleItem.rules;

    if (rules == null) {
      throw const FormatException(
        'Either rules or subRuleItems must be provided',
      );
    }

    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(title: Text(ruleItem.title));
      },
      canTapOnHeader: true,
      body: Column(
        children: <ListTile>[
          for (final GameRule rule in rules)
            ListTile(
              title: Text(rule.text),
              trailing: DifficultyBadge(rule.difficulty),
            ),
        ],
      ),
      isExpanded: ruleItem.isExpanded,
    );
  }

  Column _expansionList(
    BuildContext context,
    List<RuleItem> ruleItems, {
    RuleItem? parent,
  }) {
    return Column(
      children: <Widget>[
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            viewModel.setPanelExpanded(
              index,
              isExpanded,
              parent: parent,
            );
          },
          expandedHeaderPadding: const EdgeInsets.all(8),
          children: <ExpansionPanel>[
            for (int index = 0; index < ruleItems.length; index++)
              _expansionItem(context, ruleItems[index]),
          ],
        ),
      ],
    );
  }
}
