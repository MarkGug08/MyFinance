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


    _timer = Timer.periodic(Duration(seconds: 10000), (timer) {
      _fetchCryptos();
    });

    // Add a listener to the searchController to filter the list as the user types.
    searchController.addListener(_filterCryptos);
  }

  /// Fetches the list of cryptocurrencies from the controller and updates the state.
  void _fetchCryptos() async {
    try {
      List<Crypto> cryptos = await cryptoController.getCryptos(context);
      setState(() {
        cryptoList = cryptos;
        filteredCryptoList = cryptos;
      });
    } catch (e) {

    }
  }

  /// Filters the cryptocurrency list based on the search query.
  void _filterCryptos() async {
    setState(() {
      String query = searchController.text.toLowerCase();
      filteredCryptoList = cryptoList.where((crypto) {
        return crypto.name.toLowerCase().contains(query) ||
            crypto.symbol.toLowerCase().contains(query);
      }).toList();
    });

    if (filteredCryptoList.isEmpty && searchController.text.isNotEmpty) {
      _searchCryptoOnline(searchController.text);
    }
  }

  void _searchCryptoOnline(String query) async {
    try {
      Crypto? crypto = await cryptoController.searchCryptoOnline(query, context);
      if (crypto != null) {
        setState(() {
          crypto.isFavorite = false;
          filteredCryptoList = [crypto];
        });
      } else {
        setState(() {
          filteredCryptoList = [];
        });

      }
    } catch (e) {}
  }


  @override
  void dispose() {
    _timer?.cancel();
    searchController.dispose();
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
          : cryptolist(filteredCryptoList, toggleFavorite),
    );
  }


  void toggleFavorite(Crypto crypto) {
    setState(() {
      crypto.isFavorite = !crypto.isFavorite;
    });
  }
}
