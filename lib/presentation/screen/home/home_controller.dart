import 'dart:async';
import 'dart:io';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:docu_fetch/data/networking/networking.dart';
import 'package:docu_fetch/domain/model/download_data.dart';
import 'package:docu_fetch/domain/model/folder.dart';
import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/domain/model/repository.dart';
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
import 'package:docu_fetch/domain/usecase/update_local_folder_use_case.dart';
import 'package:docu_fetch/domain/usecase/update_pdf_use_case.dart';
import 'package:docu_fetch/presentation/main_controller.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_margins.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_theme.dart';
import 'package:docu_fetch/presentation/widget/alert_message.dart';
import 'package:docu_fetch/util/resource.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  HomeController({
    required this.downloadPdfUseCase,
    required this.getPdfListUseCase,
    required this.insertLocalPdfUseCase,
    required this.deleteLocalPdfUseCase,
    required this.updateLocalPdfUseCase,
    required this.getLocalPdfListUseCase,
    required this.insertLocalRepositoryUseCase,
    required this.getLocalRepositoryListUseCase,
    required this.deleteLocalRepositoryUseCase,
    required this.insertLocalFolderUseCase,
    required this.getLocalFolderListUseCase,
    required this.updateLocalFolderUseCase,
  });

  final DownloadPdfUseCase downloadPdfUseCase;
  final GetPdfListUseCase getPdfListUseCase;
  final InsertLocalPdfUseCase insertLocalPdfUseCase;
  final GetLocalPdfListUseCase getLocalPdfListUseCase;
  final DeleteLocalPdfUseCase deleteLocalPdfUseCase;
  final UpdateLocalPdfUseCase updateLocalPdfUseCase;
  final InsertLocalRepositoryUseCase insertLocalRepositoryUseCase;
  final GetLocalRepositoryListUseCase getLocalRepositoryListUseCase;
  final DeleteLocalRepositoryUseCase deleteLocalRepositoryUseCase;
  final InsertLocalFolderUseCase insertLocalFolderUseCase;
  final GetLocalFolderListUseCase getLocalFolderListUseCase;
  final UpdateLocalLocalFolderUseCase updateLocalFolderUseCase;

  final MainController mainController = Get.find();

  RxList<Pdf> pdfList = RxList.empty();

  RxList<TreeNode> treeNodeList = RxList.empty();

  RxList<Pdf> pdfAllowingSelection = RxList.empty();

  RxList<Pdf> selectedPdfs = RxList.empty();

  RxBool isCutMode = false.obs;

  Rxn<DownloadData> downloadData = Rxn();

  final TextEditingController repoJsonUrlController = TextEditingController();
  final TextEditingController repoNameController = TextEditingController();
  final TextEditingController renamePdfController = TextEditingController();
  final TextEditingController renameFolderController = TextEditingController();

  //https://vgachet.dev/wp-content/uploads/test/docu-fetch-test.json

  RxnString repoUrlFieldError = RxnString();

  RxList<Repository> repositoryList = RxList.empty();

  RxBool isValidateButtonDisabled = true.obs;

  RxBool isPdfRenameButtonDisabled = true.obs;

  RxBool isFolderRenameButtonDisabled = true.obs;

  TreeViewController? treeViewController;

  @override
  void onReady() async {
    super.onReady();
    await loadLocalRepositoryList();
    await loadLocalPdfList();

    repoJsonUrlController.addListener(validatorFields);
    repoNameController.addListener(validatorFields);
    renamePdfController.addListener(validatorPdfRenameFields);
    renameFolderController.addListener(validatorFolderRenameFields);
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

  void validatorPdfRenameFields() {
    if (renamePdfController.text.length > 3) {
      isPdfRenameButtonDisabled.value = false;
    } else {
      isPdfRenameButtonDisabled.value = true;
    }
  }

  void validatorFolderRenameFields() {
    if (renameFolderController.text.length > 3) {
      isFolderRenameButtonDisabled.value = false;
    } else {
      isFolderRenameButtonDisabled.value = true;
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
      final createFolderResource = await insertLocalFolderUseCase(
          Folder(title: repoNameController.text, order: 0));

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
            await insertLocalPdf(downloadPdfResource.data!.copyWith(
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

    repoJsonUrlController.clear();
    repoNameController.clear();
  }

  Future<void> insertLocalPdf(Pdf pdf) async {
    final insertLocalPdfResource = await insertLocalPdfUseCase(pdf);

    if (insertLocalPdfResource is Success) {
      await loadLocalPdfList();
    } else {
      AlertMessage.show(
          message: 'error_saving_pdf'.trParams({'pdfTitle': pdf.getTitle()}));
    }
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

    treeNodeList.value = await getOrderedFolderAndPdfList();
    treeNodeList.refresh();
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

  Future<void> pickPdfFromDevice() async {
    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    for (final file in result!.files) {
      if (file.path == null) {
        continue;
      }

      final String pdfTitle =
          file.name.substring(0, file.name.lastIndexOf('.'));

      const double pdfVersion = 1.0;

      final String localPdfDirectoryPath =
          '${(await getApplicationDocumentsDirectory()).path}/pdfs';

      if (!Directory(localPdfDirectoryPath).existsSync()) {
        Directory(localPdfDirectoryPath).createSync();
      }

      final String localFilePath =
          '$localPdfDirectoryPath/$pdfTitle-$pdfVersion.pdf';

      try {
        //PDF file is copied to the app's document directory
        final localCreatedFile = await File(localFilePath).create();
        await localCreatedFile.writeAsBytes(await file.xFile.readAsBytes());

        await insertLocalPdf(
            Pdf(title: pdfTitle, path: localFilePath, version: pdfVersion));
      } catch (_) {
        AlertMessage.show(
            message: 'error_saving_pdf'.trParams({'pdfTitle': pdfTitle}));
      }
    }
  }

  Future<void> createFolder({required String folderName}) async {
    renameFolderController.clear();

    final insertFolderResource =
        await insertLocalFolderUseCase(Folder(title: folderName, order: 0));

    if (insertFolderResource is Success) {
      treeNodeList.value = await getOrderedFolderAndPdfList();
      treeNodeList.refresh();
    } else {
      AlertMessage.show(message: 'error_creating_folder'.tr);
    }
  }

  Future<List<TreeNode>> getOrderedFolderAndPdfList() async {
    final List<TreeNode> treeNodes = [];

    // Retrieve and sort root PDFs
    final List<Pdf> rootPdfList = pdfList
        .where((pdf) => pdf.folderId == null)
        .toList()
      ..sort((pdf1, pdf2) => pdf1.order.compareTo(pdf2.order));

    // Add root PDFs to tree nodes
    treeNodes.add(
        TreeNode.root()..addAll(rootPdfList.map((pdf) => TreeNode(data: pdf))));

    // Retrieve and sort folders
    final getFolderListResource = await getLocalFolderListUseCase();
    if (getFolderListResource is Success) {
      final List<Folder> folderList = getFolderListResource.data!
        ..sort((folder1, folder2) => folder1.order.compareTo(folder2.order));

      // Build tree structure for each folder
      for (Folder folder in folderList) {
        final List<Pdf> currentFolderPdfList = pdfList
            .where((pdf) => pdf.folderId == folder.id)
            .toList()
          ..sort((pdf1, pdf2) => pdf1.order.compareTo(pdf2.order));

        final TreeNode folderNode = TreeNode.root()
          ..add(TreeNode(data: folder)
            ..addAll(currentFolderPdfList.map((pdf) => TreeNode(data: pdf))));

        treeNodes.add(folderNode);
      }
    }

    return treeNodes;
  }

  // Method to toggle selection mode and select PDFs in the same folder
  void toggleSelectionMode(Pdf pdf) {
    if (pdfAllowingSelection.isNotEmpty) {
      pdfAllowingSelection.clear();
      if (selectedPdfs.isNotEmpty) {
        selectedPdfs.clear();
      }
    } else {
      isCutMode.value = false;
      selectedPdfs.add(pdf);
      pdfAllowingSelection.add(pdf);
      pdfAllowingSelection.addAll(pdfList
          .where((element) => element.folderId == pdf.folderId)
          .toList());
    }
  }

  void selectPdf(TreeNode node) {
    if (selectedPdfs.contains(node.data)) {
      selectedPdfs.remove(node.data);
    } else {
      selectedPdfs.add(node.data as Pdf);
    }
  }

  void cutSelectedPdfs() {
    pdfAllowingSelection.clear();
    isCutMode.value = true;
  }

  void moveSelectedPdfToFolder(Folder folder) async {
    for (Pdf pdf in selectedPdfs) {
      final updatedPdf = pdf.copyWith(folderId: folder.id);
      final updateLocalPdfResource = await updateLocalPdfUseCase(updatedPdf);

      if (updateLocalPdfResource is Success) {
        await loadLocalPdfList();
      } else {
        AlertMessage.show(
            message: 'error_moving_pdf'.trParams({'pdfTitle': pdf.getTitle()}));
      }
    }

    selectedPdfs.clear();
    pdfAllowingSelection.clear();
    isCutMode.value = false;
  }

  Future<void> renameFolder(Folder folder) async {
    final updateFolderResource = await updateLocalFolderUseCase(
        folder.copyWith(title: renameFolderController.text));

    if (updateFolderResource is Success) {
      await loadLocalPdfList();
    } else {
      AlertMessage.show(
          message:
              'error_renaming_folder'.trParams({'folderTitle': folder.title}));
    }

    renameFolderController.clear();
  }
}
