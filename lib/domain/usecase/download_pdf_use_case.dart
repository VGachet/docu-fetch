import 'package:clean_architecture_getx/domain/model/pdf.dart';
import 'package:clean_architecture_getx/domain/repository/main_repository.dart';
import 'package:clean_architecture_getx/domain/usecase/usecase.dart';
import 'package:clean_architecture_getx/util/resource.dart';

class DownloadPdfUseCase implements UseCase<Resource<Pdf>, Pdf> {
  final MainRepository mainRepository;

  const DownloadPdfUseCase({required this.mainRepository});

  @override
  Future<Resource<Pdf>> call(Pdf pdf) async =>
      mainRepository.downloadPdf(pdf: pdf);
}
