import 'package:clean_architecture_getx/domain/model/coin.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coin_dto.g.dart';

/*
"id": "bitcoin",
    "symbol": "btc",
    "name": "Bitcoin",
    "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
    "current_price": 22853,
    "market_cap": 440215426425,
    "market_cap_rank": 1,
    "fully_diluted_valuation": 479410051791,
    "total_volume": 30872353207,
    "high_24h": 23209,
    "low_24h": 22739,
    "price_change_24h": -342.22161773443077,
    "price_change_percentage_24h": -1.47537,
    "market_cap_change_24h": -7336203851.404968,
    "market_cap_change_percentage_24h": -1.63919,
    "circulating_supply": 19283125,
    "total_supply": 21000000,
    "max_supply": 21000000,
    "ath": 69045,
    "ath_change_percentage": -66.93147,
    "ath_date": "2021-11-10T14:24:11.849Z",
    "atl": 67.81,
    "atl_change_percentage": 33571.17728,
    "atl_date": "2013-07-06T00:00:00.000Z",
    "roi": null,
    "last_updated": "2023-02-06T14:47:02.528Z"
 */

@JsonSerializable(explicitToJson: true)
class CoinDto {
  String id;
  String symbol;
  String name;
  String? image;
  String? thumb;
  @JsonKey(name: 'current_price')
  double? currentPrice;
  @JsonKey(name: 'market_cap')
  double? marketCap;
  @JsonKey(name: 'market_cap_rank')
  int? marketCapRank;
  @JsonKey(name: 'fully_diluted_valuation')
  double? fullyDilutedValuation;
  @JsonKey(name: 'total_volume')
  double? totalVolume;
  @JsonKey(name: 'high_24h')
  double? high24h;
  @JsonKey(name: 'low_24h')
  double? low24h;
  @JsonKey(name: 'price_change_24h')
  double? priceChange24h;
  @JsonKey(name: 'price_change_percentage_24h')
  double? priceChangePercentage24h;
  @JsonKey(name: 'market_cap_change_24h')
  double? marketCapChange24h;
  @JsonKey(name: 'market_cap_change_percentage_24h')
  double? marketCapChangePercentage24h;
  @JsonKey(name: 'circulating_supply')
  double? circulatingSupply;
  @JsonKey(name: 'total_supply')
  double? totalSupply;
  @JsonKey(name: 'max_supply')
  double? maxSupply;
  double? ath;
  @JsonKey(name: 'ath_change_percentage')
  double? athChangePercentage;
  @JsonKey(name: 'ath_date')
  String? athDate;
  double? atl;
  @JsonKey(name: 'atl_change_percentage')
  double? atlChangePercentage;
  @JsonKey(name: 'atl_date')
  String? atlDate;
  dynamic roi;
  @JsonKey(name: 'last_updated')
  String? lastUpdated;

  CoinDto(
      {required this.id,
      required this.symbol,
      required this.name,
      required this.image,
      required this.currentPrice,
      required this.marketCap,
      required this.marketCapRank,
      required this.fullyDilutedValuation,
      required this.totalVolume,
      required this.high24h,
      required this.low24h,
      required this.priceChange24h,
      required this.priceChangePercentage24h,
      required this.marketCapChange24h,
      required this.marketCapChangePercentage24h,
      required this.circulatingSupply,
      required this.totalSupply,
      required this.maxSupply,
      required this.ath,
      required this.athChangePercentage,
      required this.athDate,
      required this.atl,
      required this.atlChangePercentage,
      required this.atlDate,
      required this.roi,
      required this.lastUpdated});

  factory CoinDto.fromJson(Map<String, dynamic> json) =>
      _$CoinDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CoinDtoToJson(this);

  Coin toCoin() => Coin(
      id: id,
      symbol: symbol,
      name: name,
      image: image ?? thumb ?? '',
      currentPrice: currentPrice ?? -1,
      marketCap: marketCap ?? -1,
      marketCapRank: marketCapRank ?? -1);
}
