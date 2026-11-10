import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/characters.dart';
import '../../../models/fellowship_member.dart';
import '../../../models/movie_summary_stats.dart';
import '../../widgets/avatar.dart';
import 'summary_dialog_model.dart';

class SummaryDialog extends ConsumerWidget {
  const SummaryDialog({required this.endedMovie, super.key});

  /// The movie that just ended.
  final String endedMovie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SummaryDialogViewModel viewModel =
        ref.watch(summaryDialogViewModelProvider(endedMovie));

    return Dialog(
      insetPadding: const EdgeInsets.all(20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                controller: viewModel.pageController,
                onPageChanged: viewModel.changePage,
                children: <Widget>[
                  _IntroPage(viewModel: viewModel),
                  _LeadersPage(viewModel: viewModel),
                  _SkipsPage(viewModel: viewModel),
                  _NextUpPage(viewModel: viewModel),
                ],
              ),
            ),
            _pageFooter(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _pageFooter(BuildContext context, SummaryDialogViewModel viewModel) {
    final bool isLastPage = viewModel.currentPage == viewModel.pageCount - 1;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              for (int page = 0; page < viewModel.pageCount; page++)
                Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: page == viewModel.currentPage
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.withValues(alpha: 0.4),
                  ),
                ),
            ],
          ),
          Row(
            children: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              if (!isLastPage)
                ElevatedButton(
                  onPressed: viewModel.goNext,
                  child: const Text('Next'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage({required this.viewModel});

  final SummaryDialogViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final MovieSummaryStats? stats = viewModel.stats;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.movie,
            size: 48.0,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16.0),
          Text(
            '${viewModel.endedMovie} has ended!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            'The fellowship survived. Here is how it went.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),
          if (stats != null) ...<Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _TotalChip(
                  icon: Icons.sports_bar,
                  label: '${stats.totalMovieDrinks} drinks',
                ),
                const SizedBox(width: 12.0),
                _TotalChip(
                  icon: Icons.skip_next,
                  label: '${stats.totalMovieSaves} skips',
                ),
              ],
            ),
          ],
          const SizedBox(height: 24.0),
          Text(
            'Swipe through for the stats',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _LeadersPage extends StatelessWidget {
  const _LeadersPage({required this.viewModel});

  final SummaryDialogViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final MovieSummaryStats? stats = viewModel.stats;

    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: <Widget>[
        Text(
          'Hall of fame',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16.0),
        if (stats == null || stats.allTimeLeaders.isEmpty)
          const _EmptyStats(message: 'No drinks recorded yet. Suspicious.'),
        if (stats != null && stats.allTimeLeaders.isNotEmpty) ...<Widget>[
          _WinnerCard(
            title: 'Chugging champion',
            subtitle: 'Most drinks across all movies',
            members: stats.allTimeLeaders,
            amount: stats.allTimeLeaderDrinks,
            unit: 'drinks',
            icon: Icons.emoji_events,
          ),
          const SizedBox(height: 12.0),
          _WinnerCard(
            title: 'Thirstiest of the night',
            subtitle: 'Most drinks in this movie',
            members: stats.movieDrinkLeaders,
            amount: stats.movieDrinkLeaderCount,
            unit: 'drinks',
            icon: Icons.local_drink,
          ),
        ],
      ],
    );
  }
}

class _SkipsPage extends StatelessWidget {
  const _SkipsPage({required this.viewModel});

  final SummaryDialogViewModel viewModel;

  String? _timeRange(BuildContext context, MovieSummaryStats stats) {
    final IntensePeriod? period = stats.intensePeriod;
    if (period == null) {
      return null;
    }
    final String start = MaterialLocalizations.of(context)
        .formatTimeOfDay(TimeOfDay.fromDateTime(period.start));
    final String end = MaterialLocalizations.of(context)
        .formatTimeOfDay(TimeOfDay.fromDateTime(period.end));
    return '$start - $end';
  }

  @override
  Widget build(BuildContext context) {
    final MovieSummaryStats? stats = viewModel.stats;
    final String? range = stats == null ? null : _timeRange(context, stats);

    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: <Widget>[
        Text(
          'Skips and chaos',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16.0),
        if (stats == null ||
            (stats.saveLeaders.isEmpty && stats.intensePeriod == null))
          const _EmptyStats(message: 'A peaceful movie. Almost boring.'),
        if (stats != null && stats.saveLeaders.isNotEmpty) ...<Widget>[
          _WinnerCard(
            title: 'Designated survivor',
            subtitle: stats.savesAreForCurrentMovieOnly
                ? 'Skipped the most drinks this movie'
                : 'Skipped the most drinks so far',
            members: stats.saveLeaders,
            amount: stats.saveLeaderCount,
            unit: 'skips',
            icon: Icons.skip_next,
          ),
        ],
        if (stats?.intensePeriod != null) ...<Widget>[
          const SizedBox(height: 12.0),
          _IntensePeriodCard(
            period: stats!.intensePeriod!,
            timeRange: range,
          ),
        ],
      ],
    );
  }
}

class _NextUpPage extends StatelessWidget {
  const _NextUpPage({required this.viewModel});

  final SummaryDialogViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.upcoming,
            size: 48.0,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Next up',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8.0),
          Text(
            viewModel.nextMovie ?? 'More Middle Earth',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),
          Text(
            'Heads up! The movie has changed, which means the collective rules '
            'have changed too. Check the rules tab before you press play.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('To the movie!'),
          ),
        ],
      ),
    );
  }
}

class _WinnerCard extends StatelessWidget {
  const _WinnerCard({
    required this.title,
    required this.subtitle,
    required this.members,
    required this.amount,
    required this.unit,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final List<FellowshipMember> members;
  final int amount;
  final String unit;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final List<FellowshipMember> winners =
        members.where((FellowshipMember member) => amount > 0).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12.0),
            if (winners.isEmpty)
              Text(
                'Nobody yet',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              ...winners.map(
                (FellowshipMember member) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Avatar(
                    member.character,
                    'Fellowship of the Ring',
                    circle: true,
                    height: 44.0,
                  ),
                  title: Text(member.name),
                  subtitle: Text(
                    member.character.displayName,
                    style: TextStyle(color: member.character.color),
                  ),
                  trailing: Text(
                    '$amount $unit',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _IntensePeriodCard extends StatelessWidget {
  const _IntensePeriodCard({
    required this.period,
    required this.timeRange,
  });

  final IntensePeriod period;
  final String? timeRange;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.local_fire_department,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Most intense 5 minutes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Avatar(
                period.member.character,
                'Fellowship of the Ring',
                circle: true,
                height: 44.0,
              ),
              title: Text(period.member.name),
              subtitle: Text(
                timeRange == null
                    ? period.member.character.displayName
                    : '${period.member.character.displayName} · $timeRange',
                style: TextStyle(color: period.member.character.color),
              ),
              trailing: Text(
                '${period.drinks} drinks',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalChip extends StatelessWidget {
  const _TotalChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18.0),
      label: Text(label),
    );
  }
}

class _EmptyStats extends StatelessWidget {
  const _EmptyStats({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
