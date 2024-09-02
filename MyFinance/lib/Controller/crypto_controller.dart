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
        Uri.parse('$capMarketUrl?start=1&limit=7&convert=USD'),
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
  Future<List<CryptoSpot>> getCryptoTodayHistory(Crypto crypto) async {
    try {
      final String symbol = crypto.symbol + 'USDT';  // Append 'USDT' to get the trading pair.
      const String interval = '5m';  // 5-minute intervals for the historical data.

      final DateTime now = DateTime.now().toUtc();
      final DateTime todayStart = DateTime(now.year, now.month, now.day);
      final int startTime = todayStart.millisecondsSinceEpoch;
      final int endTime = now.millisecondsSinceEpoch;

      final Uri url = Uri.parse(
          '$binanceBaseUrl?symbol=$symbol&interval=$interval&startTime=$startTime&endTime=$endTime');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);

        List<CryptoSpot> spots = [];
        for (var candle in jsonResponse) {
          final int timestamp = candle[0];
          final double close = double.parse(candle[4]);

          final DateTime date =
          DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
          final double timeValue = date.hour + date.minute / 60.0;
          final String timeString =
              '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

          spots.add(CryptoSpot(timeValue, timeString, close));
        }
        return spots;
      } else {
        throw Exception(
            'Failed to load historical data from Binance. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching historical data: $error');
    }
  }

}
