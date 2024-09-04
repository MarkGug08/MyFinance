class Crypto {
  String name;
  String symbol;
  double currentValue;
  double percentChange24h;
  double _high24h;
  double _low24h;

  Crypto({
    required this.name,
    required this.symbol,
    required this.currentValue,
    required this.percentChange24h,
    double high24h = 0.0,
    double low24h = 0.0,
  })  : _high24h = high24h,
        _low24h = low24h;

  // Getter per high24h
  double get high24h => _high24h;

  // Setter per high24h
  set high24h(double value) {
    _high24h = value;
  }

  // Getter per low24h
  double get low24h => _low24h;

  // Setter per low24h
  set low24h(double value) {
    _low24h = value;
  }
}
