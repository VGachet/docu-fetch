import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/domain/repository/main_repository.dart';
import 'package:docu_fetch/domain/usecase/usecase.dart';
import 'package:docu_fetch/util/resource.dart';

class DownloadPdfUseCase implements UseCase<Resource<Pdf>, Pdf> {
  final MainRepository mainRepository;

  const DownloadPdfUseCase({required this.mainRepository});

  @override
  Future<Resource<Pdf>> call(Pdf pdf) async =>
      mainRepository.downloadPdf(pdf: pdf);
}
