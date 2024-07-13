import 'package:clean_architecture_getx/data/networking/networking.dart';
import 'package:clean_architecture_getx/data/networking/networking_impl.dart';
import 'package:clean_architecture_getx/data/repository/main_repository_impl.dart';
import 'package:clean_architecture_getx/domain/repository/main_repository.dart';
import 'package:clean_architecture_getx/domain/usecase/download_pdf_use_case.dart';
import 'package:clean_architecture_getx/domain/usecase/get_pdf_list_use_case.dart';
import 'package:clean_architecture_getx/presentation/main_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

Future<void> initDependencies() async {
  //Dio client
  final Dio dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3)));
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  Get.put<Dio>(dio);

  Get.put(MainController(), permanent: true);

  //Networking
  Get.lazyPut<Networking>(() => NetworkingImpl(dio: Get.find()), fenix: true);

  //Repositories
  Get.lazyPut<MainRepository>(() => MainRepositoryImpl(networking: Get.find()),
      fenix: true);

  //Use cases
  Get.lazyPut(() => DownloadPdfUseCase(mainRepository: Get.find()),
      fenix: true);
  Get.lazyPut(() => GetPdfListUseCase(mainRepository: Get.find()), fenix: true);
}
