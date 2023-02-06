// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_list_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinListParam _$CoinListParamFromJson(Map<String, dynamic> json) =>
    CoinListParam(
      page: json['page'] as int,
      perPage: json['perPage'] as int,
      vsCurrency: json['vsCurrency'] as String,
      order: json['order'] as String,
      sparkline: json['sparkline'] as bool,
    );

Map<String, dynamic> _$CoinListParamToJson(CoinListParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'perPage': instance.perPage,
      'vsCurrency': instance.vsCurrency,
      'order': instance.order,
      'sparkline': instance.sparkline,
    };
