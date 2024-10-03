import 'package:flutter/material.dart';
import 'package:myfinance/HomePage/Widget/ContentWidget/Widget/transactions_chart.dart';
import 'package:myfinance/Models/User.dart';
import '../../../Controller/transaction_controller.dart';
import '../../../Models/Transaction.dart';

Widget buildContent(BuildContext context, UserApp user) {

  TransactionController transactionController = TransactionController();

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction Movements',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
          child: TransactionLineChartHomePage(user: user),
        ),
        SizedBox(height: 16.0),
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
        SizedBox(
          height: 180.0,
          child: FutureBuilder<List<UserTransaction>>(
            future: transactionController.getTransaction(user),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center();
              } else if (snapshot.hasError) {
                return Center(child: Text('Error loading transactions'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No transactions available'));
              } else {

                DateTime now = DateTime.now();
                List<UserTransaction> transactions = snapshot.data!
                    .where((transaction) =>
                now.difference(transaction.dateTime).inHours < 24)
                    .toList();

                if (transactions.isEmpty) {
                  return Center(child: Text('No transactions in the last 24 hours'));
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    UserTransaction transaction = transactions[index];
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                          title: Text(
                            transaction.Description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            '${transaction.dateTime.day}/${transaction.dateTime.month}/${transaction.dateTime.year}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: Text(
                            '${transaction.amount.toStringAsFixed(2)} €',
                            style: TextStyle(
                              color: transaction.amount >= 0 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),
                          ),
                        ),
                        Divider()
                      ],
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    ),
  );
}
