import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:myfinance/CryptoPage/CryptoDetailPage/Widget/Content_widget/menu_dropdown.dart';
import '../../../../Controller/crypto_controller.dart';
import '../../../../Models/Crypto.dart';
import '../../../../Widget/line_chart.dart';

class CryptoLineChartWidget extends StatefulWidget {
  final Crypto crypto;

  CryptoLineChartWidget({required this.crypto});

  @override
  _CryptoLineChartWidgetState createState() => _CryptoLineChartWidgetState();
}

class _CryptoLineChartWidgetState extends State<CryptoLineChartWidget> {
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
    final now = DateTime.now();
    final int minuteInterval = 5;

    // Find the next minute multiple of 5
    final int nextMinute = (now.minute ~/ minuteInterval) * minuteInterval + minuteInterval;

    // Calculate the date and time of the next fetch
    final DateTime nextFetchTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      nextMinute % 60, // Handle rollover to the next hour if the next minute exceeds 60
      0, // Initial seconds
    ).add(Duration(minutes: (nextMinute ~/ 60) * minuteInterval)); // Correct for rollover to a new hour

    // Add 8 seconds to the next fetch
    final DateTime nextFetchTimeWithSeconds = nextFetchTime.add(Duration(seconds: 8));

    final timeUntilNextFetch = nextFetchTimeWithSeconds.difference(now);

    // Cancel any previous timers to avoid overlaps
    _timer?.cancel();

    _timer = Timer(timeUntilNextFetch, () {
      _fetchData();
      setState(() {});

      // Set up the periodic fetch every 5 minutes
      _timer = Timer.periodic(Duration(minutes: 5), (Timer timer) {
        _fetchData();
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
              child: periodDropdown(    // Dropdown menu
                selectedPeriod: _selectedPeriod,
                onPeriodChanged: (newPeriod) {
                  setState(() {
                    _selectedPeriod = newPeriod;
                    _fetchData();
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<List<CryptoSpot>>(
                future: _cryptoSpots,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Container());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available'));
                  }

                  List<CryptoSpot> cryptoSpots = snapshot.data!;

                  List<FlSpot> spots = cryptoSpots.map((e) => FlSpot(e.time, e.value)).toList();
                  List<TooltipData> tooltipData = cryptoSpots.map((e) => TooltipData(e.timeString, e.time, e.value)).toList();

                  return Line_Chart(
                    spots: spots,
                    tooltipData: tooltipData,
                    selectedPeriod: _selectedPeriod,
                    lineColor: lineColor,
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
