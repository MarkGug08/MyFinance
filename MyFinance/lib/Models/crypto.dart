class Crypto {
  String name;
  String symbol;
  double currentValue;
  double percentChange24h;
  double high24h;
  double low24h;
  bool isFavorite;

  Crypto({
    required this.name,
    required this.symbol,
    required this.currentValue,
    required this.percentChange24h,
    this.high24h = 0.0,
    this.low24h = 0.0,
    this.isFavorite = false,
  });

// Getter e Setter sono opzionali se non hai bisogno di logica aggiuntiva
// per high24h e low24h. Se hai solo bisogno di accesso pubblico, puoi
// omettere i getter e setter e usare direttamente le variabili.
}
