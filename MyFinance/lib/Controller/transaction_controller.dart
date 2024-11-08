import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:myfinance/Widget/error.dart';
import '../Models/Transaction.dart';
import '../Models/User.dart';

class TransactionSpot {
  double time;
  final String timeString;
  final double value;

  TransactionSpot(this.time, this.timeString, this.value);

  TransactionSpot copy() {
    return TransactionSpot(time, timeString, value);
  }
}

class TransactionController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StreamController<List<TransactionSpot>> _transactionStreamController = StreamController.broadcast();
  double Income = 0;
  double Expenses = 0;
  bool canReload = false;
  bool canLine = false;
  List<UserTransaction> transactions = [];

  Stream<List<TransactionSpot>> get transactionStream => _transactionStreamController.stream;


  void updateTransactionHistory(String period, BuildContext context, UserApp user) async {
    List<TransactionSpot> transactionSpots = await getTransactionHistory(period, context, user);
    _transactionStreamController.add(transactionSpots);
  }

  void dispose() {
    _transactionStreamController.close();
  }


  Future<bool> _checkConnectivity(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showError(context, "No Internet connection. Please try again later.");
      return false;
    }
    return true;
  }



  Future<void> saveTransaction({
    required TextEditingController amountController,
    required TextEditingController titleController,
    required DateTime selectedDate,
    required bool tipeTransaction,
    required BuildContext context,
    required UserApp user,
  }) async {
    if (!(await _checkConnectivity(context))) return;


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
        user: user.UserEmail,
      );

      DocumentReference docRef = await _firestore.collection('transactions').add({
        'id': transaction.id,
        'amount': transaction.amount,
        'title': transaction.title,
        'dateTime': transaction.dateTime,
        'user': transaction.user,
      });

      transaction.id = docRef.id;

      await _firestore.collection('transactions').doc(transaction.id).update({
        'id': transaction.id,
      }).timeout(const Duration(seconds: 5));
    } catch (e) {
      FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
      String error = handleError(e);
      showError(context, error);
      return;
    }
  }

  Future<bool> deleteTransaction(String transactionId, BuildContext context) async {
    if (!(await _checkConnectivity(context))) return false;

    try {

      transactions.removeWhere((transaction) => transaction.id == transactionId);
      await _firestore.collection('transactions').doc(transactionId).delete();
    } catch (e) {
      String error = handleError(e);
      showError(context, "Failed to delete transaction: $error");
      return false;
    }

    canReload = true;
    return true;
  }

  Future<void> getTransaction(UserApp user, BuildContext context) async {
    if (!(await _checkConnectivity(context))) return;

    transactions.clear();
    try {
      QuerySnapshot snapshot = await _firestore.collection('transactions').where('user', isEqualTo: user.UserEmail).get();

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        UserTransaction transaction = UserTransaction(
          id: data['id'] ?? '',
          amount: data['amount'] != null ? data['amount'] as double : 0.0,
          dateTime: data['dateTime'] != null ? (data['dateTime'] as Timestamp).toDate() : DateTime.now(),
          title: data['title'] ?? 'No title',
          user: data['user'] ?? '',
        );

        if (!transactions.any((t) => t.dateTime == transaction.dateTime && t.amount == transaction.amount)) {
          transactions.add(transaction);
        }
      }

      transactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    } catch (error) {
      String errorMessage = handleError(error);
      showError(context, 'Error fetching transactions: $errorMessage');
    }
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
            startTime = DateTime(now.year, now.month, now.day);
            break;
          case 'This Week':
            startTime = now.subtract(const Duration(days: 7));
            break;
          case 'This Month':
            startTime = now.subtract(const Duration(days: 31));
            break;
          default:
            throw Exception('Unsupported period: $period');
        }
      }

      List<UserTransaction> filteredTransactions = transactions;

      if (startTime != null) {
        filteredTransactions = filteredTransactions
            .where((transaction){
              return transaction.dateTime.isAfter(startTime!) && transaction.dateTime.isBefore(now);
        }).toList();
      }else{
        filteredTransactions = filteredTransactions.where((transaction) {
          return transaction.dateTime.isBefore(now);
        }).toList();
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

      canReload = true;
      return transactionSpots;
    } catch (error) {
      showError(context, 'Error fetching transaction history: $error');
      return [];
    }
  }



  Future<List<TransactionSpot>> getTransactionHistoryWithoutTime(BuildContext context, UserApp user) async {


    try {

      final DateTime now = DateTime.now();

      List<UserTransaction> filteredTransactions = transactions
          .where((transaction) => transaction.dateTime.isBefore(now))
          .toList();

      filteredTransactions.sort((a, b) => a.dateTime.compareTo(b.dateTime));

      List<TransactionSpot> transactionSpots = [];
      int positionXaxis = 0;
      double balance = 0;

      for (UserTransaction transaction in filteredTransactions) {
        double timeValue = (positionXaxis + 1).toDouble();
        String timeString = '${transaction.dateTime.day}/${transaction.dateTime.month} ${transaction.dateTime.hour}:${transaction.dateTime.minute}:${transaction.dateTime.second}';

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

  double CalcolatePreviousBalance(){
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1, 23, 59, 59);

    double balance = 0;


    for (UserTransaction transaction in transactions){
      if(transaction.dateTime.isBefore(yesterday)){

        balance += transaction.amount;
      }
    }

    return balance;
  }

  Future<double> CalcolateTotalBalance(UserApp user, BuildContext context) async {

    DateTime now = DateTime.now();
    double balance = 0;

    for (UserTransaction x in transactions) {
      if(x.dateTime.isBefore(now)){
        balance += x.amount;
      }
    }

    return balance;
  }
}
