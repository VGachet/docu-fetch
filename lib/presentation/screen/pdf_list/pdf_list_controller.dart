import 'package:docu_fetch/domain/model/folder.dart';
import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/domain/usecase/get_local_folder_list_use_case.dart';
import 'package:docu_fetch/domain/usecase/get_local_pdf_list_use_case.dart';
import 'package:docu_fetch/presentation/widget/alert_message.dart';
import 'package:docu_fetch/util/resource.dart';
import 'package:get/get.dart';

class PdfListController extends GetxController {
  PdfListController({
    required this.getLocalPdfListUseCase,
    required this.getLocalFolderListUseCase,
  });

  final RxList<Pdf> pdfList = <Pdf>[].obs;
  final RxList<Folder> folderList = <Folder>[].obs;
  final RxList<Pdf> cutPdfList = <Pdf>[].obs;
  final RxList<int?> parentFolderIdList = <int?>[].obs;

  GetLocalPdfListUseCase getLocalPdfListUseCase;
  GetLocalFolderListUseCase getLocalFolderListUseCase;

  @override
  void onInit() {
    super.onInit();
    loadFolderContent(null);
  }

  Future<void> loadFolderContent(int? parentFolderId) async {
    // Load the content of the specified folder
    final folderListResource = await getLocalFolderListUseCase(parentFolderId);
    final pdfListResource = await getLocalPdfListUseCase(parentFolderId);

    if (folderListResource is Success && pdfListResource is Success) {
      folderList.value = folderListResource.data!;
      pdfList.value = pdfListResource.data!;

      if (!parentFolderIdList.contains(parentFolderId)) {
        parentFolderIdList.add(parentFolderId);
      } else {
        parentFolderIdList.remove(parentFolderId);
      }
    } else {
      AlertMessage.show(message: 'error_retrieving_pdf_list'.tr);
    }
  }

  void createFolder(String folderName) {
    // Create a new folder in the current path
  }

  void cutPdfToFolder(Pdf pdf) {
    cutPdfList.add(pdf);
  }

  void pastePdfToFolder(Folder folder) {
    if (cutPdfList.isNotEmpty) {
      // Move the cutPdf to the specified folder
      cutPdfList.clear();
    }
  }
}
