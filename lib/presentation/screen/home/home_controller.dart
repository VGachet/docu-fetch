import 'dart:async';
import 'dart:io';

import 'package:docu_fetch/data/networking/networking.dart';
import 'package:docu_fetch/domain/model/download_data.dart';
import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/domain/model/repository.dart';
import 'package:docu_fetch/domain/usecase/delete_pdf_use_case.dart';
import 'package:docu_fetch/domain/usecase/delete_repository_use_case.dart';
import 'package:docu_fetch/domain/usecase/download_pdf_use_case.dart';
import 'package:docu_fetch/domain/usecase/get_local_pdf_list_use_case.dart';
import 'package:docu_fetch/domain/usecase/get_local_repository_list_use_case.dart';
import 'package:docu_fetch/domain/usecase/get_pdf_list_use_case.dart';
import 'package:docu_fetch/domain/usecase/insert_local_pdf_use_case.dart';
import 'package:docu_fetch/domain/usecase/insert_local_repository_use_case.dart';
import 'package:docu_fetch/domain/usecase/update_pdf_use_case.dart';
import 'package:docu_fetch/presentation/main_controller.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_margins.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_theme.dart';
import 'package:docu_fetch/presentation/widget/alert_message.dart';
import 'package:docu_fetch/util/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  HomeController(
      {required this.downloadPdfUseCase,
      required this.getPdfListUseCase,
      required this.insertLocalPdfUseCase,
      required this.deleteLocalPdfUseCase,
      required this.updateLocalPdfUseCase,
      required this.getLocalPdfListUseCase,
      required this.insertLocalRepositoryUseCase,
      required this.getLocalRepositoryListUseCase,
      required this.deleteLocalRepositoryUseCase});

  final DownloadPdfUseCase downloadPdfUseCase;
  final GetPdfListUseCase getPdfListUseCase;
  final InsertLocalPdfUseCase insertLocalPdfUseCase;
  final GetLocalPdfListUseCase getLocalPdfListUseCase;
  final DeleteLocalPdfUseCase deleteLocalPdfUseCase;
  final UpdateLocalPdfUseCase updateLocalPdfUseCase;
  final InsertLocalRepositoryUseCase insertLocalRepositoryUseCase;
  final GetLocalRepositoryListUseCase getLocalRepositoryListUseCase;
  final DeleteLocalRepositoryUseCase deleteLocalRepositoryUseCase;

  final MainController mainController = Get.find();

  RxList<Pdf> pdfList = RxList.empty();

  Rxn<DownloadData> downloadData = Rxn();

  final TextEditingController repoJsonUrlController = TextEditingController();
  final TextEditingController repoNameController = TextEditingController();
  final TextEditingController renamePdfController = TextEditingController();

  //https://vgachet.dev/wp-content/uploads/test/docu-fetch-test.json

  RxnString repoUrlFieldError = RxnString();

  RxList<Repository> repositoryList = RxList.empty();

  RxBool isValidateButtonDisabled = true.obs;

  RxBool isRenameButtonDisabled = true.obs;

  @override
  void onReady() async {
    super.onReady();
    await loadLocalRepositoryList();
    await loadLocalPdfList();

    repoJsonUrlController.addListener(validatorFields);
    repoNameController.addListener(validatorFields);
    renamePdfController.addListener(validatorRenameFields);
  }

  void validatorFields() {
    if (repositoryList.firstWhereOrNull(
            (element) => element.url == repoJsonUrlController.text) !=
        null) {
      repoUrlFieldError.value = 'url_already_saved'.tr;
      isValidateButtonDisabled.value = true;
      return;
    } else {
      repoUrlFieldError.value = null;

      if (GetUtils.isURL(repoJsonUrlController.text) &&
          repoNameController.text.isNotEmpty) {
        isValidateButtonDisabled.value = false;
      } else {
        isValidateButtonDisabled.value = true;
      }
    }
  }

  void validatorRenameFields() {
    if (renamePdfController.text.length > 3) {
      isRenameButtonDisabled.value = false;
    } else {
      isRenameButtonDisabled.value = true;
    }
  }

  @override
  void onClose() {
    repoJsonUrlController.dispose();
    repoNameController.dispose();
    renamePdfController.dispose();
    super.onClose();
  }

  Future<void> downloadPdf({required String repositoryUrl}) async {
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
          await Future.delayed(const Duration(seconds: 2));
          continue;
        }

        final downloadPdfResource = await downloadPdfUseCase(
            pdf.copyWith(path: '$localPath/${pdf.title}-${pdf.version}.pdf'));

        if (downloadPdfResource is Success) {
          final downloadedPdf = downloadPdfResource.data!;
          final insertLocalPdfResource =
              await insertLocalPdfUseCase(downloadedPdf);

          if (insertLocalPdfResource is Success) {
            await loadLocalPdfList();
          } else {
            AlertMessage.show(
                message:
                    'error_saving_pdf'.trParams({'pdfTitle': pdf.getTitle()}));
          }
        } else {
          AlertMessage.show(
              message: 'error_downloading_pdf'
                  .trParams({'pdfTitle': pdf.getTitle()}));
        }

        downloadData.value?.fileName = '';
        downloadData.refresh();
      }
    } else {
      AlertMessage.show(message: 'error_downloading_files'.tr);
    }

    downloadData.value = null;
    downloadData.refresh();

    Navigator.pop(Get.overlayContext!);

    repoJsonUrlController.clear();
    repoNameController.clear();
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

  Future<void> loadLocalPdfList() async {
    pdfList.clear();
    final localPdfListResource = await getLocalPdfListUseCase();

    if (localPdfListResource is Success) {
      pdfList.addAll(localPdfListResource.data!);
    } else {
      AlertMessage.show(message: 'error_retrieving_pdf_list'.tr);
    }
  }

  Future<void> deleteLocalPdf(Pdf pdf) async {
    final deleteLocalPdfResource = await deleteLocalPdfUseCase(pdf);

    if (deleteLocalPdfResource is Success) {
      pdfList.remove(pdf);
      final localPath =
          '${(await getApplicationDocumentsDirectory()).path}/pdfs';
      try {
        File('$localPath/${pdf.title}-${pdf.version}.pdf').deleteSync();
      } catch (_) {
        AlertMessage.show(
            message:
                'error_deleting_pdf'.trParams({'pdfTitle': pdf.getTitle()}));
      }
    } else {
      AlertMessage.show(
          message: 'error_deleting_pdf'.trParams({'pdfTitle': pdf.getTitle()}));
    }
  }

  void pickPdfFromDevice() {}

  Future<bool> insertLocalRepository(
      {required String repositoryName, required String repositoryUrl}) async {
    if (repoJsonUrlController.text.split('.').last != 'json') {
      AlertMessage.show(message: 'no_json_url'.tr);
      return false;
    }

    final insertLocalRepositoryResource = await insertLocalRepositoryUseCase(
        Repository(url: repositoryUrl, name: repositoryName));

    if (insertLocalRepositoryResource is Success) {
      await loadLocalRepositoryList();
      return true;
    }

    AlertMessage.show(message: 'error_saving_repository'.tr);
    return false;
  }

  Future<bool> insertRepository() async => await insertLocalRepository(
      repositoryName: repoNameController.text,
      repositoryUrl: repoJsonUrlController.text);

  Future<void> loadLocalRepositoryList() async {
    repositoryList.clear();
    final localRepositoryListResource = await getLocalRepositoryListUseCase();

    if (localRepositoryListResource is Success) {
      repositoryList.addAll(localRepositoryListResource.data!);
    } else {
      AlertMessage.show(message: 'error_retrieving_repository'.tr);
    }
  }

  Future<void> deleteLocalRepository(Repository repository) async {
    final deleteLocalRepositoryResource =
        await deleteLocalRepositoryUseCase(repository);

    if (deleteLocalRepositoryResource is Success) {
      repositoryList.remove(repository);
    } else {
      AlertMessage.show(message: 'delete_repo_error'.tr);
    }
  }

  Future<void> renamePdf(Pdf pdf) async {
    final updateLocalPDfResource = await updateLocalPdfUseCase(pdf);

    if (updateLocalPDfResource is Success) {
      await loadLocalPdfList();
    } else {
      AlertMessage.show(
          message: 'error_renaming_pdf'.trParams({'pdfTitle': pdf.getTitle()}));
    }

    renamePdfController.clear();
  }
}
