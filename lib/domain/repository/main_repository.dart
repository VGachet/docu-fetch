import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/util/resource.dart';

abstract class MainRepository {
  Future<Resource<Pdf>> downloadPdf({required Pdf pdf});
  Future<Resource<List<Pdf>>> getPdfList({required String url});
  Future<Resource<List<Pdf>>> getLocalPdfList();
  Future<Resource<void>> insertLocalPdf(Pdf pdf);
  Future<Resource<void>> deleteLocalPdf(Pdf pdf);
}
