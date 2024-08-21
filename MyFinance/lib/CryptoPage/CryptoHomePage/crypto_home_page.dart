import 'package:flutter/material.dart';

import 'cryptodetail.dart';

class MarketPage extends StatelessWidget {
  final List<Map<String, String>> cryptoList = [
    {'name': 'Bitcoin', 'symbol': 'BTC'},
    {'name': 'Ethereum', 'symbol': 'ETH'},
    {'name': 'Ripple', 'symbol': 'XRP'},
    // Aggiungi altre criptovalute qui
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Market')),
      ),
      body: ListView.builder(
        itemCount: cryptoList.length,
        itemBuilder: (context, index) {
          final crypto = cryptoList[index];
          return ListTile(
            title: Text(crypto['name']!),
            subtitle: Text(crypto['symbol']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CryptoDetailPage(cryptoName: crypto['name']!, cryptoSymbol: crypto['symbol']!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
