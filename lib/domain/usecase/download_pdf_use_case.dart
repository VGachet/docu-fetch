import 'package:clean_architecture_getx/domain/model/download_pdf_param.dart';
import 'package:clean_architecture_getx/domain/model/pdf.dart';
import 'package:clean_architecture_getx/domain/repository/main_repository.dart';
import 'package:clean_architecture_getx/domain/usecase/usecase.dart';
import 'package:clean_architecture_getx/util/resource.dart';

class DownloadPdfUseCase implements UseCase<Resource<Pdf>, DownloadPdfParam> {
  final MainRepository mainRepository;

  const DownloadPdfUseCase({required this.mainRepository});

  @override
  Future<Resource<Pdf>> call(DownloadPdfParam downloadPdfParam) async =>
      mainRepository.downloadPdf(
          url: downloadPdfParam.url, path: downloadPdfParam.path);
}
