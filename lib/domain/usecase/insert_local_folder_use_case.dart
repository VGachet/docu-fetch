import 'package:docu_fetch/domain/model/folder.dart';
import 'package:docu_fetch/domain/repository/main_repository.dart';
import 'package:docu_fetch/domain/usecase/usecase.dart';
import 'package:docu_fetch/util/resource.dart';

class InsertLocalFolderUseCase implements UseCase<Resource<int>, Folder> {
  final MainRepository mainRepository;

  const InsertLocalFolderUseCase({required this.mainRepository});

  @override
  Future<Resource<int>> call(Folder folder) async =>
      mainRepository.insertLocalFolder(folder);
}
