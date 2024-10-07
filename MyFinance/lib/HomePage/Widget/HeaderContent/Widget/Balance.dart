import 'package:flutter/material.dart';
import 'package:myfinance/Models/User.dart';
import 'package:myfinance/Controller/transaction_controller.dart';

Widget balanceWidget(TransactionController controller, UserApp user) {
  return FutureBuilder<double>(
    future: controller.CalcolateTotalBalance(user),
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
        print(controller.transactions.length);
        final double balance = snapshot.data ?? 0.0;
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Balance',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '£${balance.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.8),
                size: 12,
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
