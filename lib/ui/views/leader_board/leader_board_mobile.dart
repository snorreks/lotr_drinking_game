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
              title: const Text('Leader board'),
              bottom: const TabBar(
                tabs: <Tab>[
                  Tab(text: 'Members'),
                  Tab(text: 'Bar Chart'),
                  Tab(text: 'Line Chart'),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                _buildMembersTab(fellowship),
                _buildBarChartTab(fellowship),
                _buildLineChartTab(fellowship),
              ],
            ),
          ),
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
            title: Text(member.name),
            subtitle: Text(member.character.displayName),
            trailing: Text(
                'Drinks: ${member.drinksAmount}\nUnits: ${showUnits(member.drinksAmount)}'),
            onTap: () => _handlePlayerTap(context, members),
          ),
        );
      },
    );
  }

  /// @see
  /// https://github.com/imaNNeo/fl_chart/blob/master/repo_files/documentations/bar_chart.md#sample-7-source-code
  /// https://github.com/imaNNeo/fl_chart/blob/master/example/lib/presentation/samples/bar/bar_chart_sample7.dart
  Widget _buildBarChartTab(Fellowship fellowship) {
    final List<FellowshipMember> members = fellowship.members.values.toList();
    members.sort((FellowshipMember a, FellowshipMember b) =>
        b.drinksAmount.compareTo(a.drinksAmount));

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceBetween,
        borderData: FlBorderData(
          show: true,
          border: const Border.symmetric(
            horizontal: BorderSide(),
          ),
        ),
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              // getTitles: (value) => value.toInt().toString(),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              // getTitles: (value) {
              //   final index = value.toInt();
              //   return SideTitleWidget(
              //     axisSide: AxisSide.bottom,
              //     child: _IconWidget(
              //       color: colors[index],
              //       isSelected: false, // Change to true if needed
              //     ),
              //   );
              // },
            ),
          ),
          rightTitles: AxisTitles(),
          topTitles: AxisTitles(),
        ),
        gridData: FlGridData(
          drawVerticalLine: false,
          getDrawingHorizontalLine: (double value) => const FlLine(
            strokeWidth: 1,
          ),
        ),
        barGroups: members
            .asMap()
            .entries
            .map((MapEntry<int, FellowshipMember> entry) {
          final int index = entry.key;
          final FellowshipMember member = entry.value;
          final Character character = member.character;
          final double drinksAmount = member.drinksAmount.toDouble();
          final double savesAmount = member.savesAmount.toDouble();

          return BarChartGroupData(
            x: index,
            barRods: <BarChartRodData>[
              BarChartRodData(
                toY: drinksAmount,
                color: character.color,
                width: 6,
              ),
              BarChartRodData(
                toY: savesAmount,
                color: const Color(0xFFCCCCCC),
                width: 6,
              ),
            ],
          );
        }).toList(),
        maxY: members.isNotEmpty
            ? members
                .map((FellowshipMember member) => member.drinksAmount)
                .reduce(math.max)
                .toDouble()
            : 0.0,
        barTouchData: BarTouchData(
          enabled: true,
          handleBuiltInTouches: false,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipMargin: 0,
            getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
            ) {
              return BarTooltipItem(
                rod.toY.toString(),
                TextStyle(
                  fontWeight: FontWeight.bold,
                  color: rod.color,
                  fontSize: 18,
                  shadows: const <Shadow>[
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 12,
                    ),
                  ],
                ),
              );
            },
          ),
          touchCallback: (FlTouchEvent event, BarTouchResponse? response) {},
        ),
      ),
    );
  }

  /// @see
  /// https://github.com/imaNNeo/fl_chart/blob/master/example/lib/presentation/samples/bar/bar_chart_sample7.dart
  /// https://github.com/imaNNeo/fl_chart/blob/master/example/lib/presentation/samples/line/line_chart_sample1.dart
  Widget _buildLineChartTab(Fellowship fellowship) {
    final List<FellowshipMember> members = fellowship.members.values.toList();
    members.sort((FellowshipMember a, FellowshipMember b) =>
        b.drinksAmount.compareTo(a.drinksAmount));

    return LineChart(
      LineChartData(
        titlesData: const FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
            ),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: members.map((FellowshipMember member) {
          final Character character = member.character;
          final List<DateTime> drinks = member.drinks;

          final List<FlSpot> spots = <FlSpot>[];
          for (int i = 0; i < drinks.length; i++) {
            final int index = i + 1;
            spots.add(FlSpot(index.toDouble(), member.drinksAmount.toDouble()));
          }

          return LineChartBarData(
            spots: spots,
            isCurved: true,
            color: character.color,
          );
        }).toList(),
      ),
    );
  }

  void _handlePlayerTap(BuildContext context, List<FellowshipMember> members) {
    showCalloutModal(
      context: context,
      players: members,
      rules: GameRules.rules,
      onSend: (FellowshipMember player, String category, String rule) {
        viewModel.sendCallout(player, rule);
      },
    );
  }
}
