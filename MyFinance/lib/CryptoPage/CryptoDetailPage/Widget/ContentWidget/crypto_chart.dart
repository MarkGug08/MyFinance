import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../Controller/crypto_controller.dart';
import '../../../../Models/Crypto.dart';
import '../../../../Widget/line_chart.dart';
import '../../../../Widget/menu_dropdown.dart';

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
    final int nextMinute = (now.minute ~/ minuteInterval) * minuteInterval + minuteInterval;
    final DateTime nextFetchTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      nextMinute % 60,
      0,
    ).add(Duration(minutes: (nextMinute ~/ 60) * minuteInterval));

    final DateTime nextFetchTimeWithSeconds = nextFetchTime.add(Duration(seconds: 8));
    final timeUntilNextFetch = nextFetchTimeWithSeconds.difference(now);

    _timer?.cancel();

    _timer = Timer(timeUntilNextFetch, () {
      _fetchData();
      setState(() {});

      _timer = Timer.periodic(Duration(minutes: 5, seconds: 8), (Timer timer) {
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
              child: periodDropdown(
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
