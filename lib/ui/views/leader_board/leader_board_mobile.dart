part of 'leader_board_view.dart';

class _LeaderBoardMobile extends StatelessWidget {
  const _LeaderBoardMobile(this.viewModel);
  final LeaderBoardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Fellowship?>(
        stream: viewModel.fellowshipStream,
        builder: (BuildContext context, AsyncSnapshot<Fellowship?> snapshot) {
          if (snapshot.hasData) {
            final List<FellowshipMember> members =
                snapshot.data!.members.values.toList();
            members.sort((FellowshipMember a, FellowshipMember b) =>
                b.drinks.compareTo(a.drinks));

            // Creating series data for charts
            final List<charts.Series<FellowshipMember, String>> series = [
              charts.Series<FellowshipMember, String>(
                id: 'Drinks',
                colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                domainFn: (FellowshipMember member, _) => member.name,
                measureFn: (FellowshipMember member, _) => member.drinks,
                data: members,
              ),
            ];

            return Column(
              children: [
                // Displaying Bar Chart
                SizedBox(
                  height: 200,
                  child: charts.BarChart(
                    series,
                    animate: true,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (BuildContext context, int index) {
                      final FellowshipMember member = members[index];
                      return Card(
                        child: ListTile(
                          leading: Image.asset(
                              'assets/images/characters/${member.character.value}.png'),
                          title: Text(member.name),
                          subtitle: Text(member.character.displayName),
                          trailing: Text('Drinks: ${member.drinks}'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('An error occurred'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
