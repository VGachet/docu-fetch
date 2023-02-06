import 'package:clean_architecture_getx/data/datasource/remote/api_client.dart';
import 'package:clean_architecture_getx/data/repository/main_repository_impl.dart';
import 'package:clean_architecture_getx/domain/repository/MainRepository.dart';
import 'package:clean_architecture_getx/domain/usecase/get_coin_list_use_case.dart';
import 'package:clean_architecture_getx/domain/usecase/get_trending_coin_list_use_case.dart';
import 'package:clean_architecture_getx/presentation/main_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

Future<void> initDependencies() async {
  //Dio client
  final Dio dio = Dio(BaseOptions(connectTimeout: 5000, receiveTimeout: 3000));
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  Get.put<Dio>(dio);

  //Api client
  Get.put<ApiClient>(ApiClient(Get.find()));

  Get.put(MainController(), permanent: true);

  //Repositories
  Get.lazyPut<MainRepository>(() => MainRepositoryImpl(Get.find()),
      fenix: true);

  //Use cases
  Get.lazyPut(() => GetTrendingCoinListUseCase(mainRepository: Get.find()),
      fenix: true);
  Get.lazyPut(() => GetCoinListUseCase(mainRepository: Get.find()),
      fenix: true);
}
