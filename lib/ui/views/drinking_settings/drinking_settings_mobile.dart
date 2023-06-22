part of './drinking_settings_view.dart';

class _DrinkingSettingsMobile extends StatelessWidget {
  const _DrinkingSettingsMobile(this.viewModel);
  final DrinkingSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
