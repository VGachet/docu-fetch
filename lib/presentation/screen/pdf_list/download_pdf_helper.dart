import 'package:docu_fetch/data/networking/networking.dart';
import 'package:docu_fetch/domain/model/download_data.dart';
import 'package:docu_fetch/domain/model/folder.dart';
import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/domain/usecase/download_pdf_use_case.dart';
import 'package:docu_fetch/domain/usecase/get_pdf_list_use_case.dart';
import 'package:docu_fetch/domain/usecase/insert_local_folder_use_case.dart';
import 'package:docu_fetch/domain/usecase/insert_local_pdf_use_case.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_margins.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_theme.dart';
import 'package:docu_fetch/presentation/widget/alert_message.dart';
import 'package:docu_fetch/util/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class DownloadPdfHelper {
  DownloadPdfHelper({
    required this.downloadPdfUseCase,
    required this.getPdfListUseCase,
    required this.insertLocalPdfUseCase,
    required this.insertLocalFolderUseCase,
    required this.pdfList,
  });

  final DownloadPdfUseCase downloadPdfUseCase;
  final GetPdfListUseCase getPdfListUseCase;
  final InsertLocalPdfUseCase insertLocalPdfUseCase;
  final InsertLocalFolderUseCase insertLocalFolderUseCase;
  final List<Pdf> pdfList;

  Rxn<DownloadData> downloadData = Rxn();

  Future<void> downloadPdf(
      {required String repositoryUrl,
      required String repositoryName,
      required int? parentFolderId}) async {
    final localPath = '${(await getApplicationDocumentsDirectory()).path}/pdfs';

    downloadData.value = DownloadData();

    Get.find<Networking>().setOnDownloadProgressReceived((received, total) {
      downloadData.value?.downloadProgress = '${received / 1000000}';
      downloadData.value?.size = '${total / 1000000}';
      downloadData.value?.downloadPercent =
          '${(((received / 1000000) / (total / 1000000)) * 100).round()}';
      downloadData.refresh();
    });

    displayDownloadProgressPopup();

    final pdfListResource = await getPdfListUseCase(repositoryUrl);

    if (pdfListResource is Success) {
      final createFolderResource = await insertLocalFolderUseCase(Folder(
          title: repositoryName, order: 0, parentFolder: parentFolderId));

      if (createFolderResource is Success) {
        final List<Pdf> downloadedPdfList = pdfListResource.data!;
        for (final pdf in downloadedPdfList) {
          downloadData.value!.fileName = pdf.getTitle();
          downloadData.value!.currentDownloadIndex =
              downloadedPdfList.indexOf(pdf) + 1;
          downloadData.value!.numberOfFiles = downloadedPdfList.length;
          downloadData.refresh();

          // Check if the same version of pdf is already downloaded
          if (pdfList.firstWhereOrNull((element) =>
                  element.url == pdf.url && element.version == pdf.version) !=
              null) {
            AlertMessage.show(
                message: 'pdf_already_downloaded'.trParams({
              'pdfTitle': pdf.getTitle(),
              'pdfVersion': '${pdf.version}'
            }));
            await Future.delayed(const Duration(milliseconds: 1300));
            continue;
          }

          final downloadPdfResource = await downloadPdfUseCase(
              pdf.copyWith(path: '$localPath/${pdf.title}-${pdf.version}.pdf'));

          if (downloadPdfResource is Success) {
            await insertLocalPdfUseCase(downloadPdfResource.data!.copyWith(
                folderId: createFolderResource.data!,
                order: downloadedPdfList.indexOf(pdf)));
          } else {
            AlertMessage.show(
                message: 'error_downloading_pdf'
                    .trParams({'pdfTitle': pdf.getTitle()}));
          }

          downloadData.value?.fileName = '';
          downloadData.refresh();
        }
      } else {
        AlertMessage.show(message: 'error_creating_folder'.tr);
      }
    } else {
      AlertMessage.show(message: 'error_downloading_files'.tr);
    }

    downloadData.value = null;
    downloadData.refresh();

    Navigator.pop(Get.overlayContext!);
  }

  void displayDownloadProgressPopup() {
    showDialog(
      barrierDismissible: false,
      context: Get.overlayContext!,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        title: Text('downloading_pdf'.tr,
            style: CustomTheme.body, textAlign: TextAlign.center),
        content: Obx(
          () => downloadData.value != null
              ? Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                      '${downloadData.value!.currentDownloadIndex.toString()}/${downloadData.value!.numberOfFiles}',
                      style: CustomTheme.body,
                      textAlign: TextAlign.center),
                  const SizedBox(height: CustomMargins.margin16),
                  Text(downloadData.value!.fileName,
                      style: CustomTheme.body, textAlign: TextAlign.center),
                  if (downloadData.value?.downloadProgress != '')
                    const SizedBox(height: CustomMargins.margin16),
                  if (downloadData.value?.downloadProgress != '')
                    Text(
                        'downloading'.trParams({
                          'currentDownloadedSize':
                              downloadData.value?.downloadProgress ?? '0',
                          'totalSize': downloadData.value?.size ?? '0',
                        }),
                        style: CustomTheme.body,
                        textAlign: TextAlign.center),
                  const SizedBox(height: CustomMargins.margin16),
                  if (downloadData.value?.downloadPercent != '')
                    SizedBox(
                        width: Get.width,
                        height: 100,
                        child: Center(
                            child: Stack(children: [
                          Center(
                              child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Obx(() => CircularProgressIndicator(
                                        value: ((double.tryParse(downloadData
                                                        .value
                                                        ?.downloadPercent ??
                                                    '0') ??
                                                0) /
                                            100),
                                      )))),
                          if (downloadData.value?.downloadPercent != '')
                            Center(
                                child: Obx(() => Text(
                                      '${downloadData.value?.downloadPercent ?? 0}%',
                                      style: CustomTheme.body,
                                      textAlign: TextAlign.center,
                                    ))),
                        ])))
                ])
              : const SizedBox(),
        ),
      ),
    );
  }
}
