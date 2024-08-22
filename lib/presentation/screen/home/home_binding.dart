import 'package:docu_fetch/presentation/screen/home/home_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(
          downloadPdfUseCase: Get.find(),
          getPdfListUseCase: Get.find(),
          insertLocalPdfUseCase: Get.find(),
          getLocalPdfListUseCase: Get.find(),
          deleteLocalPdfUseCase: Get.find(),
          updateLocalPdfUseCase: Get.find(),
          insertLocalRepositoryUseCase: Get.find(),
          getLocalRepositoryListUseCase: Get.find(),
          deleteLocalRepositoryUseCase: Get.find(),
          insertLocalFolderUseCase: Get.find(),
          getLocalFolderListUseCase: Get.find(),
          updateLocalFolderUseCase: Get.find(),
        ));
  }
}
