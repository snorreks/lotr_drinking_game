import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotr_drinking_game/constants/characters.dart';
import 'package:lotr_drinking_game/models/fellowship.dart';
import 'package:lotr_drinking_game/models/fellowship_member.dart';
import 'package:lotr_drinking_game/services/api/fellowship_service.dart';
import 'package:lotr_drinking_game/ui/widgets/movie_summary/summary_dialog.dart';

class _FakeFellowshipService implements FellowshipServiceModel {
  _FakeFellowshipService(this.fellowship);

  @override
  final Fellowship? fellowship;

  @override
  bool get hasJoinedFellowship => true;

  @override
  Character? get character => Character.frodo;

  @override
  FellowshipMember? get member => fellowship?.members[Character.frodo];

  @override
  Stream<Character?> get characterStream => const Stream<Character?>.empty();

  @override
  Stream<FellowshipMember?> get memberStream =>
      const Stream<FellowshipMember?>.empty();

  @override
  Stream<Fellowship?> get fellowshipStream => const Stream<Fellowship?>.empty();

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
        '${invocation.memberName} is not used by the summary dialog',
      );
}

void main() {
  final DateTime movieStart = DateTime(2026, 1, 1, 20);

  Fellowship fakeFellowship() => Fellowship(
        id: 'test',
        pin: '123456',
        name: 'Test fellowship',
        currentMovie: 'The Two Towers',
        lastSummaryShown: 'Fellowship of the Ring',
        currentMovieStart: movieStart,
        members: <Character, FellowshipMember>{
          Character.frodo: FellowshipMember(
            name: 'Frodo',
            character: Character.frodo,
            drinks: <DateTime>[
              DateTime(2026, 1, 1, 10),
              movieStart,
              DateTime(2026, 1, 1, 21),
              DateTime(2026, 1, 1, 20, 50),
            ],
            saves: <DateTime>[DateTime(2026, 1, 1, 21, 5)],
          ),
          Character.sam: FellowshipMember(
            name: 'Sam',
            character: Character.sam,
            drinks: <DateTime>[
              DateTime(2026, 1, 1, 20, 10),
              DateTime(2026, 1, 1, 20, 12),
              DateTime(2026, 1, 1, 20, 14),
              DateTime(2026, 1, 1, 20, 16),
            ],
          ),
        },
      );

  Future<void> pumpDialog(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        // The Override type is not exported by riverpod 3.x, so the list
        // literal cannot carry a type annotation.
        // ignore: always_specify_types
        overrides: [
          fellowshipService
              .overrideWithValue(_FakeFellowshipService(fakeFellowship())),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SummaryDialog(endedMovie: 'Fellowship of the Ring'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the ended movie and totals', (WidgetTester tester) async {
    await pumpDialog(tester);

    expect(find.text('Fellowship of the Ring has ended!'), findsOneWidget);
    expect(find.text('7 drinks'), findsOneWidget);
    expect(find.text('1 skips'), findsOneWidget);
  });

  testWidgets('walks through all stat pages', (WidgetTester tester) async {
    await pumpDialog(tester);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Hall of fame'), findsOneWidget);
    expect(find.text('Chugging champion'), findsOneWidget);
    expect(find.text('Thirstiest of the night'), findsOneWidget);
    // Frodo and Sam tie on all-time drinks, and Sam leads this movie.
    expect(find.text('4 drinks'), findsNWidgets(3));

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Skips and chaos'), findsOneWidget);
    expect(find.text('Designated survivor'), findsOneWidget);
    expect(find.text('Most intense 5 minutes'), findsOneWidget);
    // Sam's most intense window is 20:12 to 20:16.
    expect(find.text('3 drinks'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Next up'), findsOneWidget);
    expect(find.text('The Two Towers'), findsOneWidget);
    expect(find.text('To the movie!'), findsOneWidget);
    expect(find.text('Next'), findsNothing);
  });
}
