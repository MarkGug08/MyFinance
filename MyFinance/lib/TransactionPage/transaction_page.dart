import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:myfinance/Controller/transaction_controller.dart';
import 'package:myfinance/TransactionPage/Widget/ContentPage/Transactions_contentPage.dart';
import 'package:myfinance/TransactionPage/Widget/HeaderPage/transactions_HeaderPage.dart';
import '../Models/User.dart';
import '../Widget/error.dart';
import 'Widget/ContentPage/transaction_form.dart';

class TransactionPage extends StatefulWidget {
  final UserApp user;
  final TransactionController controller;

  const TransactionPage({super.key, required this.user, required this.controller});

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
    widget.controller.canReload = false;
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      await widget.controller.getTransaction(widget.user, context);

      if (mounted) {
        setState(() {

        });
      }
    }else{
      showError(context, "No Internet connection. Please try again later.");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoReload() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      if (widget.controller.canReload) {
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
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(15),
          ),
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
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: TransactionsHeaderpage(
        context,
        onToggleForm: _showTransactionFormModal,
      ),
      body: TransactionsContentPage(context, widget.user, widget.controller.transactions, widget.controller),
    );
  }
}
