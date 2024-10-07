import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myfinance/Controller/transaction_controller.dart';
import 'package:myfinance/Models/Transaction.dart';
import 'package:myfinance/TransactionPage/Widget/ContentPage/Transactions_contentPage.dart';
import 'package:myfinance/TransactionPage/Widget/HeaderPage/transactions_HeaderPage.dart';
import '../Models/User.dart';
import 'Widget/ContentPage/transaction_form.dart';

class TransactionPage extends StatefulWidget {
  final UserApp user;
  final TransactionController controller;

  TransactionPage({required this.user, required this.controller});

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
    _startAutoReload();
  }

  Future<void> _fetchTransactions() async {
    widget.user.control = false;

    await widget.controller.getTransaction(widget.user);

    if (mounted) {
      setState(() {
        widget.controller.transactions = widget.controller.transactions;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoReload() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (Timer timer) {
      if (widget.user.control) {
        _fetchTransactions();
      }
    });
  }

  void _showTransactionFormModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: TransactionForm(
            user: widget.user,
            onTransactionSaved: () {
              _fetchTransactions();
            },
            transactionController: widget.controller,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: TransactionsHeaderpage(
        context,
        onToggleForm: _showTransactionFormModal,
      ),
      body: TransactionsContentPage(context, widget.user, widget.controller.transactions, widget.controller),
    );
  }
}
