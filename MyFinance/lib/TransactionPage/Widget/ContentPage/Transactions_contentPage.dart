import 'package:flutter/material.dart';
import 'package:myfinance/TransactionPage/Widget/ContentPage/transaction_chart.dart';
import 'package:myfinance/TransactionPage/Widget/ContentPage/transaction_form.dart';
import 'package:myfinance/Widget/price_card.dart';

import '../../../Models/User.dart';

  @override
  Widget TransactionsContentpage(BuildContext context, UserApp user, bool isFormVisible) {
    return Stack(
      children: [
        Column(
          children: [
            Row(
              children: [
                PriceCard(
                  title: "Income",
                  price: user.Income,
                  priceColor: Colors.green,
                ),
                SizedBox(width: 10),
                PriceCard(
                  title: "Expenses",
                  price: user.Expenses,
                  priceColor: Colors.red,
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: TransactionLineChartWidget(user: user),
            ),
          ],
        ),
        if (isFormVisible)
          Positioned(
            top: 20,
            left: 10,
            right: 10,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.white,
                child: TransactionForm(),
              ),
            ),
          ),
      ],
    );
}
