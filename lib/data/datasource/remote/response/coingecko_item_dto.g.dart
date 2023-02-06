// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coingecko_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoingeckoItemDto<T> _$CoingeckoItemDtoFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    CoingeckoItemDto<T>(
      _$nullableGenericFromJson(json['item'], fromJsonT),
    );

Map<String, dynamic> _$CoingeckoItemDtoToJson<T>(
  CoingeckoItemDto<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'item': _$nullableGenericToJson(instance.item, toJsonT),
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
