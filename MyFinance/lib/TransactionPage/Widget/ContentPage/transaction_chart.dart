import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../Controller/transaction_controller.dart';
import '../../../../../Widget/line_chart.dart';
import '../../../Models/User.dart';
import '../../../Widget/menu_dropdown.dart';

class TransactionLineChartWidget extends StatefulWidget {
  final UserApp user;
  final TransactionController controller;

  const TransactionLineChartWidget({super.key, required this.user, required this.controller});

  @override
  _TransactionLineChartWidgetState createState() => _TransactionLineChartWidgetState();
}

class _TransactionLineChartWidgetState extends State<TransactionLineChartWidget> {
  String _selectedPeriod = 'Today';

  @override
  void initState() {
    super.initState();
    widget.controller.updateTransactionHistory(_selectedPeriod, context, widget.user);
  }

  @override
  void didUpdateWidget(TransactionLineChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
      widget.controller.updateTransactionHistory(_selectedPeriod, context, widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        width: 350,
        height: 300,
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
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
                      widget.controller.updateTransactionHistory(_selectedPeriod, context, widget.user);
                    });
                  },
                  flag: true
                ),
              ),
              Expanded(
                child: StreamBuilder<List<TransactionSpot>>(
                  stream: widget.controller.transactionStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No data available'));
                    }

                    List<TransactionSpot> transactionSpots = snapshot.data!;
                    List<FlSpot> spots = transactionSpots.map((e) => FlSpot(e.time, e.value)).toList();
                    List<TooltipData> tooltipData = transactionSpots.map((e) => TooltipData(e.timeString, e.time, e.value)).toList();

                    final Color lineColor = transactionSpots.last.value >= 0 ? Colors.green : Colors.red;

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

