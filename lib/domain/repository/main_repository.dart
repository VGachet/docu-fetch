import 'package:docu_fetch/domain/model/folder.dart';
import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/domain/model/repository.dart';
import 'package:docu_fetch/util/resource.dart';

abstract class MainRepository {
  Future<Resource<Pdf>> downloadPdf({required Pdf pdf});
  Future<Resource<List<Pdf>>> getPdfList({required String url});
  Future<Resource<List<Pdf>>> getLocalPdfList();
  Future<Resource<int>> insertLocalPdf(Pdf pdf);
  Future<Resource<int>> deleteLocalPdf(Pdf pdf);
  Future<Resource<void>> updateLocalPdf(Pdf pdf);
  Future<Resource<void>> updateLastPageOpened(
      {required int lastPage, required int id});
  Future<Resource<List<Repository>>> getLocalRepositoryList();
  Future<Resource<int>> insertLocalRepository(Repository repository);
  Future<Resource<int>> deleteLocalRepository(Repository repository);
  Future<Resource<int>> insertLocalFolder(Folder folder);
  Future<Resource<List<Folder>>> getLocalFolderList();
  Future<Resource<void>> updateLocalFolderList(List<Folder> folderList);
  Future<Resource<void>> updateLocalFolder(Folder folder);
  Future<Resource<void>> deleteLocalFolder(Folder folder);
}
