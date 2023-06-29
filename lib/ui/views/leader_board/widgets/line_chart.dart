part of '../leader_board_view.dart';

enum LineChartView { drinks, saves }

final Color borderColor = Colors.white54.withOpacity(0.2);

class FellowshipLineChart extends StatefulWidget {
  const FellowshipLineChart({super.key, required this.fellowship});
  final Fellowship fellowship;

  @override
  FellowshipLineChartState createState() => FellowshipLineChartState();
}

class FellowshipLineChartState extends State<FellowshipLineChart> {
  // List<FellowshipMember> get members =>
  //     widget.fellowship.members.values.toList();

  List<DateTime> getMockDates(int count, Duration interval) {
    final List<DateTime> dates = <DateTime>[];
    DateTime currentDate = DateTime.now();
    final math.Random random = math.Random();

    for (int i = 0; i < count; i++) {
      final int randomAmount = random.nextInt(10) + 1; // Random value up to 10
      for (int j = 0; j < randomAmount; j++) {
        dates.add(currentDate);
      }
      currentDate = currentDate.add(interval);
    }

    return dates;
  }

  List<FellowshipMember> get members {
    final List<FellowshipMember> fellowshipMembers =
        widget.fellowship.members.values.toList();

    if (fellowshipMembers.isNotEmpty) {
      final FellowshipMember firstMember = fellowshipMembers.first;

      fellowshipMembers[0] = FellowshipMember(
          name: firstMember.name,
          character: firstMember.character,
          drinks: getMockDates(5, const Duration(minutes: 20)),
          saves: getMockDates(5, const Duration(minutes: 20)),
          callout: firstMember.callout,
          isAdmin: firstMember.isAdmin);
    }

    return fellowshipMembers;
  }

  late LineChartView lineChartView = LineChartView.drinks;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 37,
              ),
              Text(
                lineChartView == LineChartView.drinks ? 'Drinks' : 'Saves',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 37,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: _LineChart(
                    lineChartView: lineChartView,
                    members: members,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              lineChartView == LineChartView.drinks
                  ? Icons.save
                  : Icons.sports_bar,
            ),
            onPressed: () {
              setState(() {
                lineChartView = lineChartView == LineChartView.drinks
                    ? LineChartView.saves
                    : LineChartView.drinks;
              });
            },
          )
        ],
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart({
    required this.members,
    required this.lineChartView,
  });
  final List<FellowshipMember> members;

  final LineChartView lineChartView;
  @override
  Widget build(BuildContext context) {
    return LineChart(
      lineChartBarData,
      duration: const Duration(milliseconds: 250),
    );
  }

  List<LineChartBarData> get lineBarsData => members
      .map(
        (FellowshipMember member) => LineChartBarData(
          isCurved: true,
          color: member.character.color,
          barWidth: 8,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(),
          spots: countOccurrencesAndCreateSpots(
            lineChartView == LineChartView.drinks
                ? member.drinks
                : member.saves,
          ),
        ),
      )
      .toList();

  List<DateTime> get dates {
    final List<DateTime> allDates = <DateTime>[];

    for (final FellowshipMember member in members) {
      allDates.addAll(
        lineChartView == LineChartView.drinks ? member.drinks : member.saves,
      );
    }

    // Sort the dates in ascending order
    allDates.sort();

    return allDates;
  }

  LineChartData get lineChartBarData => LineChartData(
        lineTouchData: lineTouchData,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsData,
        minX: 0,
        maxX: 200,
        maxY: 100,
        minY: 0,
      );

  LineTouchData get lineTouchData => LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((LineBarSpot barSpot) {
              final LineBarSpot flSpot = barSpot;
              final int index = flSpot.barIndex;
              final FellowshipMember member = members[index];
              final String name = member.name;
              final int minutesAfterStart = flSpot.x.toInt();
              final int drinksAmount = flSpot.y.toInt();
              final String drinksOrSaves =
                  lineChartView == LineChartView.drinks ? 'drinks' : 'saves';
              return LineTooltipItem(
                '$name\n$drinksAmount $drinksOrSaves\n$minutesAfterStart min',
                const TextStyle(color: Colors.white),
              );
            }).toList();
          },
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(),
        topTitles: const AxisTitles(),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (double value, TitleMeta meta) {
              return Text(
                value.toInt().toString(),
                textAlign: TextAlign.left,
              );
            },
          ),
        ),
      );

  SideTitles get bottomTitles {
    return SideTitles(
      showTitles: true,
      reservedSize: 32,
      getTitlesWidget: bottomTitleWidgets,
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    // If the value is out of range, return an empty widget.
    if (value < 0 || value >= dates.length) {
      return const SizedBox.shrink();
    }

    // Calculate the time passed since the first date
    final DateTime firstDate = dates.first;
    final int index = value.toInt();
    final DateTime currentDate = dates[index];
    final Duration timePassed = currentDate.difference(firstDate);

    // Convert the time passed to minutes and round it to the nearest 20 minutes
    final int minutesPassed = timePassed.inMinutes;
    final int roundedMinutes =
        (minutesPassed / 20).round() * 20; // Round to nearest 20

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(
        '$roundedMinutes',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: borderColor, width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  List<FlSpot> countOccurrencesAndCreateSpots(List<DateTime> dates) {
    final Map<DateTime, int> dateCounts = <DateTime, int>{};

    for (final DateTime date in dates) {
      final DateTime key = DateTime(date.year, date.month, date.day);
      if (dateCounts.containsKey(key)) {
        dateCounts[key] = dateCounts[key]! + 1;
      } else {
        dateCounts[key] = 1;
      }
    }

    // Sort the dates
    final List<DateTime> sortedDates = dateCounts.keys.toList()..sort();
    final List<FlSpot> spots = <FlSpot>[];

    for (int i = 0; i < sortedDates.length; i++) {
      spots.add(FlSpot(i.toDouble(), dateCounts[sortedDates[i]]!.toDouble()));
    }

    return spots;
  }
}
