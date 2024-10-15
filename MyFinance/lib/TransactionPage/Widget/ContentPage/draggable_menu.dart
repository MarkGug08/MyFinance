import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance/Models/Transaction.dart';
import 'package:myfinance/Controller/transaction_controller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DraggableMenu extends StatefulWidget {
  final List<UserTransaction> transactions;
  final TransactionController controller;

  const DraggableMenu({super.key, required this.transactions, required this.controller});

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


  Future<bool> deleteTransaction(String transactionId, BuildContext context) async {
    return await widget.controller.deleteTransaction(transactionId, context);
  }



  Future<void> _showDeleteConfirmationDialog(BuildContext context, UserTransaction transaction, int index) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFAFAFA),
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this transaction?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                final scaffoldMessenger = ScaffoldMessenger.of(context);
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text("Deleting transaction..."),
                    duration: Duration(seconds: 1),
                  ),
                );

                try {
                 bool x =  await deleteTransaction(transaction.id, context);

                 if(x) {
                   scaffoldMessenger.showSnackBar(
                     const SnackBar(
                       content: Text("Transaction deleted successfully."),
                       duration: Duration(seconds: 1),
                     ),
                   );
                 }
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text("Failed to delete transaction: $e")),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
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
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListView.builder(
            controller: scrollController,
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              if (index >= _transactions.length) {
                return const SizedBox();
              }

              UserTransaction transaction = _transactions[index];

              return Slidable(
                key: ValueKey(transaction.id),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        _showDeleteConfirmationDialog(
                            context, transaction, index);
                      },
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.red,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: transaction.amount >= 0
                              ? Colors.green.withOpacity(0.3)
                              : Colors.redAccent.withOpacity(0.3),
                          child: Icon(
                            transaction.amount >= 0
                                ? Icons.trending_up
                                : Icons.trending_down,
                            color: transaction.amount >= 0
                                ? Colors.green
                                : Colors.redAccent,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat.yMMMd()
                                    .add_Hms()
                                    .format(transaction.dateTime),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "\$${transaction.amount.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: transaction.amount >= 0
                                ? Colors.green
                                : Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

}
