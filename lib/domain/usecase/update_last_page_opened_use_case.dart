import 'package:docu_fetch/domain/model/pdf_last_page_open_param.dart';
import 'package:docu_fetch/domain/repository/main_repository.dart';
import 'package:docu_fetch/domain/usecase/usecase.dart';
import 'package:docu_fetch/util/resource.dart';

class UpdateLastPageOpenedUseCase
    implements UseCase<Resource<void>, PdfLastPageOpenParam> {
  UpdateLastPageOpenedUseCase({required this.mainRepository});

  final MainRepository mainRepository;

  @override
  Future<Resource<void>> call(PdfLastPageOpenParam params) async {
    return mainRepository.updateLastPageOpened(
        lastPage: params.lastPage, id: params.id);
  }
}
