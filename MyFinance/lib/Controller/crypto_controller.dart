import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:myfinance/Models/User.dart';
import '../Models/Crypto.dart';
import '../Widget/error.dart';

class CryptoSpot {
  final double time;
  final String timeString;
  final double value;

  CryptoSpot(this.time, this.timeString, this.value);
}

class CryptoController {
  final String binanceBaseUrl = 'https://api.binance.com/api/v3/klines';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String CoingeckoListCrypto = 'https://api.coingecko.com/api/v3/coins/list';
  final List<Crypto> _predefinedCryptos = [];

  Future<bool> _checkConnectivity(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showError(context, "No Internet connection. Please try again later.");
      return false;
    }
    return true;
  }

  Future<void> fetchCryptosFromFirestore(BuildContext context,
      UserApp user) async {
    if (!(await _checkConnectivity(context))) return;

    try {
      QuerySnapshot snapshot = await _firestore.collection('crypto').where(
          'user', isEqualTo: user.UserEmail).get();
      _predefinedCryptos.clear();

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        Crypto crypto = Crypto(
            name: data['name'] ?? '',
            symbol: data['symbol'] ?? '',
            currentValue: data['currentValue']?.toDouble() ?? 0.0,
            percentChange24h: data['percentChange24h']?.toDouble() ?? 0.0,
            isFavorite: data['isFavorite'] ?? false,
            user: data['user'] ?? ''
        );

        if (crypto.isFavorite) {
          _predefinedCryptos.add(crypto);
        }
      }
    } catch (error) {
      showError(context, 'Error fetching cryptos from Firestore: $error');
    }
  }

  Future<List<Crypto>> getCryptos(BuildContext context, UserApp user) async {
    if (!(await _checkConnectivity(context))) return [];

    await fetchCryptosFromFirestore(context, user);

    for (var crypto in _predefinedCryptos) {
      final symbol = '${crypto.symbol}USDT';
      final Uri url = Uri.parse(
          '$binanceBaseUrl?symbol=$symbol&interval=5m&limit=288');

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          List<dynamic> jsonResponse = json.decode(response.body);

          if (jsonResponse.isNotEmpty) {
            var latestData = jsonResponse.last;
            var firstData = jsonResponse.first;

            double currentValue = double.parse(latestData[4]);
            double price24hAgo = double.parse(firstData[4]);

            crypto.currentValue = currentValue;
            crypto.percentChange24h =
                ((currentValue - price24hAgo) / price24hAgo) * 100;
          }
        } else {
          final errorMessage = handleBinanceError(response.statusCode);
          showError(context, 'Error fetching data: $errorMessage');
          break;
        }
      } catch (error) {
        final errorMessage = handleError(error);
        showError(context, 'Error fetching data: $errorMessage');
        break;
      }
    }

    return _predefinedCryptos;
  }

  Future<void> UpdateCrypto(Crypto crypto, bool newIsFavorite,
      BuildContext context, UserApp user) async {
    if (!(await _checkConnectivity(context))) return;

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('crypto')
          .where('symbol', isEqualTo: crypto.symbol)
          .where('user', isEqualTo: user.UserEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot document = querySnapshot.docs.first;

        if (!newIsFavorite) {
          await _firestore.collection('crypto').doc(document.id).delete();
        }
      } else {
        saveCrypto(crypto, user, context);
      }
    } catch (e) {
      showError(context,
          "Sorry we have a problem to found your crypto, please retry");
    }
  }

  Future<void> saveCrypto(Crypto crypto, UserApp user,
      BuildContext context) async {
    try {
      await _firestore.collection('crypto').add({
        'name': crypto.name,
        'symbol': crypto.symbol,
        'isFavorite': crypto.isFavorite,
        'user': user.UserEmail
      });
    } catch (e) {
      showError(context, "Error saving crypto: ${handleError(e)}");
    }
  }

  Future<List<CryptoSpot>> getCryptoHistory(Crypto crypto, String period,
      BuildContext context) async {
    try {
      final String symbol = '${crypto.symbol}USDT';
      String interval = '';
      final DateTime now = DateTime.now().toUtc();
      final int startTime;
      final int endTime = now.millisecondsSinceEpoch;

      switch (period) {
        case 'Today':
          final DateTime startOf24HoursAgo = now.subtract(const Duration(hours: 24));
          startTime = startOf24HoursAgo.millisecondsSinceEpoch;
          interval = '5m';
          break;

        case 'This Week':
          final DateTime weekStart = now.subtract(const Duration(days: 6));
          startTime = DateTime(weekStart.year, weekStart.month, weekStart.day)
              .millisecondsSinceEpoch;
          interval = '30m';
          break;

        case 'This Month':
          final DateTime monthStart = now.subtract(const Duration(days: 30));
          startTime =
              DateTime(monthStart.year, monthStart.month, monthStart.day)
                  .millisecondsSinceEpoch;
          interval = '1d';
          break;

        default:
          throw Exception('Unsupported period: $period');
      }

      final Uri url = Uri.parse(
          '$binanceBaseUrl?symbol=$symbol&interval=$interval&startTime=$startTime&endTime=$endTime');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<CryptoSpot> spots = [];
        double highestPrice = double.negativeInfinity;
        double lowestPrice = double.infinity;
        double startPrice = 0.0;

        int positionXaxis = 0;
        for (var i = 0; i < jsonResponse.length; i++) {
          var candle = jsonResponse[i];
          final int timestamp = candle[0];
          final double close = double.parse(candle[4]);

          if (i == 0) {
            startPrice = close;
          }

          final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp)
              .toLocal();
          double timeValue;
          String timeString;

          if (period == 'Today') {
            timeValue = (positionXaxis + 1).toDouble();
            timeString =
            '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString()
                .padLeft(2, '0')}';
          } else if (period == 'This Week') {
            timeValue = (positionXaxis + 1).toDouble();
            timeString = '${date.day}/${date.month}';
          } else if (period == 'This Month') {
            timeValue = (positionXaxis + 1).toDouble();
            timeString = '${date.day}/${date.month}';
          } else {
            throw Exception('Unsupported period: $period');
          }

          spots.add(CryptoSpot(timeValue, timeString, close));

          positionXaxis++;

          if (close > highestPrice) highestPrice = close;
          if (close < lowestPrice) lowestPrice = close;
        }

        crypto.high24h = highestPrice;
        crypto.low24h = lowestPrice;
        crypto.currentValue = spots.last.value;
        crypto.percentChange24h =
            ((crypto.currentValue - startPrice) / startPrice) * 100;

        return spots;
      } else {
        final errorMessage = handleBinanceError(response.statusCode);
        showError(context, 'Error fetching historical data for ${crypto
            .symbol}: $errorMessage');
        return [];
      }
    } catch (error) {
      final errorMessage = handleError(error);
      showError(context,
          'Error fetching historical data for ${crypto.symbol}: $errorMessage');
      return [];
    }
  }

  Future<Crypto?> searchCryptoOnline(String query, BuildContext context,
      UserApp user) async {
    if (!(await _checkConnectivity(context))) return null;

    String symboltoResearch = query.toUpperCase();
    final response = await http.get(Uri.parse(CoingeckoListCrypto));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      for (var crypto in jsonResponse) {
        if (crypto['symbol'] == symboltoResearch) {
          return Crypto(
              name: crypto['name'],
              symbol: crypto['symbol'],
              currentValue: 0.0,
              percentChange24h: 0.0,
              isFavorite: false,
              user: user.UserEmail
          );
        }
      }
      showError(context, "Crypto not found");
      return null;
    } else {
      showError(context,
          "Error fetching crypto: ${handleBinanceError(response.statusCode)}");
      return null;
    }
  }

}