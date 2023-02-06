import 'package:clean_architecture_getx/data/datasource/remote/request/coin_list_param.dart';
import 'package:clean_architecture_getx/data/datasource/remote/response/coin_dto.dart';
import 'package:clean_architecture_getx/data/datasource/remote/response/coingecko_item_dto.dart';
import 'package:clean_architecture_getx/domain/repository/MainRepository.dart';
import 'package:dio/dio.dart';
import 'package:clean_architecture_getx/data/datasource/remote/api_client.dart';
import 'package:clean_architecture_getx/domain/model/coin.dart';
import 'package:clean_architecture_getx/util/error_manager.dart';
import 'package:clean_architecture_getx/util/resource.dart';

class MainRepositoryImpl implements MainRepository {
  final ApiClient _apiClient;

  MainRepositoryImpl(this._apiClient);

  @override
  Future<Resource<List<Coin>>> getTrendingCoinList() async {
    try {
      final trendingCoinListResponse = await _apiClient.getTrendingCoinList();

      return Success(
          trendingCoinListResponse.coins.map((e) => e.item!.toCoin()).toList());
    } on DioError catch (e) {
      return Error(getErrorStatusByDioError(e));
    }
  }

  @override
  Future<Resource<List<Coin>>> getCoinList(CoinListParam coinListParam) async {
    try {
      final response = await _apiClient.getCoinList(
          page: coinListParam.page,
          perPage: coinListParam.perPage,
          vsCurrency: coinListParam.vsCurrency,
          order: coinListParam.order,
          sparkline: coinListParam.sparkline);

      return Success(response.map((coinDto) => coinDto.toCoin()).toList());
    } on DioError catch (e) {
      return Error(getErrorStatusByDioError(e));
    }
  }
}
