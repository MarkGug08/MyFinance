import 'package:flutter/material.dart';

import '../../../../Controller/transaction_controller.dart';
import '../../../../Models/Transaction.dart';
import '../../../../Models/User.dart';

class Last24 extends StatelessWidget {
  final UserApp user;

  const Last24({required this.user});

  @override
  Widget build(BuildContext context) {
    TransactionController transactionController = TransactionController();
    return SizedBox(
      height: 180.0,
      child: FutureBuilder<List<UserTransaction>>(
        future: transactionController.getTransaction(user),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading transactions'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No transactions available'));
          } else {
            DateTime now = DateTime.now();
            List<UserTransaction> transactions = snapshot.data!
                .where((transaction) => now.difference(transaction.dateTime).inHours < 24)
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
                        transaction.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
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
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
