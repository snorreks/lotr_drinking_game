import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotr_drinking_game/constants/characters.dart';
import 'package:lotr_drinking_game/models/fellowship.dart';
import 'package:lotr_drinking_game/models/fellowship_member.dart';
import 'package:lotr_drinking_game/models/movie_summary_stats.dart';

FellowshipMember _member(
  Character character,
  String name, {
  List<DateTime> drinks = const <DateTime>[],
  List<DateTime> saves = const <DateTime>[],
}) {
  return FellowshipMember(
    name: name,
    character: character,
    drinks: drinks,
    saves: saves,
  );
}

Fellowship _fellowship(
  List<FellowshipMember> members, {
  DateTime? currentMovieStart,
  String currentMovie = 'The Two Towers',
  String? lastSummaryShown = 'Fellowship of the Ring',
}) {
  return Fellowship(
    id: 'test',
    pin: '123456',
    name: 'Test fellowship',
    currentMovie: currentMovie,
    members: <Character, FellowshipMember>{
      for (final FellowshipMember member in members) member.character: member,
    },
    lastSummaryShown: lastSummaryShown,
    currentMovieStart: currentMovieStart,
  );
}

void main() {
  group('MovieSummaryStats.fromFellowship', () {
    test('finds the all-time leader', () {
      final Fellowship fellowship = _fellowship(<FellowshipMember>[
        _member(Character.frodo, 'Frodo', drinks: <DateTime>[
          DateTime(2026, 1, 1, 10),
        ]),
        _member(
          Character.sam,
          'Sam',
          drinks: <DateTime>[
            DateTime(2026, 1, 1, 10),
            DateTime(2026, 1, 1, 11),
            DateTime(2026, 1, 1, 12),
          ],
        ),
      ]);

      final MovieSummaryStats stats = MovieSummaryStats.fromFellowship(
        fellowship,
      );

      expect(stats.allTimeLeaders, hasLength(1));
      expect(stats.allTimeLeaders.first.name, 'Sam');
      expect(stats.allTimeLeaderDrinks, 3);
    });

    test('returns every member tied for the all-time lead', () {
      final Fellowship fellowship = _fellowship(<FellowshipMember>[
        _member(
          Character.frodo,
          'Frodo',
          drinks: <DateTime>[DateTime(2026, 1, 1, 10)],
        ),
        _member(
          Character.sam,
          'Sam',
          drinks: <DateTime>[DateTime(2026, 1, 1, 12)],
        ),
        _member(Character.gandalf, 'Gandalf'),
      ]);

      final MovieSummaryStats stats = MovieSummaryStats.fromFellowship(
        fellowship,
      );

      expect(stats.allTimeLeaderDrinks, 1);
      expect(
        stats.allTimeLeaders.map((FellowshipMember m) => m.name).toSet(),
        <String>{'Frodo', 'Sam'},
      );
    });

    test('only counts drinks at or after the movie start', () {
      final DateTime movieStart = DateTime(2026, 1, 1, 20);
      final Fellowship fellowship = _fellowship(
        <FellowshipMember>[
          _member(
            Character.frodo,
            'Frodo',
            drinks: <DateTime>[
              DateTime(2026, 1, 1, 10),
              DateTime(2026, 1, 1, 19, 59),
              movieStart,
              DateTime(2026, 1, 1, 21),
            ],
          ),
          _member(
            Character.sam,
            'Sam',
            drinks: <DateTime>[DateTime(2026, 1, 1, 21)],
          ),
        ],
        currentMovieStart: movieStart,
      );

      final MovieSummaryStats stats = MovieSummaryStats.fromFellowship(
        fellowship,
      );

      expect(stats.totalMovieDrinks, 3);
      expect(stats.movieDrinkLeaders, hasLength(1));
      expect(stats.movieDrinkLeaders.first.name, 'Frodo');
      expect(stats.movieDrinkLeaderCount, 2);
    });

    test('falls back to all drinks when the movie start is unknown', () {
      final Fellowship fellowship = _fellowship(
        <FellowshipMember>[
          _member(
            Character.frodo,
            'Frodo',
            drinks: <DateTime>[
              DateTime(2026, 1, 1, 10),
              DateTime(2026, 1, 1, 11),
            ],
          ),
          _member(
            Character.sam,
            'Sam',
            drinks: <DateTime>[DateTime(2026, 1, 1, 12)],
          ),
        ],
      );

      final MovieSummaryStats stats = MovieSummaryStats.fromFellowship(
        fellowship,
      );

      expect(stats.movieDrinkLeaders.first.name, 'Frodo');
      expect(stats.movieDrinkLeaderCount, 2);
      expect(stats.savesAreForCurrentMovieOnly, isFalse);
    });

    test('finds the member with the most skips', () {
      final DateTime movieStart = DateTime(2026, 1, 1, 20);
      final Fellowship fellowship = _fellowship(
        <FellowshipMember>[
          _member(
            Character.frodo,
            'Frodo',
            saves: <DateTime>[DateTime(2026, 1, 1, 10)],
          ),
          _member(
            Character.sam,
            'Sam',
            saves: <DateTime>[
              DateTime(2026, 1, 1, 21),
              DateTime(2026, 1, 1, 22),
            ],
          ),
        ],
        currentMovieStart: movieStart,
      );

      final MovieSummaryStats stats = MovieSummaryStats.fromFellowship(
        fellowship,
      );

      expect(stats.saveLeaders, hasLength(1));
      expect(stats.saveLeaders.first.name, 'Sam');
      expect(stats.saveLeaderCount, 2);
      expect(stats.totalMovieSaves, 2);
    });

    test('finds the most intense five minute period', () {
      final DateTime movieStart = DateTime(2026, 1, 1, 20);
      final Fellowship fellowship = _fellowship(
        <FellowshipMember>[
          _member(
            Character.frodo,
            'Frodo',
            drinks: <DateTime>[
              DateTime(2026, 1, 1, 20, 30),
              DateTime(2026, 1, 1, 20, 32),
              DateTime(2026, 1, 1, 20, 34),
              DateTime(2026, 1, 1, 20, 50),
            ],
          ),
          _member(
            Character.legolas,
            'Legolas',
            drinks: <DateTime>[
              DateTime(2026, 1, 1, 21),
              DateTime(2026, 1, 1, 21, 3),
              DateTime(2026, 1, 1, 21, 6),
            ],
          ),
        ],
        currentMovieStart: movieStart,
      );

      final MovieSummaryStats stats = MovieSummaryStats.fromFellowship(
        fellowship,
      );

      expect(stats.intensePeriod, isNotNull);
      expect(stats.intensePeriod!.member.name, 'Frodo');
      expect(stats.intensePeriod!.drinks, 3);
      expect(stats.intensePeriod!.start, DateTime(2026, 1, 1, 20, 30));
      expect(stats.intensePeriod!.end, DateTime(2026, 1, 1, 20, 34));
    });

    test('a window of exactly five minutes counts as intense', () {
      final DateTime movieStart = DateTime(2026, 1, 1, 20);
      final Fellowship fellowship = _fellowship(
        <FellowshipMember>[
          _member(
            Character.gimli,
            'Gimli',
            drinks: <DateTime>[
              DateTime(2026, 1, 1, 20, 10),
              DateTime(2026, 1, 1, 20, 15),
              DateTime(2026, 1, 1, 20, 40),
            ],
          ),
        ],
        currentMovieStart: movieStart,
      );

      final MovieSummaryStats stats = MovieSummaryStats.fromFellowship(
        fellowship,
      );

      // The first two drinks are exactly five minutes apart, the third is
      // outside of every window that contains the first.
      expect(stats.intensePeriod!.drinks, 2);
      expect(stats.intensePeriod!.start, DateTime(2026, 1, 1, 20, 10));
      expect(stats.intensePeriod!.end, DateTime(2026, 1, 1, 20, 15));
    });

    test('handles a fellowship without any drinks', () {
      final Fellowship fellowship = _fellowship(<FellowshipMember>[
        _member(Character.frodo, 'Frodo'),
        _member(Character.sam, 'Sam'),
      ]);

      final MovieSummaryStats stats = MovieSummaryStats.fromFellowship(
        fellowship,
      );

      expect(stats.isEmpty, isTrue);
      expect(stats.allTimeLeaders, hasLength(2));
      expect(stats.allTimeLeaderDrinks, 0);
      expect(stats.intensePeriod, isNull);
      expect(stats.totalMovieDrinks, 0);
    });

    test('handles an empty fellowship', () {
      final MovieSummaryStats stats = MovieSummaryStats.fromFellowship(
        _fellowship(<FellowshipMember>[]),
      );

      expect(stats.isEmpty, isTrue);
      expect(stats.allTimeLeaders, isEmpty);
      expect(stats.intensePeriod, isNull);
    });

    test('parses currentMovieStart from Firestore json', () {
      final DateTime movieStart = DateTime(2026, 1, 1, 20);
      final Map<String, dynamic> json = <String, dynamic>{
        'id': 'test',
        'name': 'Test fellowship',
        'pin': '123456',
        'currentMovie': 'The Two Towers',
        'lastSummaryShown': 'Fellowship of the Ring',
        'currentMovieStart': Timestamp.fromDate(movieStart),
        'members': <String, dynamic>{
          'frodo': <String, dynamic>{
            'name': 'Frodo',
            'isAdmin': true,
            'drinks': <dynamic>[
              Timestamp.fromDate(DateTime(2026, 1, 1, 21)),
            ],
          },
        },
      };

      final Fellowship fellowship = Fellowship.fromJson(json);

      expect(fellowship.currentMovieStart, movieStart);
      final MovieSummaryStats stats = MovieSummaryStats.fromFellowship(
        fellowship,
      );
      expect(stats.totalMovieDrinks, 1);
    });
  });
}
