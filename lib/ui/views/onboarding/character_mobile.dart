part of 'character_view.dart';

const ColorFilter _grayscaleFilter = ColorFilter.matrix(<double>[
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0, 0, 0, 1, 0, //
]);

class _CharacterMobile extends StatelessWidget {
  const _CharacterMobile(this.viewModel);

  final OnboardingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 2,
      title: 'Choose your character',
      subtitle: 'Every character has their own rules during the movies.',
      onBack: () => context.go(Location.onboardingName.value),
      child: StreamBuilder<Fellowship?>(
        stream: viewModel.fellowshipStream,
        builder: (
          BuildContext context,
          AsyncSnapshot<Fellowship?> snapshot,
        ) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Loading());
          }

          final Fellowship fellowship = snapshot.data!;

          return Column(
            children: <Widget>[
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: Character.values.map((Character character) {
                  final bool isTaken = viewModel.isTaken(fellowship, character);
                  final bool isSelected =
                      viewModel.selectedCharacter == character;
                  final Widget avatar = Avatar(
                    character,
                    'Fellowship of the Ring',
                    fit: BoxFit.fitHeight,
                  );

                  return GestureDetector(
                    key: ValueKey<Character>(character),
                    onTap: isTaken
                        ? null
                        : () => viewModel.selectCharacter(character),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(
                          color: isSelected
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.transparent,
                          width: 3.0,
                        ),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          if (isTaken)
                            ColorFiltered(
                              colorFilter: _grayscaleFilter,
                              child: avatar,
                            )
                          else
                            avatar,
                          if (isTaken)
                            Center(
                              child: Icon(
                                Icons.lock,
                                color: Colors.white.withValues(alpha: 0.9),
                                size: 64.0,
                              ),
                            ),
                          if (isSelected && !isTaken)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 28.0,
                              ),
                            ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              color: Colors.black54,
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                character.displayName,
                                style: TextStyle(
                                  color: character.color,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Button(
                text: 'Continue',
                onPressed: viewModel.selectedCharacter == null
                    ? null
                    : () => context.go(Location.onboardingDifficulty.value),
              ),
            ],
          );
        },
      ),
    );
  }
}
