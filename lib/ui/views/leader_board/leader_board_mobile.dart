part of 'leader_board_view.dart';

class _LeaderBoardMobile extends StatelessWidget {
  const _LeaderBoardMobile(this.viewModel);
  final LeaderBoardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Fellowship?>(
      stream: viewModel.fellowshipStream,
      builder: (BuildContext context, AsyncSnapshot<Fellowship?> snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Loading());
        }
        final Fellowship fellowship = snapshot.data!;

        return DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                title: const TabBar(
                  indicatorColor: Colors.white,
                  tabs: <Tab>[
                    Tab(text: 'Members'),
                    Tab(text: 'Bar Chart'),
                    Tab(text: 'Line Chart'),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    // BarChartSample7(),
                    _buildMembersTab(fellowship),
                    FellowshipBarChart(fellowship: fellowship),
                    FellowshipLineChart(fellowship: fellowship),
                  ],
                ),
              )),
        );
      },
    );
  }

  Widget _buildMembersTab(Fellowship fellowship) {
    final List<FellowshipMember> members = fellowship.members.values.toList();
    members.sort((FellowshipMember a, FellowshipMember b) =>
        b.drinksAmount.compareTo(a.drinksAmount));

    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (BuildContext context, int index) {
        final FellowshipMember member = members[index];
        final Character character = member.character;
        return Card(
          child: ListTile(
            leading: Avatar(character),
            title: Text(
              member.name,
            ),
            subtitle: Text(
              member.character.displayName,
              style: TextStyle(
                color: character.color,
              ),
            ),
            trailing: Text(
                'Drinks: ${member.drinksAmount}\nUnits: ${showUnits(member.drinksAmount)}'),
            onTap: viewModel.currentCharacter == character
                ? null
                : () => viewModel.showCalloutDialog(member),
          ),
        );
      },
    );
  }
}
