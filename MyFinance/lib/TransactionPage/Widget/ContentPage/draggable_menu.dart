import 'package:flutter/material.dart';
import 'package:myfinance/Models/Transaction.dart';
import '../../../Widget/transaction_info.dart';

Widget draggableMenu(BuildContext context, List<UserTransaction> transactions) {
  return DraggableScrollableSheet(
    initialChildSize: 0.3,
    minChildSize: 0.3,
    maxChildSize: 0.87,
    builder: (BuildContext context, ScrollController scrollController) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [

            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 8,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    UserTransaction transaction = transactions[index];

                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.shade300, width: 1),
                        ),
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TransactionInfo(
                          description: transaction.Description,
                          currentValue: transaction.amount,
                          time: transaction.dateTime,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
