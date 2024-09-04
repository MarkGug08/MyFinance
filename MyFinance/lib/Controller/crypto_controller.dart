import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/Crypto.dart';

class CryptoSpot {
  final double time;
  final String timeString;
  final double value;

  CryptoSpot(this.time, this.timeString, this.value);
}

/// Manages fetching cryptocurrency data from CoinMarketCap and Binance APIs.
class CryptoController {
  static const String capMarketApiKey = '633ea918-17e5-4e0d-8f5b-15c550120564';
  static const String capMarketUrl = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest';
  static const String binanceBaseUrl = 'https://api.binance.com/api/v3/klines';

  /// Fetches cryptocurrency data from CoinMarketCap and values from Binance API.
  Future<List<Crypto>> getCryptos() async {
    try {
      final cmcResponse = await http.get(
        Uri.parse('$capMarketUrl?start=1&limit=3&convert=USD'),
        headers: {
          'Accept': 'application/json',
          'X-CMC_PRO_API_KEY': capMarketApiKey,
        },
      );

      if (cmcResponse.statusCode == 200) {
        var cmcJsonResponse = json.decode(cmcResponse.body);
        List<dynamic> data = cmcJsonResponse['data'];

        List<Crypto> cryptos = [];
        for (var item in data) {
          String symbol = item['symbol'] + 'USDT'; // Binance uses the pair with USDT

          // Fetch current price from Binance
          final binanceResponse = await http.get(
            Uri.parse('$binanceBaseUrl?symbol=$symbol&interval=1d&limit=1'),
          );

          if (binanceResponse.statusCode == 200) {
            var binanceJsonResponse = json.decode(binanceResponse.body);
            var binanceData = binanceJsonResponse[0];
            double currentValue = double.parse(binanceData[4]);

            // Create a Crypto object with the obtained data
            cryptos.add(Crypto(
              name: item['name'],
              symbol: item['symbol'].toUpperCase(),
              currentValue: currentValue,
              percentChange24h: item['quote']['USD']['percent_change_24h'].toDouble(),
            ));
          }
        }
        return cryptos;
      } else {
        throw Exception('Failed to load cryptos from CoinMarketCap. Status code: ${cmcResponse.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching cryptos: $error');
    }
  }


  /// Fetches and prints the historical data for a specific cryptocurrency using Binance API.
  Future<List<CryptoSpot>> getCryptoHistory(Crypto crypto, String period) async {
    try {
      final String symbol = crypto.symbol + 'USDT';  // Append 'USDT' to get the trading pair.
      String interval = '';  // intervals for the historical data.

      final DateTime now = DateTime.now().toUtc();
      final int startTime;

      switch (period) {
        case 'Today':
          final DateTime todayStart = DateTime(now.year, now.month, now.day);
          startTime = todayStart.millisecondsSinceEpoch;
          interval = '5m';  // 5-minute intervals for the historical data.
          break;

        case 'This Week':
          final DateTime weekStart = now.subtract(Duration(days: 6)); // Get the start of the week
          startTime = DateTime(weekStart.year, weekStart.month, weekStart.day).millisecondsSinceEpoch;
          interval = '30m';  // 30-minute intervals for the historical data.
          break;

        case 'This Month':
          final DateTime monthStart = now.subtract(Duration(days: 29)); // 30 days from today
          startTime = DateTime(monthStart.year, monthStart.month, monthStart.day).millisecondsSinceEpoch;
          interval = '1d';  // 1-day intervals for the historical data.
          break;

        default:
          throw Exception('Unsupported period: $period');
      }

      final int endTime = now.millisecondsSinceEpoch;

      final Uri url = Uri.parse(
          '$binanceBaseUrl?symbol=$symbol&interval=$interval&startTime=$startTime&endTime=$endTime');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);

        List<CryptoSpot> spots = [];
        double highestPrice = double.negativeInfinity;
        double lowestPrice = double.infinity;

        for (var candle in jsonResponse) {
          final int timestamp = candle[0];
          final double close = double.parse(candle[4]);

          final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();

          // Calculate the `timeValue` and `timeString` based on the selected period.
          double timeValue;
          String timeString;

          if (period == 'Today') {
            timeValue = (date.hour * 60 + date.minute) / 60.0; // Time as fraction of the day
            timeString = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
          } else if (period == 'This Week') {
            timeValue = date.difference(now.subtract(Duration(days: 6))).inMinutes / 1440.0; // Time as days from start of week
            timeString = '${date.day}/${date.month}';
          } else if (period == 'This Month') {
            timeValue = date.difference(now.subtract(Duration(days: 29))).inDays.toDouble(); // Time as days from start of the last 30 days
            timeString = '${date.day}/${date.month}';
          } else {
            throw Exception('Unsupported period: $period');
          }

          spots.add(CryptoSpot(timeValue, timeString, close));

          // Update highest and lowest prices
          if (close > highestPrice) highestPrice = close;
          if (close < lowestPrice) lowestPrice = close;
        }

        // Update the crypto object with the calculated high and low values
        crypto.high24h = highestPrice;
        crypto.low24h = lowestPrice;

        print(crypto.high24h);
        print(crypto.low24h);

        return spots;
      } else {
        throw Exception('Failed to load historical data from Binance. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching historical data: $error');
    }
  }




}
