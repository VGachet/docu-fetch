import 'package:json_annotation/json_annotation.dart';

part 'coingecko_coins_dto.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class CoingeckoCoinsDto<T> {
  final List<T> coins;

  CoingeckoCoinsDto({
    required this.coins,
  });

  factory CoingeckoCoinsDto.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CoingeckoCoinsDtoFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$CoingeckoCoinsDtoToJson(this, toJsonT);
}
