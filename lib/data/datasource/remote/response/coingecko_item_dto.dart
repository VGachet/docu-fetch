import 'package:json_annotation/json_annotation.dart';

part 'coingecko_item_dto.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class CoingeckoItemDto<T> {
  final T? item;

  CoingeckoItemDto(this.item);

  factory CoingeckoItemDto.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CoingeckoItemDtoFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$CoingeckoItemDtoToJson(this, toJsonT);
}
