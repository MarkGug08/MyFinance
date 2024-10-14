import 'package:flutter/material.dart';
import 'package:myfinance/Controller/transaction_controller.dart';
import 'package:myfinance/Models/Transaction.dart';
import 'package:myfinance/TransactionPage/Widget/ContentPage/draggable_menu.dart';
import 'package:myfinance/TransactionPage/Widget/ContentPage/transaction_chart.dart';
import 'package:myfinance/Widget/price_card.dart';
import '../../../Models/User.dart';

Widget TransactionsContentPage(BuildContext context, UserApp user, List<UserTransaction> transactions, TransactionController controller) {
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
              const SizedBox(width: 10),
              PriceCard(
                title: "Expenses",
                price: user.Expenses,
                priceColor: Colors.red,
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: TransactionLineChartWidget(user: user, controller: controller,),
          ),
        ],
      ),
      DraggableMenu(transactions: transactions, controller: controller),
    ],
  );
}
