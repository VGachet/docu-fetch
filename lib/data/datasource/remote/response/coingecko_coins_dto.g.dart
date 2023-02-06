// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coingecko_coins_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoingeckoCoinsDto<T> _$CoingeckoCoinsDtoFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    CoingeckoCoinsDto<T>(
      coins: (json['coins'] as List<dynamic>).map(fromJsonT).toList(),
    );

Map<String, dynamic> _$CoingeckoCoinsDtoToJson<T>(
  CoingeckoCoinsDto<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'coins': instance.coins.map(toJsonT).toList(),
    };
