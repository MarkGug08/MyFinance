class Crypto {
  final String name;
  final String symbol;
  final double currentValue;
  final double percentChange24h;
  final int high24h = 0;
  final int low24h = 0;


  Crypto({
    required this.name,
    required this.symbol,
    required this.currentValue,
    required this.percentChange24h,
  });
}
