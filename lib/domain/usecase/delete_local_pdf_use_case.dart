import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/domain/repository/main_repository.dart';
import 'package:docu_fetch/domain/usecase/usecase.dart';
import 'package:docu_fetch/util/resource.dart';

class DeleteLocalPdfUseCase implements UseCase<Resource<void>, Pdf> {
  final MainRepository mainRepository;

  const DeleteLocalPdfUseCase({required this.mainRepository});

  @override
  Future<Resource<void>> call(Pdf pdf) async =>
      mainRepository.deleteLocalPdf(pdf);
}
