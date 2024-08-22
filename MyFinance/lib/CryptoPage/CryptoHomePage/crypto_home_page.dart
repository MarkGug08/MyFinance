import 'dart:async';
import 'package:flutter/material.dart';
import '../../Controller/crypto_controller.dart';
import 'Widget/searchbar.dart';
import '../../Models/Crypto.dart';
import 'Widget/crypto_list.dart';

class MarketPage extends StatefulWidget {
  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final CryptoController cryptoController = CryptoController();
  final TextEditingController searchController = TextEditingController();

  late Future<List<Crypto>> futureCryptos;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchCryptos();

    // Set up a timer to refresh data every 60 seconds
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _fetchCryptos();
    });
  }

  void _fetchCryptos() {
    print('Fetching cryptos...');
    setState(() {
      futureCryptos = cryptoController.getCryptos();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        title: Center(child: Text('Market')),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: searchbar(searchController),
          ),
        ),
      ),
      body: FutureBuilder<List<Crypto>>(
        future: futureCryptos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return cryptolist(snapshot.data!);
          }
        },
      ),
    );
  }
}
