import 'package:flutter/material.dart';
import 'package:myfinance/Controller/transaction_controller.dart';
import '../../../../Models/Transaction.dart';
import '../../../../Models/User.dart';

class Last24 extends StatelessWidget {
  final UserApp user;
  TransactionController controller = TransactionController();

  Last24({super.key, required this.user, required this.controller});

  @override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();
    List<UserTransaction> last24HoursTransactions = controller.transactions
        .where((transaction) =>
    now.difference(transaction.dateTime).inHours < 24 &&
        transaction.dateTime.isBefore(now))
        .toList();


    if (last24HoursTransactions.isEmpty) {
      return const Center(child: Text('No transactions in the last 24 hours'));
    }


    return SizedBox(
      height: 150.0,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: last24HoursTransactions.length,
        itemBuilder: (context, index) {
          UserTransaction transaction = last24HoursTransactions[index];
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                title: Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  '${transaction.dateTime.day}/${transaction.dateTime.month}/${transaction.dateTime.year}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: Text(
                  '${transaction.amount.toStringAsFixed(2)} \$',
                  style: TextStyle(
                    color: transaction.amount >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}
