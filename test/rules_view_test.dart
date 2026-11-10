import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotr_drinking_game/ui/views/rules/rules_view.dart';
import 'package:lotr_drinking_game/ui/views/rules/rules_view_model.dart';

void main() {
  testWidgets('expands a collapsed rule panel', (WidgetTester tester) async {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: RulesView()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    bool basicsIsExpanded() => tester
        .widget<ExpansionPanelList>(find.byType(ExpansionPanelList).first)
        .children
        .first
        .isExpanded;

    final RulesViewModel viewModel = container.read(rulesViewModel);

    expect(find.text('Basics'), findsOneWidget);
    expect(viewModel.rules.first.isExpanded, isFalse);
    expect(basicsIsExpanded(), isFalse);

    await tester.tap(find.text('Basics'));
    await tester.pumpAndSettle();

    expect(viewModel.rules.first.isExpanded, isTrue);
    expect(basicsIsExpanded(), isTrue);
  });
}
