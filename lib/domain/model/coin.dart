/*
"id": "bitcoin",
    "symbol": "btc",
    "name": "Bitcoin",
    "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
    "current_price": 22853,
    "market_cap": 440215426425,
    "market_cap_rank": 1
 */

class Coin {
  String id;
  String symbol;
  String name;
  String image;
  double currentPrice;
  double marketCap;
  int marketCapRank;

  Coin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
  });
}
