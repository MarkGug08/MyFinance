import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:myfinance/Models/User.dart';
import '../../../../../../Controller/transaction_controller.dart';
import '../../../../Widget/line_chart.dart';

class TransactionLineChartHomePage extends StatefulWidget {
  UserApp user;
  TransactionController transactionController = TransactionController();

  TransactionLineChartHomePage ({super.key, required this.user, required this.transactionController});
  @override
  _TransactionLineChartHomePageState createState() => _TransactionLineChartHomePageState();
}

class _TransactionLineChartHomePageState extends State<TransactionLineChartHomePage> {
  late Future<List<TransactionSpot>> _transactionSpots;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {

    _transactionSpots = widget.transactionController.getTransactionHistoryWithoutTime(context, widget.user);

    _transactionSpots.then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
      child: SizedBox(
        width: 350,
        height: 240,

        child: FutureBuilder<List<TransactionSpot>>(
          future: _transactionSpots,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available'));
            }

            List<TransactionSpot> transactionSpots = snapshot.data!;
            List<FlSpot> spots = transactionSpots
                .map((e) => FlSpot(e.time, e.value))
                .toList();
            List<TooltipData> tooltipData = transactionSpots
                .map((e) => TooltipData(e.timeString, e.time, e.value))
                .toList();

            final Color lineColor =
            transactionSpots.last.value >= 0 ? Colors.green : Colors.red;

            return Line_Chart(
              spots: spots,
              tooltipData: tooltipData,
              selectedPeriod: "All Movements",
              lineColor: lineColor,
            );
          },
        ),
      ),
      ),
    );
  }
}
