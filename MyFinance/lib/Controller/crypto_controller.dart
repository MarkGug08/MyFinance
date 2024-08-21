import '../Models/Crypto.dart';

class CryptoController {

  List<Crypto> createCryptos() {
    return [
      Crypto(name: 'Bitcoin', symbol: 'BTC', currentValue: 29000.0),
      Crypto(name: 'Ethereum', symbol: 'ETH', currentValue: 1800.0),
      Crypto(name: 'Ripple', symbol: 'XRP', currentValue: 0.55),
      Crypto(name: 'Litecoin', symbol: 'LTC', currentValue: 90.0),
      Crypto(name: 'Cardano', symbol: 'ADA', currentValue: 0.35),
    ];
  }
}
