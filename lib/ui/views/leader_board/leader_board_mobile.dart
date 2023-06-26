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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 200,
                    child: charts.BarChart(
                      series,
                      animate: true,
                      domainAxis: charts.OrdinalAxisSpec(
                        renderSpec: charts.SmallTickRendererSpec(
                          labelStyle: charts.TextStyleSpec(
                            fontSize: 12,
                            color: charts.ColorUtil.fromDartColor(
                                Theme.of(context).textTheme.bodyMedium!.color ??
                                    Colors.black),
                          ),
                        ),
                      ),
                      primaryMeasureAxis: charts.NumericAxisSpec(
                        renderSpec: charts.SmallTickRendererSpec(
                          labelStyle: charts.TextStyleSpec(
                            color: charts.ColorUtil.fromDartColor(
                                Theme.of(context).textTheme.bodyMedium!.color ??
                                    Colors.black),
                          ),
                        ),
                      ),
                    ),
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
                          trailing: Text(
                              'Drinks: ${member.drinks}\nUnits: ${showUnits(member.drinks)}'),
                          onTap: () => _handlePlayerTap(context, member),
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

  void _handlePlayerTap(BuildContext context, FellowshipMember member) {
    List<String>? selectedRules;
    String? selectedGroup;
    String? dropdownValue;
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              child: Column(
                children: <Widget>[
                  RadioListTile<String>(
                    title: const Text('Normal'),
                    value: 'Normal',
                    groupValue: selectedGroup,
                    onChanged: (String? value) {
                      setState(() {
                        selectedGroup = value;
                        selectedRules = ['helol'];
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Down the Hatch'),
                    value: 'Down the Hatch',
                    groupValue: selectedGroup,
                    onChanged: (String? value) {
                      setState(() {
                        selectedGroup = value;
                        selectedRules = ['helol'];
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Character Rule'),
                    value: 'Character Rule',
                    groupValue: selectedGroup,
                    onChanged: (String? value) {
                      setState(() {
                        selectedGroup = value;
                        selectedRules = ['helol'];
                      });
                    },
                  ),
                  // Add more radio buttons as necessary
                  // Then add a button to confirm the selection
                  DropdownButton<String>(
                      items: const [],
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value;
                        });
                        // Handle the rule selection
                        // Call the server to notify the other player, etc.
                      }),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
