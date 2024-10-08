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
            padding: const EdgeInsets.all(16.0),
            margin: EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Balance',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '£${balance.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Row(
                  children: [

                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.3),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                    ),


                        Text(
                          'Updated Today',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: 6),

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
