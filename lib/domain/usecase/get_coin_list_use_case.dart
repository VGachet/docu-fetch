import 'package:clean_architecture_getx/data/datasource/remote/request/coin_list_param.dart';
import 'package:clean_architecture_getx/domain/model/coin.dart';
import 'package:clean_architecture_getx/domain/repository/MainRepository.dart';
import 'package:clean_architecture_getx/domain/usecase/usecase.dart';
import 'package:clean_architecture_getx/util/resource.dart';

class GetCoinListUseCase
    implements UseCase<Resource<List<Coin>>, CoinListParam> {
  final MainRepository mainRepository;

  const GetCoinListUseCase({required this.mainRepository});

  @override
  Future<Resource<List<Coin>>> call(CoinListParam coinListParam) =>
      mainRepository.getCoinList(coinListParam);
}
