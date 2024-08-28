import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatefulWidget {
  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  final List<String> _timePeriods = [
    'This Week',
    'Last Week',
    'This Month',
    'This Year',
    'All'
  ];

  String _selectedTimePeriod = 'This Week';

  List<FlSpot> _generateRandomSpots(int count) {
    final Random random = Random();
    List<FlSpot> spots = [];
    for (int i = 0; i < count; i++) {
      double x = i.toDouble();
      double y = (random.nextInt(51)).toDouble();
      spots.add(FlSpot(x, y));
    }
    return spots;
  }

  // Define a list of dates corresponding to the X values
  List<String> _dateLabels = List.generate(
    7,
        (index) {
      final DateTime today = DateTime.now();
      final DateTime date = today.subtract(Duration(days: 7 - index));
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
    },
  ).toList();

  @override
  Widget build(BuildContext context) {
    List<FlSpot> randomSpots = _generateRandomSpots(7);

    return Center(
      child: Container(
        width: 350,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: DropdownButton<String>(
                  value: _selectedTimePeriod,
                  items: _timePeriods.map((String period) {
                    return DropdownMenuItem<String>(
                      value: period,
                      child: Text(
                        period,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTimePeriod = newValue!;
                    });
                  },
                  underline: Container(),
                  dropdownColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      drawHorizontalLine: true,
                      horizontalInterval: 10,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.5),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            // Ensure the value is within range
                            if (value < 0 || value >= _dateLabels.length) {
                              return Container();
                            }
                            return Text(
                              _dateLabels[value.toInt()],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 9,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    minX: -0.2,
                    maxX: 6,
                    minY: -10,
                    maxY: 60,
                    lineBarsData: [
                      LineChartBarData(
                        spots: randomSpots,
                        isCurved: true,
                        color: Colors.black,
                        barWidth: 2.5,
                        dotData: FlDotData(
                          show: false,
                        ),
                        belowBarData: BarAreaData(
                          show: false,
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      handleBuiltInTouches: true,
                      touchSpotThreshold: 20,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipRoundedRadius: 8,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              '${spot.y.toInt()}',
                              TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                      touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                        if (touchResponse == null || event is! FlPanEndEvent) {
                          return;
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
