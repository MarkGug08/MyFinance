import 'package:flutter/material.dart';
import '../../../Models/Crypto.dart';
import '../../Widget/line_chart.dart';

class CryptoDetailPage extends StatelessWidget {
  final Crypto crypto;

  CryptoDetailPage({required this.crypto});

  @override
  Widget build(BuildContext context) {
    final changeSymbol = crypto.percentChange24h >= 0 ? '+' : '';
    final changeColor = crypto.percentChange24h >= 0 ? Colors.green : Colors.red;

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
            ),
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    'Market',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                crypto.name,
                                style: TextStyle(fontSize: 16.0, color: Colors.white),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                crypto.symbol,
                                style: TextStyle(fontSize: 14.0, color: Colors.white),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${crypto.currentValue.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '${changeSymbol}${crypto.percentChange24h.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  color: changeColor,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chart',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: LineChartWidget(crypto: crypto),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
