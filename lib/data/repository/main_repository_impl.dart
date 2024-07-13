import 'package:clean_architecture_getx/data/datasource/remote/response/pdf_dto.dart';
import 'package:clean_architecture_getx/data/networking/networking.dart';
import 'package:clean_architecture_getx/domain/model/pdf.dart';
import 'package:clean_architecture_getx/domain/repository/main_repository.dart';
import 'package:clean_architecture_getx/util/error_manager.dart';
import 'package:clean_architecture_getx/util/resource.dart';

class MainRepositoryImpl implements MainRepository {
  MainRepositoryImpl({required this.networking});

  final Networking networking;

  @override
  Future<Resource<Pdf>> downloadPdf({required Pdf pdf}) async {
    if (pdf.url.split('.').last == 'pdf' && pdf.path != null) {
      try {
        await networking.download(url: pdf.url, path: pdf.path!);
        return Success(pdf);
      } catch (e) {
        print(e);
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
}
