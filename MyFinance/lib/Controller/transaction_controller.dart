import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfinance/Widget/error.dart';
import '../Models/Transaction.dart';
import '../Models/User.dart';

class TransactionSpot {
  double time;
  final String timeString;
  final double value;

  TransactionSpot(this.time, this.timeString, this.value);
}

class TransactionController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double Income = 0;
  double Expenses = 0;

  Future<void> saveTransaction({
    required TextEditingController amountController,
    required TextEditingController descriptionController,
    required DateTime selectedDate,
    required bool tipeTransaction,
    required BuildContext context,
  }) async {
    try {
      double amount = double.parse(amountController.text);
      if (!tipeTransaction && amount > 0) {
        amount *= -1;
      }
      String description = descriptionController.text;

      UserTransaction transaction = UserTransaction(
        amount: amount,
        Description: description,
        dateTime: selectedDate,
      );

      await _firestore.collection('transactions').add({
        'amount': transaction.amount,
        'description': transaction.Description,
        'dateTime': transaction.dateTime,
      });
    } catch (e) {
      String error = handleError(e);
      showError(context, error);
    }
  }

  Future<List<TransactionSpot>> getTransactionHistory(String period, BuildContext context, UserApp user) async {
    try {
      final DateTime now = DateTime.now();
      DateTime startTime;


      switch (period) {
        case 'Today':
          startTime = now.subtract(Duration(hours: 24));
          break;

        case 'This Week':
          startTime = now.subtract(Duration(days: 7));
          break;

        case 'This Month':
          startTime = now.subtract(Duration(days: 31));
          break;

        default:
          throw Exception('Unsupported period: $period');
      }

      QuerySnapshot snapshot = await _firestore
          .collection('transactions')
          .where('dateTime', isGreaterThanOrEqualTo: startTime)
          .get();

      List<TransactionSpot> transactionSpots = [];

      int positionXaxis = 0;
      double balance = 0;

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        UserTransaction transaction = UserTransaction(
          amount: data['amount'] != null ? data['amount'] as double : 0.0,
          dateTime: data['dateTime'] != null ? (data['dateTime'] as Timestamp).toDate() : DateTime.now(),
          Description: data['Description'] ?? 'No description',
        );

        double timeValue;
        String timeString;
        final DateTime transactionDate = transaction.dateTime;

        if (period == 'Today') {
          timeValue = (positionXaxis + 1).toDouble();
          timeString = '${transactionDate.hour.toString().padLeft(2, '0')}:${transactionDate.minute.toString().padLeft(2, '0')}:${transactionDate.second.toString().padLeft(2, '0')}';
        } else if (period == 'This Week') {

          timeValue = (positionXaxis + 1).toDouble();
          timeString = '${transactionDate.day}/${transactionDate.month} ${transactionDate.hour}:${transactionDate.minute}:${transactionDate.second}';
        } else if (period == 'This Month') {

          timeValue = (positionXaxis + 1).toDouble();
          timeString = '${transactionDate.day}/${transactionDate.month} ${transactionDate.hour}:${transactionDate.minute}:${transactionDate.second}';
        } else {
          throw Exception('Unsupported period: $period');
        }

        CalcolateTransactionsMovements(transaction.amount);

        balance += transaction.amount;
        transactionSpots.add(TransactionSpot(timeValue, timeString, balance));
        positionXaxis++;
      }


      user.Income = Income;
      user.Expenses = Expenses;

      print(user.Income);
      print(user.Expenses);

      return transactionSpots;
    } catch (error) {
      showError(context, 'Error fetching transaction history: $error');
      return [];
    }
  }



  void CalcolateTransactionsMovements(double transaction){

      if(transaction >= 0){
        Income += transaction;
      }else{
        Expenses += transaction;
      }
    }

}
