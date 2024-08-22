import 'package:flutter/material.dart';
import '../../../Models/Crypto.dart';

class CryptoDetailPage extends StatelessWidget {
  final Crypto crypto;

  CryptoDetailPage({required this.crypto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(crypto.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${crypto.name}',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Symbol: ${crypto.symbol}',
              style: TextStyle(fontSize: 20.0, color: Colors.grey[600]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Current Value: \$${crypto.currentValue.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20.0),
            ),

          ],
        ),
      ),
    );
  }
}
