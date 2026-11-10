part of 'difficulty_view.dart';

class _DifficultyMobile extends StatelessWidget {
  const _DifficultyMobile(this.viewModel);

  final OnboardingViewModel viewModel;

  Future<void> _complete(BuildContext context) async {
    final bool success = await viewModel.complete();
    if (!context.mounted) {
      return;
    }
    if (success) {
      context.go(Location.home.value);
      viewModel.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Character? character = viewModel.selectedCharacter;

    return OnboardingScaffold(
      step: 3,
      title: 'Pick your difficulty',
      subtitle: 'Higher difficulties add more rules to your rule list.',
      onBack: () => context.go(Location.onboardingCharacter.value),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (character != null) ...<Widget>[
            Card(
              child: ListTile(
                leading: Icon(Icons.person, color: character.color),
                title: Text(
                  viewModel.name.isEmpty ? 'Your character' : viewModel.name,
                ),
                subtitle: Text(character.displayName),
              ),
            ),
            const SizedBox(height: 16),
          ],
          for (final RuleDifficulty difficulty in RuleDifficulty.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _DifficultyCard(
                difficulty: difficulty,
                selected: viewModel.selectedDifficulty == difficulty,
                onTap: viewModel.submitting
                    ? null
                    : () => viewModel.selectDifficulty(difficulty),
              ),
            ),
          if (viewModel.submitError != null) ...<Widget>[
            Text(
              viewModel.submitError!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
          ],
          if (viewModel.submitting) ...<Widget>[
            const LinearProgressIndicator(),
            const SizedBox(height: 12),
          ],
          Button(
            text: viewModel.submitting ? 'Joining...' : 'Enter the Fellowship',
            onPressed: viewModel.submitting ||
                    character == null ||
                    !viewModel.canContinueFromName
                ? null
                : () => _complete(context),
          ),
        ],
      ),
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  const _DifficultyCard({
    required this.difficulty,
    required this.selected,
    required this.onTap,
  });

  final RuleDifficulty difficulty;
  final bool selected;
  final VoidCallback? onTap;

  String get _includedRules {
    switch (difficulty) {
      case RuleDifficulty.easy:
        return 'Easy rules only';
      case RuleDifficulty.medium:
        return 'Easy and Medium rules';
      case RuleDifficulty.hard:
        return 'All Easy, Medium and Hard rules';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: selected ? difficulty.color : Colors.transparent,
          width: 3.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(difficulty.icon, color: difficulty.color, size: 36),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          difficulty.displayName,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: difficulty.color,
                                  ),
                        ),
                        const Spacer(),
                        if (selected)
                          Icon(
                            Icons.check_circle,
                            color: difficulty.color,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(difficulty.description),
                    const SizedBox(height: 6),
                    Text(
                      _includedRules,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
