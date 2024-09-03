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
  String _selectedPeriod = 'Today';

  @override
  void initState() {
    super.initState();
    CryptoController cryptoController = CryptoController();
    _cryptoSpots = cryptoController.getCryptoHistory(widget.crypto, _selectedPeriod);
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

        // Determine x range based on the period
        final double minX = cryptoSpots.first.time - 0.1;
        final double maxX = cryptoSpots.last.time + 0.1;

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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.centerLeft,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedPeriod,
                      items: <String>[
                        'Today',
                        'This Week',
                        'This Month',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 10),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newPeriod) {
                        if (newPeriod != null) {
                          setState(() {
                            _selectedPeriod = newPeriod;
                            // Refresh data for the selected period
                            CryptoController cryptoController = CryptoController();
                            _cryptoSpots = cryptoController.getCryptoHistory(widget.crypto, _selectedPeriod);
                          });
                        }
                      },
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 15,
                      ),
                      iconSize: 24,
                    ),
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
                            reservedSize: 30,
                            interval: yRange / 5,
                            getTitlesWidget: (value, meta) {
                              if (value != minY && value != maxY && value % (yRange / 5) != 0) {
                                String formattedValue;

                                if (value >= 1000) {
                                  formattedValue = '${(value / 1000).toStringAsFixed(2)}k';
                                } else {
                                  formattedValue = value.toStringAsFixed(0);
                                }

                                return Text(
                                  formattedValue,
                                  style: TextStyle(fontSize: 8),
                                );
                              } else {
                                return Container();
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
                              if (_selectedPeriod == 'Today') {
                                // Show hours
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
                              } else if (_selectedPeriod == 'This Week') {
                                // Show days of the week
                                final DateTime date = DateTime.fromMillisecondsSinceEpoch((value * 1000).toInt());
                                return Text(
                                  '${date.day}/${date.month}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 6,
                                  ),
                                );
                              } else if (_selectedPeriod == 'This Month') {
                                // Show days of the month
                                final DateTime date = DateTime.fromMillisecondsSinceEpoch((value * 1000).toInt());
                                return Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 6,
                                  ),
                                );
                              }
                              return Container();
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
                      minX: minX,
                      maxX: maxX,
                      minY: minY,
                      maxY: maxY,
                      lineBarsData: [
                        LineChartBarData(
                          spots: cryptoSpots.map((e) => FlSpot(e.time, e.value)).toList(),
                          isCurved: true,
                          color: lineColor,
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
