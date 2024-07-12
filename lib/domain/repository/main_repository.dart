import 'package:clean_architecture_getx/domain/model/pdf.dart';
import 'package:clean_architecture_getx/util/resource.dart';

abstract class MainRepository {
  Future<Resource<Pdf>> downloadPdf(
      {required String url, required String path});
}
