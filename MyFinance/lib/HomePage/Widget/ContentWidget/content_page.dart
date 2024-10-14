import 'package:flutter/material.dart';
import 'package:myfinance/Controller/transaction_controller.dart';
import '../../../Models/User.dart';
import 'Widget/24history.dart';
import 'Widget/transactions_chart.dart';

class buildContent extends StatelessWidget {
  final UserApp user;
  TransactionController controller = TransactionController();

  buildContent({super.key, required this.user, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transaction Movements',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
            child: TransactionLineChartHomePage(user: user, transactionController: controller),
          ),
          const SizedBox(height: 16.0),
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Last 24 Hours',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Last24(user: user, controller: controller,),
        ],
      ),
    );
  }
}
