part of './home_view.dart';

class _HomeMobile extends StatelessWidget {
  const _HomeMobile(this.viewModel);
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Fellowship?>(
      stream: viewModel.fellowshipStream,
      builder: (BuildContext context, AsyncSnapshot<Fellowship?> snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Loading());
        }
        final Fellowship fellowship = snapshot.data!;
        final Character character = viewModel.character!;
        final FellowshipMember? member = fellowship.members[character];
        if (member == null) {
          return const Center(child: Loading());
        }
        final String fellowshipName = fellowship.name;

        // Callout check, if callout exists, a dialog spawns!
        if (member.callout != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showCalloutDialog(context, member.callout!);
          });
        }

        return Scaffold(
          floatingActionButton: InkWell(
              splashColor: Colors.blue,
              onLongPress: () {
                _showMenu(context, member, fellowship);
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
          body: ListView(
            children: <Widget>[
              const SizedBox(height: 15),
              FellowshipCard(
                fellowshipName: fellowshipName,
                member: member,
              ),
              const SizedBox(height: 15),
              _rules(character),
            ],
          ),
        );
      },
    );
  }

  Widget _rules(Character character) {
    return Card(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 15),
            RulesList(rules: character.rules, title: 'Your rules:'),
            const SizedBox(height: 15),
            RulesList(
              rules: GameRules.normalRules,
              title: 'Everyone takes a drink when:',
            ),
            const SizedBox(height: 15),
            RulesList(rules: GameRules.dthRules, title: 'Down the hatch when:'),
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
            'A player has seen that you have skipped a sip.\nThey claim you forgot to drink when:\n$callout',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
                viewModel.resolveCallout(true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You have accepted the callout. +2 drinks'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text('Reject'),
              onPressed: () {
                Navigator.of(context).pop();
                viewModel.resolveCallout(false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You have rejected the call out...'),
                    duration: Duration(seconds: 2),
                  ),
                );
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
        items: <PopupMenuItem<String>>[
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
              final int drinksAmount = member.drinksAmount;
              final int downTheHatchSips =
                  amountOfSipsUntilNextUnit(drinksAmount);
              viewModel.incrementDownTheHatch(downTheHatchSips);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Drank $downTheHatchSips !'),
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          case 'callout':
            {
              final List<FellowshipMember> members =
                  fellowship.members.values.toList();
              showCalloutModal(
                context: context,
                players: members,
                rules: GameRules
                    .rules, //TODO: MAKE SURE CHARACTER RULES ARE INCLUDED AS WELL
                onSend:
                    (FellowshipMember player, String category, String rule) {
                  viewModel.sendCallout(player, rule);
                },
              );
            }
        }
      }
    });
  }
}

class FellowshipCard extends StatelessWidget {
  const FellowshipCard({
    super.key,
    required this.fellowshipName,
    required this.member,
  });

  final String fellowshipName;
  final FellowshipMember member;

  @override
  Widget build(BuildContext context) {
    final Character character = member.character;
    return Card(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              text: 'Fellowship of ',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: fellowshipName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          // TEXT REGARDING UNITS GOES HERE
          const SizedBox(height: 5),
          Avatar(
            character,
            fit: BoxFit.contain,
            height: 200,
          ),
          Row(
            children: <Expanded>[
              Expanded(
                child: ListTile(
                  title: Text(member.name),
                  subtitle: Text('${member.drinksAmount} drinks'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(character.displayName),
                  subtitle: Text('${member.savesAmount} saves'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RulesList extends StatelessWidget {
  const RulesList({
    super.key,
    required this.title,
    required this.rules,
  });

  final String title;
  final List<String> rules;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: <Padding>[
            for (String rule in rules)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '• ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        rule,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
