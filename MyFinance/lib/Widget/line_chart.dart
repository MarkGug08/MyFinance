import 'dart:async';
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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scheduleNextFetch();
  }

  void _fetchData() {
    CryptoController cryptoController = CryptoController();
    _cryptoSpots = cryptoController.getCryptoHistory(widget.crypto, _selectedPeriod, context);
  }

  void _scheduleNextFetch() {
    // Get the current time
    final now = DateTime.now();

    // Calculate the next fetch time (next multiple of 5 minutes)
    final nextFetchTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      (now.minute ~/ 5) * 5 + 5,
    );

    // If the calculated next fetch time is in the past, schedule it for the next hour
    if (nextFetchTime.isBefore(now)) {
      final nextHour = now.add(Duration(hours: 1));
      final nextFetchTime = DateTime(
        nextHour.year,
        nextHour.month,
        nextHour.day,
        nextHour.hour,
        (nextHour.minute ~/ 5) * 5,
      );
    }

    // Calculate the time remaining until the next fetch
    final timeUntilNextFetch = nextFetchTime.difference(now);

    // Schedule the next fetch
    _timer = Timer(timeUntilNextFetch, () {
      _fetchData(); // Fetch data
      setState(() {}); // Trigger a rebuild to update the chart

      // After the initial fetch, schedule subsequent fetches every 5 minutes
      _timer = Timer.periodic(Duration(minutes: 5), (Timer timer) {
        _fetchData(); // Refresh data every 5 minutes
        setState(() {}); // Trigger a rebuild to update the chart
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double percentChange = widget.crypto.percentChange24h;
    final Color lineColor = percentChange >= 0 ? Colors.green : Colors.red;

    return Center(
      child: Container(
        width: 350,
        height: 300,
        padding: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
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
                        _fetchData(); // Refresh data for the selected period
                      });
                    }
                  },
                  icon: Icon(
                    Icons.arrow_drop_down,
                    size: 15,
                  ),
                  iconSize: 24,
                  dropdownColor: Colors.white, // Change this to your desired transparency
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<CryptoSpot>>(
                future: _cryptoSpots,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Return an empty chart to animate in later
                    return Center(child: Container());
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

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 1500),
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
                                if (value != minY && value != maxY ) {
                                  String formattedValue;
                                  if (value >= 1000) {
                                    formattedValue = '${(value / 1000).toStringAsFixed(2)}k';
                                  } else {
                                    formattedValue = value.toStringAsFixed(2);
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
                              showTitles: false,
                              reservedSize: 20,
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
                        minY: minY,
                        maxY: maxY,
                        lineBarsData: [
                          LineChartBarData(
                            spots: cryptoSpots.map((e) => FlSpot(e.time, e.value)).toList(),
                            isCurved: false,
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
                      key: ValueKey<String>(_selectedPeriod),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
