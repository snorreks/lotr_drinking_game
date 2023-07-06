part of '../leader_board_view.dart';

class FellowshipBarChart extends StatefulWidget {
  const FellowshipBarChart({super.key, required this.fellowship});
  final Fellowship fellowship;

  @override
  FellowshipBarChartState createState() => FellowshipBarChartState();
}

class FellowshipBarChartState extends State<FellowshipBarChart> {
  List<FellowshipMember> get members =>
      widget.fellowship.members.values.toList()
        ..sort(
          (FellowshipMember a, FellowshipMember b) =>
              b.drinksAmount.compareTo(a.drinksAmount),
        );

  int touchedGroupIndex = -1;
  final Color shadowColor = const Color(0xFFCCCCCC);
  final Color borderColor = Colors.white54.withOpacity(0.2);

  BarChartGroupData generateBarGroup(
    int x,
    Color color,
    int value,
    int shadowValue,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: <BarChartRodData>[
        BarChartRodData(
          toY: value.toDouble(),
          color: color,
          width: 10,
        ),
        BarChartRodData(
          toY: shadowValue.toDouble(),
          color: shadowColor,
          width: 6,
        ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? <int>[0] : <int>[],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
      child: BarChart(
        BarChartData(
          minY: 0,
          alignment: BarChartAlignment.spaceBetween,
          borderData: FlBorderData(
            show: true,
            border: Border.symmetric(
              horizontal: BorderSide(
                color: borderColor,
              ),
            ),
          ),
          titlesData: FlTitlesData(
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
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final int index = value.toInt();
                  final FellowshipMember member = members[index];
                  final Character character = member.character;
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: _IconWidget(
                      character: character,
                      isSelected: touchedGroupIndex == index,
                      onTap: () {
                        setState(() {
                          touchedGroupIndex =
                              touchedGroupIndex == index ? -1 : index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
          ),
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (double value) => FlLine(
              color: borderColor,
              strokeWidth: 1,
            ),
          ),
          barGroups:
              members.asMap().entries.map((MapEntry<int, FellowshipMember> e) {
            final int index = e.key;
            final FellowshipMember member = e.value;
            final Character character = member.character;
            final int drinksAmount = member.drinksAmount;
            final int savesAmount = member.savesAmount;
            return generateBarGroup(
                index, character.color, drinksAmount, savesAmount);
          }).toList(),
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
                final FellowshipMember member = members[groupIndex];
                final int drinksAmount = member.drinksAmount;
                final int savesAmount = member.savesAmount;

                return BarTooltipItem(
                  '${member.name}\n$drinksAmount drinks\n$savesAmount saves',
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    color: rod.color,
                    fontSize: 18,
                    shadows: const <Shadow>[
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 12,
                      )
                    ],
                  ),
                );
              },
            ),
            touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
              if (event.isInterestedForInteractions &&
                  response != null &&
                  response.spot != null) {
                setState(() {
                  touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                });
              } else {
                setState(() {
                  touchedGroupIndex = -1;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}

class _IconWidget extends ImplicitlyAnimatedWidget {
  const _IconWidget({
    required this.onTap,
    required this.character,
    required this.isSelected,
  }) : super(duration: const Duration(milliseconds: 300));
  final Character character;
  final bool isSelected;

  final void Function() onTap;
  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _IconWidgetState();
}

class _IconWidgetState extends AnimatedWidgetBaseState<_IconWidget> {
  Tween<double>? _rotationTween;

  @override
  Widget build(BuildContext context) {
    final double rotation = math.pi * 4 * _rotationTween!.evaluate(animation);
    final double scale = 1 + _rotationTween!.evaluate(animation) * 0.55;
    return Transform(
      transform: Matrix4.rotationZ(rotation).scaled(scale, scale),
      origin: const Offset(14, 14),
      child: // detect if tap
          GestureDetector(
        onTap: widget.onTap,
        child: Avatar(
          widget.character,
          circle: true,
        ),
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _rotationTween = visitor(
      _rotationTween,
      widget.isSelected ? 1.0 : 0.0,
      (dynamic value) => Tween<double>(
        begin: value as double,
        end: widget.isSelected ? 1.0 : 0.0,
      ),
    ) as Tween<double>?;
  }
}
