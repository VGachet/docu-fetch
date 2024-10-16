import 'package:docu_fetch/presentation/screen/pdf_list/pdf_list_controller.dart';
import 'package:get/get.dart';

class PdfListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PdfListController>(() => PdfListController(
          getLocalPdfListUseCase: Get.find(),
          getLocalFolderListUseCase: Get.find(),
        ));
  }
}
