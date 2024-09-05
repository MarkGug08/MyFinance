import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Models/Crypto.dart';
import '../Widget/error.dart';


class CryptoSpot {
  final double time;
  final String timeString;
  final double value;

  CryptoSpot(this.time, this.timeString, this.value);
}

// Controller to handle fetching data from the API
class CryptoController {
  static const String binanceBaseUrl = 'https://api.binance.com/api/v3/klines';

  // Predefined list of cryptocurrencies with default values
  final List<Crypto> _predefinedCryptos = [
    Crypto(name: 'Bitcoin', symbol: 'BTC', currentValue: 0.0, percentChange24h: 0.0),
    Crypto(name: 'Ethereum', symbol: 'ETH', currentValue: 0.0, percentChange24h: 0.0),
    Crypto(name: 'Binance Coin', symbol: 'BNB', currentValue: 0.0, percentChange24h: 0.0),
    Crypto(name: 'Cardano', symbol: 'ADA', currentValue: 0.0, percentChange24h: 0.0),
    Crypto(name: 'Solana', symbol: 'SOL', currentValue: 0.0, percentChange24h: 0.0),
    Crypto(name: 'Ripple', symbol: 'XRP', currentValue: 0.0, percentChange24h: 0.0),
    Crypto(name: 'Polkadot', symbol: 'DOT', currentValue: 0.0, percentChange24h: 0.0),
    Crypto(name: 'Litecoin', symbol: 'LTC', currentValue: 0.0, percentChange24h: 0.0),
  ];

  // Fetch data for predefined cryptocurrencies
  Future<List<Crypto>> getCryptos(BuildContext context) async {
    for (var crypto in _predefinedCryptos) {
      final symbol = crypto.symbol + 'USDT';

      // Build the URL for the Binance API request
      final Uri url = Uri.parse('$binanceBaseUrl?symbol=$symbol&interval=5m&limit=288');

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          List<dynamic> jsonResponse = json.decode(response.body);
          if (jsonResponse.isNotEmpty) {
            var latestData = jsonResponse.last;
            var firstData = jsonResponse.first;

            double currentValue = double.parse(latestData[4]);
            double price24hAgo = double.parse(firstData[4]);

            // Update the current value of the cryptocurrency
            crypto.currentValue = currentValue;

            // Calculate percentage change in the last 24 hours
            crypto.percentChange24h = ((currentValue - price24hAgo) / price24hAgo) * 100;
          }
        } else {
          final errorMessage = handleBinanceError(response.statusCode);
          showError(context, 'Error fetching data : $errorMessage');
          break;
        }
      } catch (error) {
        final errorMessage = handleError(error);
        showError(context, 'Error fetching data : $errorMessage');
        break;
      }
    }

    return _predefinedCryptos;
  }

  // Fetch historical data for a given cryptocurrency and period
  Future<List<CryptoSpot>> getCryptoHistory(Crypto crypto, String period, BuildContext context) async {
    try {
      final String symbol = crypto.symbol + 'USDT';
      String interval = '';

      final DateTime now = DateTime.now().toUtc();
      final int startTime;
      final int endTime = now.millisecondsSinceEpoch;

      // Determine time interval and start time based on the requested period
      switch (period) {
        case 'Today':
          final DateTime startOf24HoursAgo = now.subtract(Duration(hours: 24));
          startTime = startOf24HoursAgo.millisecondsSinceEpoch;
          interval = '5m';  // 5-minute intervals for historical data
          break;

        case 'This Week':
          final DateTime weekStart = now.subtract(Duration(days: 6));
          startTime = DateTime(weekStart.year, weekStart.month, weekStart.day).millisecondsSinceEpoch;
          interval = '30m';  // 30-minute intervals for historical data
          break;

        case 'This Month':
          final DateTime monthStart = now.subtract(Duration(days: 30));
          startTime = DateTime(monthStart.year, monthStart.month, monthStart.day).millisecondsSinceEpoch;
          interval = '1d';  // 1-day intervals for historical data
          break;

        default:
          throw Exception('Unsupported period: $period');
      }

      // Build the API request URL for fetching historical data
      final Uri url = Uri.parse(
          '$binanceBaseUrl?symbol=$symbol&interval=$interval&startTime=$startTime&endTime=$endTime');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);

        List<CryptoSpot> spots = [];
        double highestPrice = double.negativeInfinity;
        double lowestPrice = double.infinity;
        double startPrice = 0.0;

        // Process the data to create CryptoSpot instances
        for (var i = 0; i < jsonResponse.length; i++) {
          var candle = jsonResponse[i];
          final int timestamp = candle[0];
          final double close = double.parse(candle[4]);

          if (i == 0) {
            startPrice = close;
          }

          final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();

          double timeValue;
          String timeString;

          if (period == 'Today') {
            timeValue = (date.difference(now.subtract(Duration(hours: 24))).inMinutes / 60.0);
            timeString = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
          } else if (period == 'This Week') {
            timeValue = date.difference(now.subtract(Duration(days: 6))).inMinutes / 1440.0;
            timeString = '${date.day}/${date.month}';
          } else if (period == 'This Month') {
            timeValue = date.difference(now.subtract(Duration(days: 30))).inHours.toDouble();
            timeString = '${date.day}/${date.month}';
          } else {
            throw Exception('Unsupported period: $period');
          }

          spots.add(CryptoSpot(timeValue, timeString, close));

          // Track the highest and lowest prices
          if (close > highestPrice) highestPrice = close;
          if (close < lowestPrice) lowestPrice = close;
        }

        // Update the cryptocurrency with the highest/lowest prices
        crypto.high24h = highestPrice;
        crypto.low24h = lowestPrice;
        crypto.currentValue = spots.last.value;

        // Calculate percentage change from the start of the period
        crypto.percentChange24h = ((crypto.currentValue - startPrice) / startPrice) * 100;

        return spots;
      } else {
        final errorMessage = handleBinanceError(response.statusCode);
        showError(context, 'Error fetching historical data for ${crypto.symbol}: $errorMessage');
        return []; // Return an empty list in case of error
      }
    } catch (error) {
      final errorMessage = handleError(error);
      showError(context, 'Error fetching historical data for ${crypto.symbol}: $errorMessage');
      return []; // Return an empty list in case of error
    }
  }

  // Search for a cryptocurrency online by its name
  Future<Crypto?> searchCryptoOnline(String query, BuildContext context) async {
    // Construct the symbol by appending 'USDT' to the query
    final String symbol = query.toUpperCase() + 'USDT';
    final Uri url = Uri.parse('$binanceBaseUrl?symbol=$symbol&interval=5m&limit=1');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
          var latestData = jsonResponse.last;

          double currentValue = double.parse(latestData[4]);

          // Create a new Crypto instance with the fetched data
          Crypto crypto = Crypto(
            name: query.toUpperCase(),
            symbol: query.toUpperCase(),
            currentValue: currentValue,
            percentChange24h: 0.0,
          );

          return crypto;
        }
      } else {
        final errorMessage = handleBinanceError(response.statusCode);
        //showError(context, errorMessage);
      }
    } catch (error) {
      showError(context, 'Error fetching online crypto: ${error.toString()}');
    }
    return null;
  }
}
