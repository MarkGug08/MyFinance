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

  TransactionPage({required this.user});

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
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
    transactions.clear();
    transactions = await transactionController.getTransaction(widget.user);
    widget.user.control = false;

    if (mounted) {
      setState(() {});
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
        FetchTransactions();

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
            onTransactionSaved: FetchTransactions,
          ),
        );
      },
    ).then((value) {
      _startAutoReload();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: TransactionsHeaderpage(
        context,
        onToggleForm: _showTransactionFormModal,
      ),
      body: TransactionsContentPage(context, widget.user, transactions),
    );
  }
}
