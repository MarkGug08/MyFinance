import 'package:flutter/material.dart';
import 'package:myfinance/TransactionPage/Widget/transaction_chart.dart';
import 'package:myfinance/Widget/price_card.dart';
import 'Widget/transaction_form.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool _isFormVisible = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Statistics'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                _isFormVisible = !_isFormVisible;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    PriceCard(title: "Income", price: 2, priceColor: Colors.green),
                    SizedBox(width: 10),
                    PriceCard(title: "Expenses", price: 5, priceColor: Colors.red),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: TransactionLineChartWidget(),
                )
              ],
            ),
          ),

          if (_isFormVisible)
            Positioned(
              top: 20,
              left: 10,
              right: 10,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: TransactionForm(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
