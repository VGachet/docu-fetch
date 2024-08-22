import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/domain/model/pdf_last_page_open_param.dart';
import 'package:docu_fetch/domain/usecase/update_last_page_opened_use_case.dart';
import 'package:docu_fetch/presentation/widget/alert_message.dart';
import 'package:docu_fetch/util/resource.dart';
import 'package:get/get.dart';

class PdfController extends GetxController {
  final Pdf pdf = Get.arguments as Pdf;

  final UpdateLastPageOpenedUseCase updateLastPageOpenedUseCase;

  PdfController({required this.updateLastPageOpenedUseCase});

  void updateLastPageOpened(int lastPage) async {
    final resource = await updateLastPageOpenedUseCase(
        PdfLastPageOpenParam(id: pdf.id!, lastPage: lastPage));

    if (resource is Error) {
      AlertMessage.show(message: 'error_update_last_page_opened'.tr);
    }
  }

  @override
  void onClose() {
    updateLastPageOpened(pdf.lastPageOpened);
    super.onClose();
  }
}
