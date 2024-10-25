import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/domain/model/pdf_last_page_open_param.dart';
import 'package:docu_fetch/domain/usecase/update_last_page_opened_use_case.dart';
import 'package:docu_fetch/domain/usecase/update_pdf_use_case.dart';
import 'package:docu_fetch/presentation/main_controller.dart';
import 'package:docu_fetch/presentation/widget/alert_message.dart';
import 'package:docu_fetch/util/resource.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfController extends GetxController {
  final Pdf pdfArgument = Get.arguments as Pdf;
  final Rxn<Pdf> pdf = Rxn<Pdf>();

  final UpdateLastPageOpenedUseCase updateLastPageOpenedUseCase;
  final UpdateLocalPdfUseCase updateLocalPdfUseCase;

  final MainController mainController = Get.find();

  PdfController({
    required this.updateLastPageOpenedUseCase,
    required this.updateLocalPdfUseCase,
  });

  RxBool isAppBarVisible = true.obs;

  var zoomLevel = 1.0.obs;

  final PdfViewerController pdfViewerController = PdfViewerController();

  @override
  void onInit() {
    super.onInit();
    pdf.value = pdfArgument;
  }

  void updateLastPageOpened(int lastPage) async {
    final resource = await updateLastPageOpenedUseCase(
        PdfLastPageOpenParam(id: pdf.value!.id!, lastPage: lastPage));

    if (resource is Error) {
      AlertMessage.show(message: 'error_update_last_page_opened'.tr);
    }
  }

  void toggleAppBarVisibility() {
    isAppBarVisible.value = !isAppBarVisible.value;
  }

  Future<void> toggleScrollDirection() async {
    mainController.isLoading.value = true;

    final updatedPdf =
        pdf.value!.copyWith(isHorizontal: !pdf.value!.isHorizontal);

    final updatePdfOrientationResource =
        await updateLocalPdfUseCase(updatedPdf);

    if (updatePdfOrientationResource is Success) {
      pdf.value = updatedPdf;
    } else {
      AlertMessage.show(message: 'error_update_pdf_orientation'.tr);
    }

    mainController.isLoading.value = false;
  }

  Future<void> toggleLayoutMode() async {
    mainController.isLoading.value = true;

    final updatedPdf =
        pdf.value!.copyWith(isContinuous: !pdf.value!.isContinuous);

    final updatePdfOrientationResource =
        await updateLocalPdfUseCase(updatedPdf);

    if (updatePdfOrientationResource is Success) {
      pdf.value = updatedPdf;
    } else {
      AlertMessage.show(message: 'error_update_pdf_orientation'.tr);
    }

    mainController.isLoading.value = false;
  }

  // Method to update the zoom level
  void updateZoomLevel(double newZoomLevel) {
    pdfViewerController.zoomLevel = newZoomLevel;
    zoomLevel.value = newZoomLevel;
  }

  @override
  void onClose() {
    if (pdf.value != null) {
      updateLastPageOpened(pdf.value!.lastPageOpened);
    }
    super.onClose();
  }
}
