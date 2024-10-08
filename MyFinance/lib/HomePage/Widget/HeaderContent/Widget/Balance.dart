import 'package:flutter/material.dart';
import 'package:myfinance/Models/User.dart';
import 'package:myfinance/Controller/transaction_controller.dart';

class BalanceWidget extends StatelessWidget {
  final TransactionController controller;
  final UserApp user;

  const BalanceWidget({
    Key? key,
    required this.controller,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: controller.CalcolateTotalBalance(user, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Errore: ${snapshot.error}',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else if (snapshot.hasData) {
          final double balance = snapshot.data ?? 0.0;
          final double previousBalance = controller.CalcolatePreviousBalance();

          String balanceChangeText;
          IconData balanceIcon;
          Color balanceIconColor;
          Color balanceLineColor;

          if (balance > previousBalance) {
            balanceChangeText = 'Increased by \$${(balance - previousBalance).toStringAsFixed(2)}';
            balanceIcon = Icons.arrow_upward;
            balanceIconColor = Colors.greenAccent;
            balanceLineColor = Colors.greenAccent;
          } else if (balance < previousBalance) {
            balanceChangeText = 'Decreased by \$${(previousBalance - balance).toStringAsFixed(2)}';
            balanceIcon = Icons.arrow_downward;
            balanceIconColor = Colors.redAccent;
            balanceLineColor = Colors.redAccent;
          } else {
            balanceChangeText = 'No change';
            balanceIcon = Icons.remove;
            balanceIconColor = Colors.grey;
            balanceLineColor = Colors.grey;
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.grey.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20.0),
            margin: EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Your Balance',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      '\$${balance.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      balanceIcon,
                      color: balanceIconColor,
                      size: 24,
                    ),
                    SizedBox(height: 4),
                    Text(
                      balanceChangeText,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 60,
                      height: 4,
                      color: balanceLineColor,
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'No data available',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      },
    );
  }
}
