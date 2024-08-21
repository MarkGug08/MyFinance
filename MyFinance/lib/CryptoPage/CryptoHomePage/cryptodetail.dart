import 'package:flutter/material.dart';

class CryptoDetailPage extends StatelessWidget {
  final String cryptoName;
  final String cryptoSymbol;

  CryptoDetailPage({required this.cryptoName, required this.cryptoSymbol});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cryptoName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              cryptoName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Symbol: $cryptoSymbol',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            // Aggiungi qui ulteriori informazioni sulla criptovaluta
          ],
        ),
      ),
    );
  }
}
