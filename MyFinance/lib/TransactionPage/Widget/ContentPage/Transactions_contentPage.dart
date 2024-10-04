import 'package:flutter/material.dart';
import 'package:myfinance/Models/Transaction.dart';
import 'package:myfinance/TransactionPage/Widget/ContentPage/draggable_menu.dart';
import 'package:myfinance/TransactionPage/Widget/ContentPage/transaction_chart.dart';
import 'package:myfinance/TransactionPage/Widget/ContentPage/transaction_form.dart';
import 'package:myfinance/Widget/price_card.dart';
import '../../../Models/User.dart';

Widget TransactionsContentPage(BuildContext context, UserApp user, List<UserTransaction> transactions) {
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
      draggableMenu(context, transactions),
    ],
  );
}
