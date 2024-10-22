import 'package:docu_fetch/domain/repository/main_repository.dart';
import 'package:docu_fetch/domain/usecase/usecase.dart';
import 'package:docu_fetch/util/resource.dart';

class SetNullParentFolderUseCase implements UseCase<Resource<void>, int> {
  final MainRepository mainRepository;

  const SetNullParentFolderUseCase({required this.mainRepository});

  @override
  Future<Resource<void>> call(int id) async =>
      mainRepository.setNullParentFolderId(id);
}
