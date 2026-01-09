class Coin {
  final String uuid;
  final String symbol;
  final String name;
  final String iconUrl;
  final String price;
  final String change;
  final int rank;
  final String? marketCap;
  final String? description;
  final String? websiteUrl;
  final String? color;

  Coin({
    required this.uuid, required this.symbol, required this.name,
    required this.iconUrl, required this.price, required this.change,
    required this.rank, this.marketCap, this.description, this.websiteUrl, this.color,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      uuid: json['uuid'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
      price: json['price'] ?? '0',
      change: json['change'] ?? '0',
      rank: json['rank'] ?? 0,
      marketCap: json['marketCap'],
      description: json['description'],
      websiteUrl: json['websiteUrl'],
      color: json['color'],
    );
  }

  @override
  String toString() {
    return 'Coin(uuid: $uuid, name: $name, symbol: $symbol, price: $price, change: $change)';
  }
}