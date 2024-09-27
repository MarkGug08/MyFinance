import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myfinance/Controller/transaction_controller.dart';
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

  @override
  void initState() {
    super.initState();
    _startAutoReload();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoReload() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (Timer timer) {
      _reloadPage();
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
      body: TransactionsContentpage(context, widget.user, _isFormVisible),
    );
  }
}
