part of 'rules_view.dart';

class _RulesMobile extends StatelessWidget {
  const _RulesMobile(this.viewModel);
  final RulesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _expansionList(context, viewModel.rules),
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
    final List<String>? rules = ruleItem.rules;

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
      body: Column(children: <ListTile>[
        for (String rule in rules) ListTile(title: Text(rule)),
      ]),
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
            viewModel.togglePanel(index, isExpanded, parent: parent);
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
