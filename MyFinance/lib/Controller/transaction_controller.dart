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

  TransactionSpot copy(){
    return TransactionSpot(time, timeString, value);
  }
}

class TransactionController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double Income = 0;
  double Expenses = 0;
  bool canReload = false;
  bool canLine = false;
  List<UserTransaction> transactions = [];

  Future<void> saveTransaction({
    required TextEditingController amountController,
    required TextEditingController titleController,
    required DateTime selectedDate,
    required bool tipeTransaction,
    required BuildContext context,
    required UserApp user
  }) async {
    try {
      double amount = double.parse(amountController.text);
      if (!tipeTransaction && amount > 0) {
        amount *= -1;
      }
      String title = titleController.text;

      UserTransaction transaction = UserTransaction(
        id: '',
        amount: amount,
        title: title,
        dateTime: selectedDate,
        user: user.UserEmail
      );

      DocumentReference docRef = await _firestore.collection('transactions').add({
        'id': transaction.id,
        'amount': transaction.amount,
        'title': transaction.title,
        'dateTime': transaction.dateTime,
        'user': transaction.user
      });

      transaction.id = docRef.id;

      await _firestore.collection('transactions').doc(transaction.id).update({
        'id': transaction.id,
      });


    } catch (e) {
      String error = handleError(e);
      showError(context, error);
    }
  }


  Future<void> deleteTransaction(String transactionId, BuildContext context) async {
    try {


      transactions.removeWhere((transaction) => transaction.id == transactionId);
      await _firestore.collection('transactions').doc(transactionId).delete();

    } catch (e) {
      String error = handleError(e);
      showError(context, "Failed to delete transaction: $error");
    }

    canReload = true;
    canLine = true;

  }


  Future<List<TransactionSpot>> getTransactionHistory(String period, BuildContext context, UserApp user) async {
    try {
      Income = 0;
      Expenses = 0;
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


      List<UserTransaction> filteredTransactions = transactions
          .where((transaction) => transaction.user == user.UserEmail)
          .toList();

      if (startTime != null) {

        filteredTransactions = filteredTransactions
            .where((transaction) => transaction.dateTime.isAfter(startTime!))
            .toList();
      }


      filteredTransactions.sort((a, b) => a.dateTime.compareTo(b.dateTime));

      List<TransactionSpot> transactionSpots = [];
      int positionXaxis = 0;
      double balance = 0;


      for (UserTransaction transaction in filteredTransactions) {
        double timeValue = (positionXaxis + 1).toDouble();
        String timeString = '${transaction.dateTime.day}/${transaction.dateTime.month} ${transaction.dateTime.hour}:${transaction.dateTime.minute}:${transaction.dateTime.second}';


        CalcolateTransactionsMovements(transaction.amount);


        balance += transaction.amount;
        transactionSpots.add(TransactionSpot(timeValue, timeString, balance));
        positionXaxis++;
      }


      if (transactionSpots.length == 1) {
        TransactionSpot x = TransactionSpot(1, 'Start', 0);
        transactionSpots[0].time += 1;
        TransactionSpot y = transactionSpots[0];
        transactionSpots[0] = x;
        transactionSpots.add(y);
      }


      user.Income = Income;
      user.Expenses = Expenses;

      return transactionSpots;
    } catch (error) {
      showError(context, 'Error fetching transaction history: $error');
      return [];
    }
  }

  Future<void> getTransaction(UserApp user) async {
    transactions.clear();
    try {
      QuerySnapshot snapshot = await _firestore.collection('transactions').where('user', isEqualTo: user.UserEmail).get();

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        UserTransaction transaction = UserTransaction(
          id: data['id'] ?? '' ,
          amount: data['amount'] != null ? data['amount'] as double : 0.0,
          dateTime: data['dateTime'] != null ? (data['dateTime'] as Timestamp).toDate() : DateTime.now(),
          title: data['title'] ?? 'No title',
          user: data['user'] ?? ''
        );

        if (!transactions.any((t) => t.dateTime == transaction.dateTime && t.amount == transaction.amount)) {
          transactions.add(transaction);
        }

      }

      transactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));


    } catch (error) {

    }
  }

  Future<List<TransactionSpot>> getTransactionHistoryWithoutTime(BuildContext context, UserApp user) async {
    try {
      List<UserTransaction> filteredTransactions = transactions
          .where((transaction) => transaction.user == user.UserEmail)
          .toList();

      filteredTransactions.sort((a, b) => a.dateTime.compareTo(b.dateTime));

      List<TransactionSpot> transactionSpots = [];
      int positionXaxis = 0;
      double balance = 0;

      for (UserTransaction transaction in filteredTransactions) {
        double timeValue = (positionXaxis + 1).toDouble();
        String timeString = '${transaction.dateTime.day}/${transaction.dateTime.month} ${transaction.dateTime.hour}:${transaction.dateTime.minute}:${transaction.dateTime.second}';

        CalcolateTransactionsMovements(transaction.amount);

        balance += transaction.amount;
        transactionSpots.add(TransactionSpot(timeValue, timeString, balance));
        positionXaxis++;
      }

      if (transactionSpots.length == 1) {
        TransactionSpot x = TransactionSpot(1, 'Start', 0);
        transactionSpots[0].time += 1;
        TransactionSpot y = transactionSpots[0];
        transactionSpots[0] = x;
        transactionSpots.add(y);
      }

      return transactionSpots;
    } catch (error) {
      showError(context, 'Error fetching transaction history: $error');
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

  Future<double> CalcolateTotalBalance(UserApp user) async {

    double balance = 0;

    for(UserTransaction x in transactions){
      balance += x.amount;
    }

    return balance;
  }
}
