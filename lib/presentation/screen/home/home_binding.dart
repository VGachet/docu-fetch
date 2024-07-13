import 'package:clean_architecture_getx/presentation/screen/home/home_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(
          downloadPdfUseCase: Get.find(),
          getPdfListUseCase: Get.find(),
        ));
  }
}
