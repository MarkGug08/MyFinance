import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../Controller/crypto_controller.dart';

class LineChartWidget extends StatefulWidget {
  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  late Future<List<CryptoSpot>> _bitcoinSpots;

  @override
  void initState() {
    super.initState();
    CryptoController cryptoController = CryptoController();
    _bitcoinSpots = cryptoController.getBitcoinTodayHistory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CryptoSpot>>(
      future: _bitcoinSpots,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }

        List<CryptoSpot> bitcoinSpots = snapshot.data!;

        return Center(
          child: Container(
            width: 350,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.grey),
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  drawHorizontalLine: true,
                  horizontalInterval: 1000,
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
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final hour = value.toInt();
                        final minute = ((value - hour) * 60).toInt();

                        if (minute == 0) {
                          return Container(
                            child: Text(
                              hour.toString().padLeft(0, '0'),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                minX: bitcoinSpots.first.time - 0.1,
                maxX: bitcoinSpots.last.time + 0.1,
                minY: bitcoinSpots.map((e) => e.value).reduce(min) - 1000,
                maxY: bitcoinSpots.map((e) => e.value).reduce(max) + 1000,
                lineBarsData: [
                  LineChartBarData(
                    spots: bitcoinSpots.map((e) => FlSpot(e.time, e.value)).toList(),
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
                        final CryptoSpot spotData = bitcoinSpots.firstWhere((e) => e.time == spot.x);

                        return LineTooltipItem(
                          '${spotData.timeString}\n${spot.y.toStringAsFixed(2)} USD',
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
        );
      },
    );
  }
}
