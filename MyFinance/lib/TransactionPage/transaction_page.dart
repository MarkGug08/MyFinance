import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myfinance/Controller/transaction_controller.dart';
import 'package:myfinance/Models/Transaction.dart';
import 'package:myfinance/TransactionPage/Widget/ContentPage/Transactions_contentPage.dart';
import 'package:myfinance/TransactionPage/Widget/HeaderPage/transactions_HeaderPage.dart';
import '../Models/User.dart';

class TransactionPage extends StatefulWidget {
  final UserApp user;

  TransactionPage({required this.user});

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool _isFormVisible = false;
  TransactionController transactionController = TransactionController();
  Timer? _timer;
  List<UserTransaction> transactions = [];

  @override
  void initState() {
    super.initState();
    FetchTransactions();
    _startAutoReload();
  }


  Future<void> FetchTransactions() async {
    transactions = await transactionController.getTransaction();
    widget.user.control = false;

  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoReload() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (Timer timer) {
      _reloadPage();
      if(widget.user.control){
        FetchTransactions();
        _isFormVisible = false;
      }
    });
  }

  void _reloadPage() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TransactionsHeaderpage(
        context,
        onToggleForm: () {
          setState(() {
            _isFormVisible = !_isFormVisible;
          });
        },
      ),
      body: TransactionsContentPage(context, widget.user, _isFormVisible, transactions),
    );
  }
}
