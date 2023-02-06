import 'package:clean_architecture_getx/data/datasource/remote/request/coin_list_param.dart';
import 'package:clean_architecture_getx/domain/model/coin.dart';
import 'package:clean_architecture_getx/util/resource.dart';

abstract class MainRepository {
  Future<Resource<List<Coin>>> getTrendingCoinList();

  Future<Resource<List<Coin>>> getCoinList(CoinListParam coinListParam);
}
