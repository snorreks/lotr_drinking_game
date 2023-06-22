part of './drinking_settings_view.dart';

class _DrinkingSettingsMobile extends StatelessWidget {
  const _DrinkingSettingsMobile(this.viewModel);
  final DrinkingSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.incrementDrink,
        child: const Icon(Icons.sports_bar),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<Fellowship?>(
              stream: viewModel.fellowshipStream,
              builder:
                  (BuildContext context, AsyncSnapshot<Fellowship?> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                final Fellowship fellowship = snapshot.data!;
                final Character character = viewModel.character!;
                final FellowshipMember? member = fellowship.members[character];
                final String fellowshipName = fellowship.name;

                return Column(
                  children: <Widget>[
                    const SizedBox(height: 15),
                    Card(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                                text: 'Fellowship of ',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: fellowshipName,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color)),
                                ]),
                          ),
                          const SizedBox(height: 5),
                          Image.asset(
                            'assets/images/characters/${viewModel.character!.value}.png',
                            fit: BoxFit.contain,
                            height: 200,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(viewModel.character!.displayName),
                                  subtitle: Text('${member?.drinks} drinks'),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text('PIN: ${fellowship.pin}'),
                                  ),
                                  subtitle: ElevatedButton(
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: fellowship.pin));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'PIN copied to clipboard')),
                                      );
                                    },
                                    child: const Text('Copy PIN'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: 'Your rules:\n',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                          children: character.rules
                              .map((String rule) => TextSpan(
                                    text: '$rule\n',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color,
                                    ),
                                  ))
                              .toList()),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: 'Everyone takes a drink when:\n',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                          children: GameRules.normalRules
                              .map((String rule) => TextSpan(
                                    text: '$rule\n',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .color,
                                        fontWeight: FontWeight.normal),
                                  ))
                              .toList()),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: 'Down the hatch when:\n',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color),
                          children: GameRules.dthRules
                              .map((String rule) => TextSpan(
                                    text: '$rule\n',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .color),
                                  ))
                              .toList()),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
