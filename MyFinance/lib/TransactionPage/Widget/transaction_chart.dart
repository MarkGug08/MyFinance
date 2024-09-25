import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../Controller/transaction_controller.dart';
import '../../../../Widget/line_chart.dart';
import '../../Widget/menu_dropdown.dart';


class TransactionLineChartWidget extends StatefulWidget {

  @override
  _TransactionLineChartWidgetState createState() => _TransactionLineChartWidgetState();
}

class _TransactionLineChartWidgetState extends State<TransactionLineChartWidget> {
  late Future<List<TransactionSpot>> _transactionSpots;
  String _selectedPeriod = 'Today';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {

    TransactionController transactionController = TransactionController();
    _transactionSpots = transactionController.loadUserTransactions(context);


  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: FutureBuilder<List<TransactionSpot>>(
                future: _transactionSpots,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Container());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available'));
                  }

                  List<TransactionSpot> transactionSpots = snapshot.data!;
                  List<FlSpot> spots = transactionSpots.map((e) => FlSpot(e.time, e.value)).toList();
                  List<TooltipData> tooltipData = transactionSpots.map((e) => TooltipData(e.timeString, e.time, e.value)).toList();

                  return Line_Chart(
                    spots: spots,
                    tooltipData: tooltipData,
                    selectedPeriod: _selectedPeriod,
                    lineColor: Colors.blue,
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
