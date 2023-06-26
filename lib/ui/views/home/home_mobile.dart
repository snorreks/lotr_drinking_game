part of './home_view.dart';

class _HomeMobile extends StatelessWidget {
  _HomeMobile(this.viewModel);
  final HomeViewModel viewModel;

  //Stores member,which I can access amount of drinks from.
  final ValueNotifier<FellowshipMember?> memberNotifier = ValueNotifier(null);
  final ValueNotifier<Fellowship?> fellowshipNotifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
          splashColor: Colors.blue,
          onLongPress: () {
            final FellowshipMember? member = memberNotifier.value;
            final Fellowship? fellowship = fellowshipNotifier.value;
            if (member != null && fellowship != null) {
              _showMenu(context, member, fellowship);
            }
          },
          child: FloatingActionButton(
            onPressed: () {
              viewModel.incrementDrink();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('+1 drink!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Icon(Icons.sports_bar),
          )),
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

                //Callout check, if callout exists, a dialog spawns!
                if (member != null && member.callout.isNotEmpty) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    _showCalloutDialog(context, member.callout);
                  });
                }

                //this is a really poor solution but I am out of ideas, this is used for downthehatch function in menu.
                memberNotifier.value = member;
                fellowshipNotifier.value = fellowship;
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
                          //TEXT REGARDING UNITS GOES HERE
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
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  //Components that will be called out for
  void _showCalloutDialog(BuildContext context, String callout) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Called out'),
          content: Text(
              'A player has seen that you have skipped a sip.\nThey claim you forgot to drink when:\n${callout}'),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
                viewModel.resolveCallout(true);
              },
            ),
            TextButton(
              child: const Text('Reject'),
              onPressed: () {
                Navigator.of(context).pop();
                viewModel.resolveCallout(false);
              },
            ),
          ],
        );
      },
    );
  }

  void _showMenu(
      BuildContext context, FellowshipMember member, Fellowship fellowship) {
    ///Renders a menu with functionality.
    //Gets dynamically the position from the floatingactionbutton!
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
        context: context,
        position: position,
        items: [
          const PopupMenuItem<String>(
            value: 'save1',
            child: Text('Skipped a sip'),
          ),
          const PopupMenuItem<String>(
            value: 'dth2',
            child: Text('Down the hatch!'),
          ),
          const PopupMenuItem<String>(
            value: 'callout',
            child: Text('Call out a player'),
          ),
        ],
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )).then((String? value) {
      if (value != null) {
        switch (value) {
          case 'save1':
            {
              viewModel.incrementSaves();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Skipped 1 sip!'),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          case 'dth2':
            {
              //Calculate how many "sips" go down the hatch, then run with it.
              int amountOfDrinks = 0;
              amountOfDrinks = member.drinks;
              final int downTheHatchSips =
                  amountOfSipsUntilNextUnit(amountOfDrinks);
              viewModel.downTheHatchIncrement(downTheHatchSips);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Drank $downTheHatchSips !'),
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          case 'callout':
            List<FellowshipMember>? members =
                fellowship.members.values.toList();
            showCalloutModal(
              context: context,
              players:
                  members, //HERE I WANT FELLOWSHIPMEMBERS!! IT WORKED NVM<3
              rules: GameRules
                  .rules, //TODO: MAKE SURE CHARACTER RULES ARE INCLUDED AS WELL
              onSend: (FellowshipMember player, String category, String rule) {
                viewModel.sendCallout(player, rule);
              },
            );
        }
      }
    });
  }
}
