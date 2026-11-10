import 'fellowship.dart';
import 'fellowship_member.dart';

/// The length of the window used to find the most intense drinking period.
const Duration intensityWindow = Duration(minutes: 5);

/// A member together with the amount of drinks in their most intense period,
/// and when that period started and ended.
class IntensePeriod {
  const IntensePeriod({
    required this.member,
    required this.drinks,
    required this.start,
    required this.end,
  });

  final FellowshipMember member;
  final int drinks;
  final DateTime start;
  final DateTime end;
}

/// Fun stats about the movie that just ended, shown to the whole fellowship.
class MovieSummaryStats {
  const MovieSummaryStats({
    required this.allTimeLeaders,
    required this.allTimeLeaderDrinks,
    required this.movieDrinkLeaders,
    required this.movieDrinkLeaderCount,
    required this.saveLeaders,
    required this.saveLeaderCount,
    required this.intensePeriod,
    required this.totalMovieDrinks,
    required this.totalMovieSaves,
    required this.savesAreForCurrentMovieOnly,
  });

  /// Members with the most drinks across all movies. Contains every member on
  /// the leading score.
  final List<FellowshipMember> allTimeLeaders;
  final int allTimeLeaderDrinks;

  /// Members with the most drinks during the movie that just ended.
  final List<FellowshipMember> movieDrinkLeaders;
  final int movieDrinkLeaderCount;

  /// Members who skipped the most drinks during the movie that just ended.
  final List<FellowshipMember> saveLeaders;
  final int saveLeaderCount;

  /// The member with the most drinks in a single [intensityWindow] period.
  final IntensePeriod? intensePeriod;

  final int totalMovieDrinks;
  final int totalMovieSaves;

  /// Whether the stats only cover the current movie (true) or every drink so
  /// far (false). Stats fall back to all drinks when the movie start time is
  /// unknown, for fellowships created before movie summaries existed.
  final bool savesAreForCurrentMovieOnly;

  bool get isEmpty => totalMovieDrinks == 0 && totalMovieSaves == 0;

  /// Computes the summary stats from the fellowship snapshot taken when the
  /// movie changed.
  static MovieSummaryStats fromFellowship(Fellowship fellowship) {
    final List<FellowshipMember> members = fellowship.membersList;
    final DateTime? movieStart = fellowship.currentMovieStart;
    final bool perMovie = movieStart != null;

    int movieDrinks(FellowshipMember member) =>
        drinksInMovie(member, movieStart).length;

    int movieSaves(FellowshipMember member) =>
        inMovie(member.saves, movieStart).length;

    final int totalDrinks = members.fold(
      0,
      (int total, FellowshipMember member) => total + movieDrinks(member),
    );
    final int totalSaves = members.fold(
      0,
      (int total, FellowshipMember member) => total + movieSaves(member),
    );

    return MovieSummaryStats(
      allTimeLeaders: _leaders(members, (FellowshipMember m) => m.drinksAmount),
      allTimeLeaderDrinks:
          _maxOf(members, (FellowshipMember m) => m.drinksAmount),
      movieDrinkLeaders:
          perMovie ? _leaders(members, movieDrinks) : allTime(members),
      movieDrinkLeaderCount: perMovie
          ? _maxOf(members, movieDrinks)
          : _maxOf(members, (FellowshipMember m) => m.drinksAmount),
      saveLeaders: _leaders(members, movieSaves),
      saveLeaderCount: _maxOf(members, movieSaves),
      intensePeriod: _mostIntensePeriod(members, movieStart),
      totalMovieDrinks: totalDrinks,
      totalMovieSaves: totalSaves,
      savesAreForCurrentMovieOnly: perMovie,
    );
  }

  /// All-time leader view used when the movie boundary is unknown.
  static List<FellowshipMember> allTime(List<FellowshipMember> members) =>
      _leaders(members, (FellowshipMember m) => m.drinksAmount);
}

/// Drinks that happened at or after [movieStart]. A null [movieStart] means
/// every drink counts.
List<DateTime> drinksInMovie(FellowshipMember member, DateTime? movieStart) {
  return inMovie(member.drinks, movieStart);
}

List<DateTime> inMovie(List<DateTime> moments, DateTime? movieStart) {
  if (movieStart == null) {
    return List<DateTime>.from(moments);
  }
  return moments
      .where((DateTime moment) => !moment.isBefore(movieStart))
      .toList();
}

/// Finds the members with the highest score according to [score]. Returns
/// every member that ties for the lead.
List<FellowshipMember> _leaders(
  List<FellowshipMember> members,
  int Function(FellowshipMember) score,
) {
  if (members.isEmpty) {
    return <FellowshipMember>[];
  }

  int best = score(members.first);
  for (final FellowshipMember member in members) {
    final int value = score(member);
    if (value > best) {
      best = value;
    }
  }

  return members
      .where((FellowshipMember member) => score(member) == best)
      .toList();
}

int _maxOf(
  List<FellowshipMember> members,
  int Function(FellowshipMember) score,
) {
  int best = 0;
  for (final FellowshipMember member in members) {
    final int value = score(member);
    if (value > best) {
      best = value;
    }
  }
  return best;
}

/// Finds the member with the most drinks in any sliding [intensityWindow],
/// using their drinks since [movieStart] (or all drinks when null).
IntensePeriod? _mostIntensePeriod(
  List<FellowshipMember> members,
  DateTime? movieStart,
) {
  IntensePeriod? best;

  for (final FellowshipMember member in members) {
    final IntensePeriod? period = _mostIntenseForMember(member, movieStart);
    if (period != null && (best == null || period.drinks > best.drinks)) {
      best = period;
    }
  }

  return best;
}

IntensePeriod? _mostIntenseForMember(
  FellowshipMember member,
  DateTime? movieStart,
) {
  final List<DateTime> drinks = inMovie(member.drinks, movieStart)..sort();

  if (drinks.isEmpty) {
    return null;
  }

  int bestCount = 0;
  int bestStart = 0;
  int bestEnd = 0;

  int start = 0;
  for (int end = 0; end < drinks.length; end++) {
    while (drinks[end].difference(drinks[start]) > intensityWindow) {
      start++;
    }
    final int count = end - start + 1;
    if (count > bestCount) {
      bestCount = count;
      bestStart = start;
      bestEnd = end;
    }
  }

  return IntensePeriod(
    member: member,
    drinks: bestCount,
    start: drinks[bestStart],
    end: drinks[bestEnd],
  );
}
