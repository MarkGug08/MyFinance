import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myfinance/Models/User.dart';
import '../../Controller/crypto_controller.dart';
import 'Widget/searchbar.dart';
import '../../Models/Crypto.dart';
import 'Widget/crypto_list.dart';

class MarketPage extends StatefulWidget {
  UserApp user;

  MarketPage({super.key, required this.user});

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


    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          filteredCryptoList = cryptoList;
        });
      }
    });
  }

  void _fetchCryptos() async {
    try {
      List<Crypto> cryptos = await cryptoController.getCryptos(context, widget.user);
      setState(() {
        cryptoList = cryptos;
        filteredCryptoList = cryptos;
      });
    } catch (e) {}
  }

  void _searchCryptoOnline() async {
    String query = searchController.text.toLowerCase();

    try {
      Crypto? crypto = await cryptoController.searchCryptoOnline(query, context, widget.user);
      if (crypto != null) {
        setState(() {
          crypto.isFavorite = false;
          filteredCryptoList = [crypto];
        });
      } else {
        setState(() {
          filteredCryptoList = cryptoList;
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
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        title: const Center(child: Text('Market')),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: searchbar(searchController),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchCryptoOnline();
                  },
                )
              ],
            ),
          ),
        ),
      ),
      body: filteredCryptoList.isEmpty
          ? const Center(
        child: Text(
          'No saved cryptocurrencies.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : cryptolist(filteredCryptoList, toggleFavorite),
    );
  }

  void toggleFavorite(Crypto crypto) {
    setState(() {
      crypto.isFavorite = !crypto.isFavorite;
    });
    cryptoController.UpdateCrypto(crypto, crypto.isFavorite, context, widget.user).then((_) {
      _fetchCryptos();
      searchController.clear();
    });
  }
}

