import 'package:clean_architecture_getx/domain/model/pdf.dart';
import 'package:clean_architecture_getx/util/resource.dart';

abstract class MainRepository {
  Future<Resource<Pdf>> downloadPdf({required Pdf pdf});
  Future<Resource<List<Pdf>>> getPdfList({required String url});
}
