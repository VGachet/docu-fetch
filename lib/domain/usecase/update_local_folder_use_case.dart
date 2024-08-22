import 'package:docu_fetch/domain/model/folder.dart';
import 'package:docu_fetch/domain/repository/main_repository.dart';
import 'package:docu_fetch/domain/usecase/usecase.dart';
import 'package:docu_fetch/util/resource.dart';

class UpdateLocalLocalFolderUseCase implements UseCase<Resource<void>, Folder> {
  final MainRepository mainRepository;

  const UpdateLocalLocalFolderUseCase({required this.mainRepository});

  @override
  Future<Resource<void>> call(Folder folder) async =>
      mainRepository.updateLocalFolder(folder);
}
