part of 'character_view.dart';

class _CharacterMobile extends StatelessWidget {
  const _CharacterMobile(this.viewModel);
  final CharacterViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logo/logo-title.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<String>(
              stream: viewModel.username,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return TextField(
                  onChanged: viewModel.changeUsername,
                  decoration: InputDecoration(
                    hintText: 'Enter username',
                    errorText: snapshot.error as String?,
                  ),
                  controller: viewModel.usernameController,
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<Fellowship?>(
              stream: viewModel.fellowshipStream,
              builder:
                  (BuildContext context, AsyncSnapshot<Fellowship?> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                final Fellowship fellowship = snapshot.data!;
                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                  children: List<GestureDetector>.generate(
                      Character.values.length, (int index) {
                    final Character character = Character.values[index];
                    final bool isTaken =
                        viewModel.isTaken(fellowship, character);
                    final String name = character.displayName;
                    return GestureDetector(
                      onTap: isTaken
                          ? null
                          : () => viewModel.selectCharacter(character),
                      child: Container(
                        height: 200,
                        child: Card(
                          child: Stack(
                            children: <Widget>[
                              Image.asset(
                                'assets/images/characters/${character.value}.png',
                                fit: BoxFit.fitHeight,
                              ),
                              if (isTaken)
                                ColoredBox(
                                  color: Colors.black.withOpacity(0.5),
                                  child: const Icon(Icons.lock),
                                ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    color: Colors.black54,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
