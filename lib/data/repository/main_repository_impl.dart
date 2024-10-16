import 'package:docu_fetch/data/datasource/local/database.dart';
import 'package:docu_fetch/data/datasource/remote/response/pdf_dto.dart';
import 'package:docu_fetch/data/networking/networking.dart';
import 'package:docu_fetch/domain/model/folder.dart';
import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/domain/model/repository.dart';
import 'package:docu_fetch/domain/repository/main_repository.dart';
import 'package:docu_fetch/util/error_manager.dart';
import 'package:docu_fetch/util/resource.dart';

class MainRepositoryImpl implements MainRepository {
  MainRepositoryImpl({required this.networking, required this.database});

  final Networking networking;

  final AppDatabase database;

  @override
  Future<Resource<Pdf>> downloadPdf({required Pdf pdf}) async {
    if (pdf.url == null) {
      return const Error(ErrorStatus.unexpected);
    }

    if (pdf.url!.split('.').last == 'pdf' && pdf.path != null) {
      try {
        await networking.download(url: pdf.url!, path: pdf.path!);
        return Success(pdf);
      } catch (_) {
        return const Error(ErrorStatus.unexpected);
      }
    } else {
      return const Error(ErrorStatus.unexpected);
    }
  }

  @override
  Future<Resource<List<Pdf>>> getPdfList({required String url}) async {
    if (url.split('.').last == 'json') {
      try {
        final response = await networking.get(url: url);
        final json = response.data as Map<String, dynamic>;
        final pdfList =
            (json['pdfs'] as List).map((e) => PdfDto.fromJson(e)).toList();
        return Success(pdfList.map((e) => e.toPdf()).toList());
      } catch (_) {
        return const Error(ErrorStatus.unexpected);
      }
    } else {
      return const Error(ErrorStatus.unexpected);
    }
  }

  @override
  Future<Resource<List<Pdf>>> getLocalPdfList(int? folderId) async {
    try {
      final pdfList = folderId != null
          ? await database.pdfDao.findPdfListByFolderId(folderId)
          : await database.pdfDao.findRootPdfList();
      return Success(pdfList);
    } catch (_) {
      return const Error(ErrorStatus.unexpected);
    }
  }

  @override
  Future<Resource<int>> insertLocalPdf(Pdf pdf) async {
    try {
      final int pdfId = await database.pdfDao.insertPdf(pdf);
      return Success(pdfId);
    } catch (_) {
      return const Error(ErrorStatus.unexpected);
    }
  }

  @override
  Future<Resource<int>> deleteLocalPdf(Pdf pdf) async {
    try {
      final int pdfId = await database.pdfDao.deletePdf(pdf);
      return Success(pdfId);
    } catch (_) {
      return const Error(ErrorStatus.unexpected);
    }
  }

  @override
  Future<Resource<void>> updateLastPageOpened(
      {required int lastPage, required int id}) async {
    try {
      await database.pdfDao.updateLastPageOpened(lastPage, id);
      return const Success(null);
    } catch (_) {
      return const Error(ErrorStatus.unexpected);
    }
  }

  @override
  Future<Resource<int>> insertLocalRepository(Repository repository) async {
    try {
      return Success(await database.repositoryDao.insertRepository(repository));
    } catch (_) {
      return const Error(ErrorStatus.unexpected);
    }
  }

  @override
  Future<Resource<List<Repository>>> getLocalRepositoryList() async {
    try {
      final repositoryList = await database.repositoryDao.findAll();
      return Success(repositoryList);
    } catch (_) {
      return const Error(ErrorStatus.unexpected);
    }
  }

  @override
  Future<Resource<int>> deleteLocalRepository(Repository repository) async {
    try {
      final int repositoryId =
          await database.repositoryDao.deleteRepository(repository);
      return Success(repositoryId);
    } catch (_) {
      return const Error(ErrorStatus.unexpected);
    }
  }

  @override
  Future<Resource<void>> updateLocalPdf(Pdf pdf) async {
    try {
      await database.pdfDao.updatePdf(pdf);
      return const Success(null);
    } catch (_) {
      return const Error(ErrorStatus.unexpected);
    }
  }

  @override
  Future<Resource<int>> insertLocalFolder(Folder folder) async {
    final getFolderListResource = await getLocalFolderList(folder.parentFolder);

    if (getFolderListResource is Error) {
      return const Error(ErrorStatus.unexpected);
    }

    final List<Folder> folderList = getFolderListResource.data!;
    final List<Folder> folderListToUpdate = [];

    for (Folder folder in folderList) {
      folderListToUpdate.add(folder.copyWith(order: folder.order++));
    }

    try {
      await updateLocalFolderList(folderListToUpdate);
      return Success(await database.folderDao.insertFolder(folder));
    } catch (_) {
      return const Error(ErrorStatus.unexpected);
    }
  }

  @override
  Future<Resource<List<Folder>>> getLocalFolderList(int? parentFolderId) async {
    try {
      final folderList = parentFolderId != null
          ? await database.folderDao.findFolderListByParentId(parentFolderId)
          : await database.folderDao.findRootFolderList();
      return Success(folderList);
    } catch (_) {
      return const Error(ErrorStatus.unexpected);
    }
  }

  @override
  Future<Resource<void>> updateLocalFolderList(List<Folder> folderList) async {
    try {
      return Success(await database.folderDao.updateFolderList(folderList));
    } catch (_) {
      return const Error(ErrorStatus.unexpected);
    }
  }

  @override
  Future<Resource<void>> updateLocalFolder(Folder folder) async {
    try {
      return Success(await database.folderDao.updateFolder(folder));
    } catch (_) {
      return const Error(ErrorStatus.unexpected);
    }
  }

  @override
  Future<Resource<void>> deleteLocalFolder(Folder folder) async {
    try {
      await database.folderDao.deleteFolder(folder);
      return const Success(null);
    } catch (_) {
      return const Error(ErrorStatus.unexpected);
    }
  }
}
