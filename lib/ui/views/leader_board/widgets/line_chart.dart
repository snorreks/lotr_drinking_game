part of '../leader_board_view.dart';

enum LineChartView { drinks, saves }

final Color borderColor = Colors.white54.withOpacity(0.2);

/// The number of drinks/saves to show each x minute interval
const int intervalSeparator = 20;

class FellowshipLineChart extends StatefulWidget {
  const FellowshipLineChart({super.key, required this.fellowship});
  final Fellowship fellowship;

  @override
  FellowshipLineChartState createState() => FellowshipLineChartState();
}

class FellowshipLineChartState extends State<FellowshipLineChart> {
  final List<Character> hiddenCharacters = <Character>[];

  LineChartView lineChartView = LineChartView.drinks;

  List<FellowshipMember> get members =>
      widget.fellowship.members.values.toList()
        ..sort((FellowshipMember a, FellowshipMember b) {
          final int aAmount = lineChartView == LineChartView.drinks
              ? a.drinksAmount
              : a.savesAmount;
          final int bAmount = lineChartView == LineChartView.drinks
              ? b.drinksAmount
              : b.savesAmount;
          return bAmount.compareTo(aAmount);
        });

  // List<DateTime> getMockDates(int count, Duration interval) {
  //   final List<DateTime> dates = <DateTime>[];
  //   DateTime currentDate = DateTime.now();
  //   final math.Random random = math.Random();

  //   for (int i = 0; i < count; i++) {
  //     final int randomAmount = random.nextInt(10) + 1; // Random value up to 10
  //     for (int j = 0; j < randomAmount; j++) {
  //       dates.add(currentDate);
  //     }
  //     currentDate = currentDate.add(interval);
  //   }

  //   return dates;
  // }

  // List<FellowshipMember> get members {
  //   final List<FellowshipMember> fellowshipMembers =
  //       widget.fellowship.members.values.toList();

  //   if (fellowshipMembers.isNotEmpty) {
  //     final FellowshipMember firstMember = fellowshipMembers.first;

  //     fellowshipMembers[0] = FellowshipMember(
  //         name: firstMember.name,
  //         character: firstMember.character,
  //         drinks: getMockDates(5, const Duration(minutes: 20)),
  //         saves: getMockDates(5, const Duration(minutes: 20)),
  //         callout: firstMember.callout,
  //         isAdmin: firstMember.isAdmin);
  //   }

  //   return fellowshipMembers;
  // }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                lineChartView == LineChartView.drinks ? 'Drinks' : 'Saves',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6, top: 20),
                  child: _LineChart(
                      lineChartView: lineChartView,
                      members: members
                          .where((FellowshipMember element) =>
                              !hiddenCharacters.contains(element.character))
                          .toList()),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: _memberList(),
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

  Widget _memberList() {
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (BuildContext context, int index) {
        final FellowshipMember member = members[index];
        final Character character = member.character;
        final bool isHidden = hiddenCharacters.contains(character);

        double calculateAverageDrinksPerMinute() {
          final List<DateTime> drinksOrSaves =
              lineChartView == LineChartView.drinks
                  ? member.drinks
                  : member.saves;
          if (drinksOrSaves.isEmpty) {
            return 0;
          }

          final int amount = drinksOrSaves.length;

          final int minutes =
              drinksOrSaves.last.difference(drinksOrSaves.first).inMinutes;

          return minutes != 0 ? amount / minutes : 0.0;
        }

        final double drinksOrSavesPrMin = calculateAverageDrinksPerMinute();

        return ListTile(
          onTap: () {
            setState(() {
              if (hiddenCharacters.contains(character)) {
                hiddenCharacters.remove(character);
              } else {
                hiddenCharacters.add(character);
              }
            });
          },
          leading: Avatar(character, circle: true),
          title: Text(
            member.name,
            style: TextStyle(
              fontWeight: isHidden ? FontWeight.normal : FontWeight.bold,
              color: isHidden ? Colors.grey : Colors.black,
            ),
          ),
          tileColor: isHidden ? Colors.grey.withOpacity(0.2) : character.color,
          trailing: Text(
            '${drinksOrSavesPrMin.toStringAsFixed(2)} ${lineChartView.name}/min',
            style: TextStyle(
              fontWeight: isHidden ? FontWeight.normal : FontWeight.bold,
              color: isHidden ? Colors.grey : Colors.black,
            ),
          ),
        );
      },
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
          barWidth: 6,
          isStrokeCapRound: true,
          dotData: FlDotData(
            getDotPainter: (FlSpot spot, double xPercentage,
                LineChartBarData bar, int index) {
              return FlDotCirclePainter(
                radius: 9,
                color: member.character.color,
                strokeWidth: 1.5,
                strokeColor: Colors.white,
              );
            },
          ),
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

  LineChartData get lineChartBarData {
    return LineChartData(
      lineTouchData: lineTouchData,
      gridData: gridData,
      titlesData: titlesData,
      borderData: borderData,
      lineBarsData: lineBarsData,
      minX: 0,
      minY: 0,
    );
  }

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
    final int minutes = value.toInt();

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(
        '$minutes',
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
    final Map<int, int> intervalCounts = <int, int>{};

    for (final DateTime date in dates) {
      final int interval =
          (date.difference(dates.first).inMinutes / intervalSeparator).floor();
      if (intervalCounts.containsKey(interval)) {
        intervalCounts[interval] = intervalCounts[interval]! + 1;
      } else {
        intervalCounts[interval] = 1;
      }
    }

    final List<FlSpot> spots = <FlSpot>[];

    intervalCounts.forEach((int interval, int count) {
      spots.add(
          FlSpot(interval.toDouble() * intervalSeparator, count.toDouble()));
    });

    return spots;
  }
}
