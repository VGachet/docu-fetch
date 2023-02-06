import 'package:json_annotation/json_annotation.dart';

part 'coin_list_param.g.dart';

@JsonSerializable()
class CoinListParam {
  final int page;
  final int perPage;
  final String vsCurrency;
  final String order;
  final bool sparkline;

  const CoinListParam(
      {required this.page,
      required this.perPage,
      required this.vsCurrency,
      required this.order,
      required this.sparkline});

  factory CoinListParam.fromJson(Map<String, dynamic> json) =>
      _$CoinListParamFromJson(json);

  Map<String, dynamic> toJson() => _$CoinListParamToJson(this);
}
