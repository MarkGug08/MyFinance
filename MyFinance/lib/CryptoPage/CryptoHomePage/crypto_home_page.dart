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

  List<Crypto> cryptoList = [];
  List<Crypto> filteredCryptoList = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchCryptos();


    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _fetchCryptos();
    });

    // Add a listener to the searchController to filter the list as the user types.
    searchController.addListener(_filterCryptos);
  }

  /// Fetches the list of cryptocurrencies from the controller and updates the state.
  void _fetchCryptos() async {
    try {
      List<Crypto> cryptos = await cryptoController.getCryptos();
      setState(() {
        cryptoList = cryptos;
        filteredCryptoList = cryptos;
      });
    } catch (e) {

    }
  }

  /// Filters the cryptocurrency list based on the search query.
  void _filterCryptos() {
    setState(() {
      String query = searchController.text.toLowerCase();
      filteredCryptoList = cryptoList.where((crypto) {
        // Filter the list by checking if the name or symbol contains the query.
        return crypto.name.toLowerCase().contains(query) ||
            crypto.symbol.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed.
    searchController.dispose(); // Dispose the searchController to avoid memory leaks.
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
            child: searchbar(searchController), // Search bar
          ),
        ),
      ),
      body: filteredCryptoList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : cryptolist(filteredCryptoList),
    );
  }
}
