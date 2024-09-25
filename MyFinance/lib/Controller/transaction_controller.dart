import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfinance/Widget/error.dart';
import '../Models/Transaction.dart';

class TransactionSpot {
  final double time;
  final String timeString;
  final double value;

  TransactionSpot(this.time, this.timeString, this.value);
}

class TransactionController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserTransaction> _predefinedTransactions = [];

  Future<void> saveTransaction({
    required TextEditingController amountController,
    required TextEditingController descriptionController,
    required DateTime selectedDate,
    required bool tipeTransaction,
    required BuildContext context,
  }) async {
    try {
      double amount = double.parse(amountController.text);
      if (!tipeTransaction) {
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

  Future<List<TransactionSpot>> loadUserTransactions(BuildContext context) async {
    List<TransactionSpot> transactionSpots = [];
    try {
      QuerySnapshot snapshot = await _firestore.collection('transactions').get();
      _predefinedTransactions.clear();

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        UserTransaction transaction = UserTransaction(
          amount: data['amount'] != null ? data['amount'] as double : 0.0,
          dateTime: data['dateTime'] != null ? (data['dateTime'] as Timestamp).toDate() : DateTime.now(),
          Description: data['Description'] ?? 'No description',
        );

        _predefinedTransactions.add(transaction);

        double time = transaction.dateTime.millisecondsSinceEpoch.toDouble();
        String timeString = '${transaction.dateTime.day}/${transaction.dateTime.month} ${transaction.dateTime.hour}:${transaction.dateTime.minute}';
        transactionSpots.add(TransactionSpot(time, timeString, transaction.amount));
      }
    } catch (error) {
      showError(context, 'Error fetching transactions from Firestore: $error');
      return [];
    }

    transactionSpots.sort((a, b) => a.time.compareTo(b.time));

    for (TransactionSpot a in transactionSpots) {
      print(a.value);
      print(a.timeString);
      print(a.time);
    }

    return transactionSpots;
  }
}
