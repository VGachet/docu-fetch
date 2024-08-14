import 'dart:async';

import 'package:docu_fetch/data/networking/networking.dart';
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
import 'package:docu_fetch/presentation/main_controller.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_theme.dart';
import 'package:docu_fetch/util/resource.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  HomeController(
      {required this.downloadPdfUseCase,
      required this.getPdfListUseCase,
      required this.insertLocalPdfUseCase,
      required this.deleteLocalPdfUseCase,
      required this.getLocalPdfListUseCase,
      required this.insertLocalRepositoryUseCase,
      required this.getLocalRepositoryListUseCase,
      required this.deleteLocalRepositoryUseCase});

  final DownloadPdfUseCase downloadPdfUseCase;
  final GetPdfListUseCase getPdfListUseCase;
  final InsertLocalPdfUseCase insertLocalPdfUseCase;
  final GetLocalPdfListUseCase getLocalPdfListUseCase;
  final DeleteLocalPdfUseCase deleteLocalPdfUseCase;
  final InsertLocalRepositoryUseCase insertLocalRepositoryUseCase;
  final GetLocalRepositoryListUseCase getLocalRepositoryListUseCase;
  final DeleteLocalRepositoryUseCase deleteLocalRepositoryUseCase;

  final MainController mainController = Get.find();

  RxList<Pdf> pdfList = RxList.empty();

  Rx<double> downloadProgress = 0.0.obs;
  Rx<double> maxProgressValue = 0.0.obs;

  final TextEditingController repoJsonUrlController = TextEditingController();
  final TextEditingController repoNameController = TextEditingController();

  //https://vgachet.dev/wp-content/uploads/test/docu-fetch-test.json

  RxnString repoUrlFieldError = RxnString();

  RxList<Repository> repositoryList = RxList.empty();

  RxBool isValidateButtonDisabled = true.obs;

  @override
  void onReady() async {
    super.onReady();
    await loadLocalRepositoryList();
    await loadLocalPdfList();

    repoJsonUrlController.addListener(validatorFields);
    repoNameController.addListener(validatorFields);
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

  @override
  void onClose() {
    repoJsonUrlController.dispose();
    repoNameController.dispose();
    super.onClose();
  }

  Future<void> downloadPdf({required String repositoryUrl}) async {
    final localPath = '${(await getApplicationDocumentsDirectory()).path}/pdfs';

    Get.find<Networking>().setOnDownloadProgressReceived((received, total) {
      downloadProgress.value = received / total;
    });

    displayDownloadProgressPopup();

    final pdfListResource = await getPdfListUseCase(repositoryUrl);

    if (pdfListResource is Success) {
      for (final pdf in pdfListResource.data!) {
        final downloadPdfResource = await downloadPdfUseCase(
            pdf.copyWith(path: '$localPath/${pdf.title}'));

        if (downloadPdfResource is Success) {
          final downloadedPdf = downloadPdfResource.data!;
          final insertLocalPdfResource =
              await insertLocalPdfUseCase(downloadedPdf);

          if (insertLocalPdfResource is Success) {
            pdfList.add(downloadedPdf);
            pdfList.add(downloadedPdf);
          } else {
            Navigator.pop(Get.overlayContext!);
            print('insert PDF Error');
          }
        } else {
          Navigator.pop(Get.overlayContext!);
          print('download PDF Error');
        }
      }
    } else {
      Navigator.pop(Get.overlayContext!);
      Fluttertoast.showToast(
          msg: 'no_json_found_repo'.tr,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

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
        content: Column(mainAxisSize: MainAxisSize.min, children: [
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
                              value: downloadProgress.value,
                            )))),
                Center(
                    child: Obx(() => Text(
                          '${(downloadProgress.value * 100).round()}%',
                          style: CustomTheme.body,
                          textAlign: TextAlign.center,
                        ))),
              ])))
        ]),
      ),
    );
  }

  Future<void> loadLocalPdfList() async {
    pdfList.clear();
    final localPdfListResource = await getLocalPdfListUseCase();

    if (localPdfListResource is Success) {
      pdfList.addAll(localPdfListResource.data!);
    } else {
      print('get Local PDF List Error');
    }
  }

  Future<void> deleteLocalPdf(Pdf pdf) async {
    final deleteLocalPdfResource = await deleteLocalPdfUseCase(pdf);

    if (deleteLocalPdfResource is Success) {
      pdfList.remove(pdf);
    } else {
      print('delete Local PDF Error');
    }
  }

  void pickPdfFromDevice() {}

  Future<bool> insertLocalRepository(
      {required String repositoryName, required String repositoryUrl}) async {
    if (repoJsonUrlController.text.split('.').last != 'json') {
      Fluttertoast.showToast(
          msg: 'no_json_url'.tr,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }

    final insertLocalRepositoryResource = await insertLocalRepositoryUseCase(
        Repository(url: repositoryUrl, name: repositoryName));

    if (insertLocalRepositoryResource is Success) {
      await loadLocalRepositoryList();
      return true;
    }

    print('insert Local Repository Error');
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
      print('get Local Repository List Error');
    }
  }

  Future<void> deleteLocalRepository(Repository repository) async {
    final deleteLocalRepositoryResource =
        await deleteLocalRepositoryUseCase(repository);

    if (deleteLocalRepositoryResource is Success) {
      repositoryList.remove(repository);
    } else {
      Fluttertoast.showToast(
          msg: 'delete_repo_error'.tr,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
