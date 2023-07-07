part of '../home_view.dart';

class _DefaultView extends StatelessWidget {
  const _DefaultView(this.viewModel);
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel.sleepyDeepy();
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

        return Scaffold(
          floatingActionButton: InkWell(
              splashColor: Colors.blue,
              onLongPress: () {
                _showMenu(context, member, fellowship);
              },
              child: FloatingActionButton(
                onPressed: () {
                  viewModel.incrementDrink();
                },
                child: const Icon(Icons.sports_bar),
              )),
          body: ListView(
            children: <Widget>[
              const SizedBox(height: 15),
              FellowshipCard(
                fellowshipName: fellowshipName,
                member: member,
                currentMovie: fellowship.currentMovie,
              ),
              const SizedBox(height: 15),
              _rules(character, fellowship.currentMovie),
            ],
          ),
        );
      },
    );
  }

  Widget _rules(Character character, String currentMovie) {
    List<String> charRules = [];
    List<String> normalRules = [];
    switch (currentMovie) {
      case ('Fellowship of the Ring'):
        {
          charRules = character.rulesFellowship;
          normalRules = GameRules.sipRulesFellowship;
        }
      case ('The Two Towers'):
        {
          charRules = character.rulesTwoTowers;
          normalRules = GameRules.sipRulesTwoTowers;
        }
      case ('Return of the King'):
        {
          charRules = character.rulesROTK;
          normalRules = GameRules.sipRulesROTK;
        }
    }
    return Card(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 15),
            RulesList(rules: charRules, title: 'Your rules:'),
            const SizedBox(height: 15),
            RulesList(
              rules: normalRules,
              title: 'Everyone takes a drink when:',
            ),
            const SizedBox(height: 15),
            RulesList(rules: GameRules.dthRules, title: 'Down the hatch when:'),
          ],
        ),
      ),
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
          const PopupMenuItem<String>(
            value: 'zenMode',
            child: Text('Zen Mode'),
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
            }
          case 'dth2':
            {
              viewModel.downTheHatch(member);
            }
          case 'callout':
            {
              viewModel.showCalloutDialog();
            }
          case 'zenMode':
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => _ZenView(viewModel)),
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
    required this.currentMovie,
  });

  final String fellowshipName;
  final String currentMovie;
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
            currentMovie,
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
