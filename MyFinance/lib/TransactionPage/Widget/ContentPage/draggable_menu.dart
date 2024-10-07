import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myfinance/Models/Transaction.dart';
import 'package:myfinance/Widget/transaction_info.dart';
import 'package:myfinance/Controller/transaction_controller.dart';

class DraggableMenu extends StatefulWidget {
  final List<UserTransaction> transactions;
  final TransactionController controller;

  DraggableMenu({required this.transactions, required this.controller});

  @override
  _DraggableMenuState createState() => _DraggableMenuState();
}

class _DraggableMenuState extends State<DraggableMenu> {
  late List<UserTransaction> _transactions;

  @override
  void initState() {
    super.initState();
    _transactions = widget.transactions;
  }

  Future<void> deleteTransaction(String transactionId, BuildContext context) async {
    await widget.controller.deleteTransaction(transactionId, context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 0.87,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ListView.builder(
            controller: scrollController,
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              UserTransaction transaction = _transactions[index];

              return Dismissible(
                key: ValueKey(transaction.id),
                onDismissed: (direction) async {
                  setState(() {
                    _transactions.removeAt(index);
                  });
                  await deleteTransaction(transaction.id, context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Transaction deleted")),
                  );
                },
                background: Container(color: Colors.red),
                child: TransactionInfo(
                  title: transaction.title,
                  currentValue: transaction.amount,
                  time: transaction.dateTime,
                  color: Colors.black,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
