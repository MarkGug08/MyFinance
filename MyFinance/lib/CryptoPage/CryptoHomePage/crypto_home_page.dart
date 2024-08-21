import 'package:flutter/material.dart';
import 'package:myfinance/CryptoPage/CryptoHomePage/Widget/crypto_list.dart';
import 'package:myfinance/CryptoPage/CryptoHomePage/Widget/searchbar.dart';
import '../../Controller/crypto_controller.dart';
import '../../Models/Crypto.dart';


class MarketPage extends StatelessWidget {
  final CryptoController cryptoController = CryptoController();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Crypto> cryptoList = cryptoController.createCryptos();

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Center(child: Text('Market')),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: searchbar(searchController)
          ),
        ),
      ),
      body: cryptolist(cryptoList)
    );
  }
}
