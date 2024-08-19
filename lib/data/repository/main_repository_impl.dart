import 'package:docu_fetch/data/datasource/local/database.dart';
import 'package:docu_fetch/data/datasource/remote/response/pdf_dto.dart';
import 'package:docu_fetch/data/networking/networking.dart';
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
  Future<Resource<List<Pdf>>> getLocalPdfList() async {
    try {
      final pdfList = await database.pdfDao.findAll();
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
      final repositoryId =
          await database.repositoryDao.insertRepository(repository);
      return Success(repositoryId);
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
}
