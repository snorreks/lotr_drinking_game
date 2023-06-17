part of 'character_view.dart';

class _CharacterMobile extends StatelessWidget {
  const _CharacterMobile(this.viewModel);
  final CharacterViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your phenomenal app')),
      body: GridView.count(
        crossAxisCount: 2,
        children: List<GestureDetector>.generate(Character.values.length,
            (int index) {
          final Character character = Character.values[index];
          final bool isTaken = viewModel.isTaken(character);
          return GestureDetector(
            onTap: isTaken ? null : () => viewModel.selectCharacter(character),
            child: Card(
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    'assets/images/characters/${character.value}.png',
                    fit: BoxFit.cover,
                  ),
                  if (isTaken)
                    ColoredBox(
                      color: Colors.black.withOpacity(0.5),
                      child: const Icon(Icons.lock),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
