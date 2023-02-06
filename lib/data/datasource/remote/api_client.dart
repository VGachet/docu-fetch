import 'package:clean_architecture_getx/data/datasource/remote/response/coingecko_coins_dto.dart';
import 'package:clean_architecture_getx/data/datasource/remote/response/coingecko_item_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import 'package:clean_architecture_getx/data/datasource/remote/response/coin_dto.dart';
import 'package:clean_architecture_getx/util/constants.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: Constants.apiBaseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/search/trending')
  Future<CoingeckoCoinsDto<CoingeckoItemDto<CoinDto>>> getTrendingCoinList();

  @GET('/coins/markets')
  Future<List<CoinDto>> getCoinList(
      {@Query('page') required int page,
      @Query('per_page') required int perPage,
      @Query('vs_currency') required String vsCurrency,
      @Query('order') required String order,
      @Query('sparkline') required bool sparkline});
}
