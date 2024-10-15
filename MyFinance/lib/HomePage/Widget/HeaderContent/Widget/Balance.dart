import 'package:flutter/material.dart';
import 'package:myfinance/Models/User.dart';
import 'package:myfinance/Controller/transaction_controller.dart';

class BalanceWidget extends StatelessWidget {
  final TransactionController controller;
  final UserApp user;

  const BalanceWidget({
    super.key,
    required this.controller,
    required this.user,
  });

  String formatNumber(double value) {
    if (value >= 1e12 || value * -1 >= 1000) {
      return '${(value / 1e12).toStringAsFixed(2)}T';
    } else if (value >= 1e9 || value * -1 >= 1000) {
      return '${(value / 1e9).toStringAsFixed(2)}B';
    } else if (value >= 1e6 || value * -1 >= 1000) {
      return '${(value / 1e6).toStringAsFixed(2)}M';
    } else if (value >= 1e3 || value * -1 >= 1000) {
      return '${(value / 1e3).toStringAsFixed(2)}k';
    } else {
      return value.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: controller.CalcolateTotalBalance(user, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Errore: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
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

            balanceChangeText = 'Increased by \$${formatNumber(balance - previousBalance)}';
            balanceIcon = Icons.arrow_upward;
            balanceIconColor = Colors.greenAccent;
            balanceLineColor = Colors.greenAccent;
          } else if (balance < previousBalance) {
            balanceChangeText = 'Decreased by \$${formatNumber(balance - previousBalance)}';
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
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
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
                    const SizedBox(height: 10),
                    Text(
                      '\$${formatNumber(balance)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
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
                    const SizedBox(height: 4),
                    Text(
                      balanceChangeText,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
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
          return const Padding(
            padding: EdgeInsets.all(20.0),
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
