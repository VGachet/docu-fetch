import 'package:dio/dio.dart';
import 'package:docu_fetch/data/datasource/local/database.dart';
import 'package:docu_fetch/data/networking/networking.dart';
import 'package:docu_fetch/data/networking/networking_impl.dart';
import 'package:docu_fetch/data/repository/main_repository_impl.dart';
import 'package:docu_fetch/domain/repository/main_repository.dart';
import 'package:docu_fetch/domain/usecase/delete_pdf_use_case.dart';
import 'package:docu_fetch/domain/usecase/delete_repository_use_case.dart';
import 'package:docu_fetch/domain/usecase/download_pdf_use_case.dart';
import 'package:docu_fetch/domain/usecase/get_local_folder_list_use_case.dart';
import 'package:docu_fetch/domain/usecase/get_local_pdf_list_use_case.dart';
import 'package:docu_fetch/domain/usecase/get_local_repository_list_use_case.dart';
import 'package:docu_fetch/domain/usecase/get_pdf_list_use_case.dart';
import 'package:docu_fetch/domain/usecase/insert_local_folder_use_case.dart';
import 'package:docu_fetch/domain/usecase/insert_local_pdf_use_case.dart';
import 'package:docu_fetch/domain/usecase/insert_local_repository_use_case.dart';
import 'package:docu_fetch/domain/usecase/update_last_page_opened_use_case.dart';
import 'package:docu_fetch/domain/usecase/update_pdf_use_case.dart';
import 'package:docu_fetch/presentation/main_controller.dart';
import 'package:docu_fetch/presentation/widget/expandable_fab/expandable_fab_controller.dart';
import 'package:get/get.dart';

Future<void> initDependencies() async {
  //Dio client
  final Dio dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3)));
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  Get.put<Dio>(dio);

  //Init floor database and register dao for fast access
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  Get.put(database, permanent: true);

  Get.put(MainController(), permanent: true);

  //Networking
  Get.lazyPut<Networking>(() => NetworkingImpl(dio: Get.find()), fenix: true);

  //Repositories
  Get.lazyPut<MainRepository>(
      () => MainRepositoryImpl(networking: Get.find(), database: Get.find()),
      fenix: true);

  //Widgets
  Get.lazyPut(() => ExpandableFabController(), fenix: true);

  //Use cases
  Get.lazyPut(() => DownloadPdfUseCase(mainRepository: Get.find()),
      fenix: true);
  Get.lazyPut(() => GetPdfListUseCase(mainRepository: Get.find()), fenix: true);
  Get.lazyPut(() => InsertLocalPdfUseCase(mainRepository: Get.find()),
      fenix: true);
  Get.lazyPut(() => GetLocalPdfListUseCase(mainRepository: Get.find()),
      fenix: true);
  Get.lazyPut(() => DeleteLocalPdfUseCase(mainRepository: Get.find()),
      fenix: true);
  Get.lazyPut(() => UpdateLastPageOpenedUseCase(mainRepository: Get.find()),
      fenix: true);
  Get.lazyPut(() => InsertLocalRepositoryUseCase(mainRepository: Get.find()),
      fenix: true);
  Get.lazyPut(() => GetLocalRepositoryListUseCase(mainRepository: Get.find()),
      fenix: true);
  Get.lazyPut(() => DeleteLocalRepositoryUseCase(mainRepository: Get.find()),
      fenix: true);
  Get.lazyPut(() => UpdateLocalPdfUseCase(mainRepository: Get.find()),
      fenix: true);
  Get.lazyPut(() => InsertLocalFolderUseCase(mainRepository: Get.find()),
      fenix: true);
  Get.lazyPut(() => GetLocalFolderListUseCase(mainRepository: Get.find()),
      fenix: true);
}
