import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/Crypto.dart';

/// Manages fetching cryptocurrency data from CoinMarketCap API.
class CryptoController {

  static const String apiKey = '633ea918-17e5-4e0d-8f5b-15c550120564';
  static const String baseUrl = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest';

  /// Fetches the cryptocurrency data from the CoinMarketCap API.
  Future<List<Crypto>> getCryptos() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl + '?start=1&limit=13&convert=USD'),
        headers: {
          'Accept': 'application/json',
          'X-CMC_PRO_API_KEY': apiKey,
        },
      );

      if (response.statusCode == 200) {
        // Parses the JSON response into a list of Crypto objects
        var jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];

        return data.map((json) => _createCryptoFromJson(json)).toList();
      } else {
        throw Exception('Failed to load cryptos. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching cryptos: $error');
    }
  }

  /// Converts a JSON map into a Crypto object.
  Crypto _createCryptoFromJson(Map<String, dynamic> json) {
    return Crypto(
      name: json['name'],
      symbol: json['symbol'].toUpperCase(),
      currentValue: json['quote']['USD']['price'].toDouble(),
    );
  }
}
