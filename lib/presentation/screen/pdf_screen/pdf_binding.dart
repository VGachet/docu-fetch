import 'package:docu_fetch/presentation/screen/pdf_screen/pdf_controller.dart';
import 'package:get/get.dart';

class PdfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PdfController>(
        () => PdfController(updateLastPageOpenedUseCase: Get.find()));
  }
}
