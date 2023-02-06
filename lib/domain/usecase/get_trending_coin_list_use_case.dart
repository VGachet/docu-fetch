import 'package:clean_architecture_getx/domain/model/coin.dart';
import 'package:clean_architecture_getx/domain/repository/MainRepository.dart';
import 'package:clean_architecture_getx/domain/usecase/usecase.dart';
import 'package:clean_architecture_getx/util/resource.dart';

class GetTrendingCoinListUseCase
    implements SimpleUseCase<Resource<List<Coin>>> {
  final MainRepository mainRepository;

  const GetTrendingCoinListUseCase({required this.mainRepository});

  @override
  Future<Resource<List<Coin>>> call() => mainRepository.getTrendingCoinList();
}
