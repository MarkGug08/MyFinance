class Crypto {
  String name;
  String symbol;
  double currentValue;
  double percentChange24h;
  double high24h;
  double low24h;
  bool isFavorite;
  String user;

  Crypto({
    required this.name,
    required this.symbol,
    required this.currentValue,
    required this.percentChange24h,
    this.high24h = 0.0,
    this.low24h = 0.0,
    required this.isFavorite,
    required this.user
  });


}
