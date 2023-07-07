part of 'character_view.dart';

class _CharacterMobile extends StatelessWidget {
  const _CharacterMobile(this.viewModel);
  final CharacterViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(7.5),
        child: Column(
          children: <Widget>[
            const Logo(type: LogoType.title),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<String>(
                stream: viewModel.username,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
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
                builder: (BuildContext context,
                    AsyncSnapshot<Fellowship?> snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Loading());
                  }
                  final Fellowship fellowship = snapshot.data!;
                  final bool isFirst = viewModel.isFirst(fellowship);
                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30,
                    physics: const ScrollPhysics(),
                    children: List<GestureDetector>.generate(
                        Character.values.length, (int index) {
                      final Character character = Character.values[index];
                      final bool isTaken =
                          viewModel.isTaken(fellowship, character);
                      final String name = character.displayName;
                      return GestureDetector(
                        key: ValueKey<Character>(character),
                        onTap: isTaken
                            ? null
                            : () =>
                                viewModel.selectCharacter(character, isFirst),
                        child: SizedBox(
                          height: 200,
                          child: Card(
                            child: Stack(
                              children: <Widget>[
                                ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return isTaken
                                        ? const LinearGradient(
                                            colors: <Color>[
                                              Colors.black,
                                              Colors.white
                                            ],
                                            stops: <double>[0.0, 1.0],
                                          ).createShader(bounds)
                                        : const LinearGradient(
                                            colors: <Color>[
                                              Colors.transparent,
                                              Colors.transparent
                                            ],
                                            stops: <double>[0.0, 1.0],
                                          ).createShader(bounds);
                                  },
                                  blendMode: isTaken
                                      ? BlendMode.saturation
                                      : BlendMode
                                          .saturation, // this is what applies the gray scale effect
                                  child: Avatar(
                                    character,
                                    "Fellowship of the Ring",
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                if (isTaken)
                                  Positioned.fill(
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.white.withOpacity(0.9),
                                      size:
                                          115.0, // adjust size of the lock icon here
                                    ),
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
                                          color: character.color,
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
      ),
    );
  }
}
