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
  List<UserTransaction> transactions = [];

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
      DateTime? startTime;

      if (period != 'All') {
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
      }

      Query query = _firestore.collection('transactions');

      if (startTime != null) {
        query = query.where('dateTime', isGreaterThanOrEqualTo: startTime);
      }

      query = query.orderBy('dateTime', descending: false);

      QuerySnapshot snapshot = await query.get();

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

        double timeValue = (positionXaxis + 1).toDouble();
        String timeString = '${transaction.dateTime.day}/${transaction.dateTime.month} ${transaction.dateTime.hour}:${transaction.dateTime.minute}:${transaction.dateTime.second}';

        CalcolateTransactionsMovements(transaction.amount);

        balance += transaction.amount;
        transactionSpots.add(TransactionSpot(timeValue, timeString, balance));
        positionXaxis++;
      }

      user.Income = Income;
      user.Expenses = Expenses;

      return transactionSpots;
    } catch (error) {
      showError(context, 'Error fetching transaction history: $error');
      return [];
    }
  }

  Future<List<UserTransaction>> getTransaction() async {
    transactions.clear();
    try {
      QuerySnapshot snapshot = await _firestore.collection('transactions').get();

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        UserTransaction transaction = UserTransaction(
          amount: data['amount'] != null ? data['amount'] as double : 0.0,
          dateTime: data['dateTime'] != null ? (data['dateTime'] as Timestamp).toDate() : DateTime.now(),
          Description: data['description'] ?? 'No description',
        );

        transactions.add(transaction);
      }

      transactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));

      return transactions;
    } catch (error) {
      return [];
    }
  }

  void CalcolateTransactionsMovements(double transaction) {
    if (transaction >= 0) {
      Income += transaction;
    } else {
      Expenses += transaction;
    }
  }
}
