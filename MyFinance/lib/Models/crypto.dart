class Crypto {
  final String name;
  final String symbol;
  final double currentValue;
  final double percentChange24h;


  Crypto({
    required this.name,
    required this.symbol,
    required this.currentValue,
    required this.percentChange24h,
  });
}
