import 'dart:io';

import 'package:docu_fetch/domain/model/folder.dart';
import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/domain/model/repository.dart';
import 'package:docu_fetch/domain/usecase/delete_local_folder_use_case.dart';
import 'package:docu_fetch/domain/usecase/delete_local_pdf_use_case.dart';
import 'package:docu_fetch/domain/usecase/delete_local_repository_use_case.dart';
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
import 'package:docu_fetch/presentation/screen/pdf_list/download_pdf_helper.dart';
import 'package:docu_fetch/presentation/widget/alert_message.dart';
import 'package:docu_fetch/util/resource.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class PdfListController extends GetxController {
  PdfListController({
    required this.downloadPdfUseCase,
    required this.getLocalPdfListUseCase,
    required this.getLocalFolderListUseCase,
    required this.getLocalRepositoryListUseCase,
    required this.deleteLocalPdfUseCase,
    required this.insertLocalPdfUseCase,
    required this.insertLocalRepositoryUseCase,
    required this.getPdfListUseCase,
    required this.updateLocalPdfUseCase,
    required this.deleteLocalRepositoryUseCase,
    required this.insertLocalFolderUseCase,
    required this.updateLocalFolderUseCase,
    required this.deleteLocalFolderUseCase,
  });

  final RxList<Pdf> pdfList = <Pdf>[].obs;
  final RxList<Folder> folderList = <Folder>[].obs;
  final RxList<dynamic> selectedList = [].obs;
  final RxList<Folder?> parentFolderList = <Folder?>[].obs;
  RxList<Repository> repositoryList = RxList.empty();

  final DownloadPdfUseCase downloadPdfUseCase;
  final GetLocalPdfListUseCase getLocalPdfListUseCase;
  final GetLocalFolderListUseCase getLocalFolderListUseCase;
  final GetLocalRepositoryListUseCase getLocalRepositoryListUseCase;
  final DeleteLocalPdfUseCase deleteLocalPdfUseCase;
  final InsertLocalPdfUseCase insertLocalPdfUseCase;
  final InsertLocalRepositoryUseCase insertLocalRepositoryUseCase;
  final GetPdfListUseCase getPdfListUseCase;
  final UpdateLocalPdfUseCase updateLocalPdfUseCase;
  final DeleteLocalRepositoryUseCase deleteLocalRepositoryUseCase;
  final InsertLocalFolderUseCase insertLocalFolderUseCase;
  final UpdateLocalLocalFolderUseCase updateLocalFolderUseCase;
  final DeleteLocalFolderUseCase deleteLocalFolderUseCase;

  final TextEditingController repoJsonUrlController = TextEditingController();
  final TextEditingController repoNameController = TextEditingController();
  final TextEditingController renamePdfController = TextEditingController();
  final TextEditingController renameFolderController = TextEditingController();

  RxnString repoUrlFieldError = RxnString();

  RxBool isValidateButtonDisabled = true.obs;

  RxBool isPdfRenameButtonDisabled = true.obs;

  RxBool isFolderRenameButtonDisabled = true.obs;

  RxBool isSelectionMode = false.obs;

  final MainController mainController = Get.find();

  @override
  void onReady() async {
    super.onReady();
    await loadLocalRepositoryList();
    await loadFolderContent(null);

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
    if (renamePdfController.text.length > 1) {
      isPdfRenameButtonDisabled.value = false;
    } else {
      isPdfRenameButtonDisabled.value = true;
    }
  }

  void validatorFolderRenameFields() {
    if (renameFolderController.text.length > 1) {
      isFolderRenameButtonDisabled.value = false;
    } else {
      isFolderRenameButtonDisabled.value = true;
    }
  }

  Future<void> loadFolderContent(Folder? parentFolder) async {
    mainController.isLoading.value = true;

    folderList.clear();
    pdfList.clear();

    // Load the content of the specified folder
    final folderListResource =
        await getLocalFolderListUseCase(parentFolder?.id!);
    final pdfListResource = await getLocalPdfListUseCase(parentFolder?.id);

    if (folderListResource is Success && pdfListResource is Success) {
      folderList.value = folderListResource.data!;
      pdfList.value = pdfListResource.data!;

      if (parentFolder != null && !parentFolderList.contains(parentFolder)) {
        parentFolderList.add(parentFolder);
      }
    } else {
      AlertMessage.show(message: 'error_retrieving_pdf_list'.tr);
    }

    mainController.isLoading.value = false;
  }

  void toggleSelectionMode() {
    isSelectionMode.value = !isSelectionMode.value;
    selectedList.clear();
  }

  // Method to toggle selection mode and select/deselect items
  void toggleSelection(dynamic item) {
    if (item is Folder) {
      if (selectedList.contains(item)) {
        selectedList.remove(item);
      } else {
        selectedList.add(item);
      }
    } else if (item is Pdf) {
      if (selectedList.contains(item)) {
        selectedList.remove(item);
      } else {
        selectedList.add(item);
      }
    }
  }

  // Method to delete selected items
  Future<void> deleteSelectedItems() async {
    for (dynamic item in selectedList) {
      if (item is Folder) {
        await deleteFolder(item);
      } else if (item is Pdf) {
        await deleteLocalPdf(item);
      }
    }
    toggleSelectionMode();
  }

  // Method to cut selected items
  void cutSelectedItems() {
    // Implement cut logic here
    toggleSelectionMode();
  }

  /* Folders */

  Future<void> createFolder({required String folderName}) async {
    renameFolderController.clear();

    final insertFolderResource = await insertLocalFolderUseCase(Folder(
        title: folderName,
        order: 0,
        parentFolder:
            parentFolderList.isNotEmpty ? parentFolderList.last!.id : null));

    if (insertFolderResource is Success) {
      await loadFolderContent(
          parentFolderList.isNotEmpty ? parentFolderList.last : null);
    } else {
      AlertMessage.show(message: 'error_creating_folder'.tr);
    }
  }

  Future<void> renameFolder(Folder folder) async {
    final updateFolderResource = await updateLocalFolderUseCase(
        folder.copyWith(title: renameFolderController.text));

    if (updateFolderResource is Success) {
      await loadFolderContent(
          parentFolderList.isNotEmpty ? parentFolderList.last : null);
    } else {
      AlertMessage.show(
          message:
              'error_renaming_folder'.trParams({'folderTitle': folder.title}));
    }

    renameFolderController.clear();
  }

  Future<void> deleteFolder(Folder folder) async {
    final List<Pdf> pdfsToDelete =
        pdfList.where((pdf) => pdf.folderId == folder.id).toList();

    for (Pdf pdf in pdfsToDelete) {
      final deletePdfResource = await deleteLocalPdfUseCase(pdf);

      if (deletePdfResource is Success) {
        pdfList.remove(pdf);
        final localPath =
            '${(await getApplicationDocumentsDirectory()).path}/pdfs';
        try {
          File('$localPath/${pdf.title}-${pdf.version}.pdf').deleteSync();
        } catch (_) {
          AlertMessage.show(
              message:
                  'error_deleting_pdf'.trParams({'pdfTitle': pdf.getTitle()}));
          return;
        }
      } else {
        AlertMessage.show(
            message:
                'error_deleting_pdf'.trParams({'pdfTitle': pdf.getTitle()}));
        return;
      }
    }

    final deleteFolderResource = await deleteLocalFolderUseCase(folder);

    if (deleteFolderResource is Success) {
      await loadFolderContent(
          parentFolderList.isNotEmpty ? parentFolderList.last : null);
    } else {
      AlertMessage.show(
          message:
              'error_deleting_folder'.trParams({'folderTitle': folder.title}));
    }
  }

  /* PDF */

  Future<void> insertLocalPdf(Pdf pdf) async {
    mainController.isLoading.value = true;

    final insertLocalPdfResource = await insertLocalPdfUseCase(pdf);

    if (insertLocalPdfResource is Success) {
      await loadFolderContent(
          parentFolderList.isNotEmpty ? parentFolderList.last : null);
    } else {
      AlertMessage.show(
          message: 'error_saving_pdf'.trParams({'pdfTitle': pdf.getTitle()}));
    }

    mainController.isLoading.value = false;
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

  Future<void> downloadPdf(
      {required String repositoryUrl, required String repositoryName}) async {
    await DownloadPdfHelper(
      downloadPdfUseCase: downloadPdfUseCase,
      getPdfListUseCase: getPdfListUseCase,
      insertLocalFolderUseCase: insertLocalFolderUseCase,
      insertLocalPdfUseCase: insertLocalPdfUseCase,
      pdfList: pdfList,
    ).downloadPdf(
      repositoryUrl: repositoryUrl,
      repositoryName: repositoryName,
      parentFolderId:
          parentFolderList.isNotEmpty ? parentFolderList.last!.id : null,
    );

    await loadFolderContent(
        parentFolderList.isNotEmpty ? parentFolderList.last : null);

    repoJsonUrlController.clear();
    repoNameController.clear();
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

      final String localPdfDirectoryPath =
          '${(await getApplicationDocumentsDirectory()).path}/pdfs';

      if (!Directory(localPdfDirectoryPath).existsSync()) {
        Directory(localPdfDirectoryPath).createSync();
      }

      final String localFilePath = '$localPdfDirectoryPath/$pdfTitle.pdf';

      try {
        //PDF file is copied to the app's document directory
        final localCreatedFile = await File(localFilePath).create();
        await localCreatedFile.writeAsBytes(await file.xFile.readAsBytes());

        await insertLocalPdf(Pdf(
            title: pdfTitle,
            path: localFilePath,
            folderId: parentFolderList.isNotEmpty
                ? parentFolderList.last!.id
                : null));
      } catch (_) {
        AlertMessage.show(
            message: 'error_saving_pdf'.trParams({'pdfTitle': pdfTitle}));
      }
    }
  }

  Future<void> renamePdf(Pdf pdf) async {
    final updateLocalPDfResource = await updateLocalPdfUseCase(pdf);

    if (updateLocalPDfResource is Success) {
      await loadFolderContent(
          parentFolderList.isNotEmpty ? parentFolderList.last : null);
    } else {
      AlertMessage.show(
          message: 'error_renaming_pdf'.trParams({'pdfTitle': pdf.getTitle()}));
    }

    renamePdfController.clear();
  }

  /* Repository */

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
    mainController.isLoading.value = true;

    repositoryList.clear();
    final localRepositoryListResource = await getLocalRepositoryListUseCase();

    if (localRepositoryListResource is Success) {
      repositoryList.addAll(localRepositoryListResource.data!);
    } else {
      AlertMessage.show(message: 'error_retrieving_repository'.tr);
    }

    mainController.isLoading.value = true;
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
}
