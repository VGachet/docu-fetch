import 'package:docu_fetch/domain/repository/main_repository.dart';
import 'package:docu_fetch/domain/usecase/usecase.dart';
import 'package:docu_fetch/util/resource.dart';

class SetNullPdfFolderIdUseCase implements UseCase<Resource<void>, int> {
  final MainRepository mainRepository;

  const SetNullPdfFolderIdUseCase({required this.mainRepository});

  @override
  Future<Resource<void>> call(int id) async =>
      mainRepository.setNullPdfFolderId(id);
}
