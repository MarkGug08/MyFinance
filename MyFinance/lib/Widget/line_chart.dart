import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Controller/crypto_controller.dart';
import '../Models/Crypto.dart';

class LineChartWidget extends StatefulWidget {
  final Crypto crypto;

  LineChartWidget({required this.crypto});

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  late Future<List<CryptoSpot>> _cryptoSpots;

  @override
  void initState() {
    super.initState();
    CryptoController cryptoController = CryptoController();
    _cryptoSpots = cryptoController.getCryptoTodayHistory(widget.crypto);
  }

  @override
  Widget build(BuildContext context) {
    final double percentChange = widget.crypto.percentChange24h;
    final Color lineColor = percentChange >= 0 ? Colors.green : Colors.red;

    return FutureBuilder<List<CryptoSpot>>(
      future: _cryptoSpots,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }

        List<CryptoSpot> cryptoSpots = snapshot.data!;

        // Calculate dynamic minY and maxY with padding
        final double minValue = cryptoSpots.map((e) => e.value).reduce(min);
        final double maxValue = cryptoSpots.map((e) => e.value).reduce(max);
        final double yRange = maxValue - minValue;
        final double padding = yRange * 0.5;

        final double minY = minValue - padding;
        final double maxY = maxValue + padding;

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
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${widget.crypto.symbol} Price Chart',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        drawHorizontalLine: true,
                        horizontalInterval: yRange / 5,
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
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: yRange / 5,
                            getTitlesWidget: (value, meta) {
                              // Only show labels that are not at minY, maxY, and grid lines
                              if (value != minY && value != maxY && value % (yRange / 5) != 0) {
                                String formattedValue;

                                if (value >= 1000) {
                                  formattedValue = '${(value / 1000).toStringAsFixed(2)}k';
                                } else {
                                  formattedValue = value.toStringAsFixed(0);
                                }

                                return Text(
                                  formattedValue,
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                );
                              } else {
                                return Container(); // Return an empty container to hide unwanted labels
                              }
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final hour = value.toInt();
                              final minute = ((value - hour) * 60).toInt();

                              if (minute == 0) {
                                return Text(
                                  hour.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 6,
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
                      minX: cryptoSpots.first.time - 0.1,
                      maxX: cryptoSpots.last.time + 0.1,
                      minY: minY,
                      maxY: maxY,
                      lineBarsData: [
                        LineChartBarData(
                          spots: cryptoSpots.map((e) => FlSpot(e.time, e.value)).toList(),
                          isCurved: true,
                          color: lineColor, // Dynamic color based on percentChange24h
                          barWidth: 2.5,
                          dotData: FlDotData(
                            show: false,
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: lineColor.withOpacity(0.3),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        handleBuiltInTouches: true,
                        touchSpotThreshold: 20,
                        touchTooltipData: LineTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          tooltipMargin: 8,
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              final CryptoSpot spotData = cryptoSpots.firstWhere((e) => e.time == spot.x);

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
              ],
            ),
          ),
        );
      },
    );
  }
}
