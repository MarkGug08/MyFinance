import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../Controller/transaction_controller.dart';
import '../../../../../Widget/line_chart.dart';
import '../../../Models/User.dart';
import '../../../Widget/menu_dropdown.dart';

class TransactionLineChartWidget extends StatefulWidget {
  final UserApp user;

  TransactionLineChartWidget({required this.user});

  @override
  _TransactionLineChartWidgetState createState() => _TransactionLineChartWidgetState();
}

class _TransactionLineChartWidgetState extends State<TransactionLineChartWidget> {
  late Future<List<TransactionSpot>> _transactionSpots;
  String _selectedPeriod = 'Today';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didUpdateWidget(TransactionLineChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.user.control){
      _fetchData();
    }

  }

  void _fetchData() {
    TransactionController transactionController = TransactionController();
    _transactionSpots = transactionController.getTransactionHistory(_selectedPeriod, context, widget.user,);

    _transactionSpots.then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        width: 350,
        height: 300,
        padding: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
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
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No data available'));
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
                      selectedPeriod: _selectedPeriod,
                      lineColor: lineColor,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
