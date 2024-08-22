import 'package:docu_fetch/domain/model/folder.dart';
import 'package:docu_fetch/domain/repository/main_repository.dart';
import 'package:docu_fetch/domain/usecase/usecase.dart';
import 'package:docu_fetch/util/resource.dart';

class UpdateLocalLocalFolderListUseCase
    implements UseCase<Resource<void>, List<Folder>> {
  final MainRepository mainRepository;

  const UpdateLocalLocalFolderListUseCase({required this.mainRepository});

  @override
  Future<Resource<void>> call(List<Folder> folderList) async =>
      mainRepository.updateLocalFolderList(folderList);
}
