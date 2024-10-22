import 'package:docu_fetch/domain/model/folder.dart';
import 'package:docu_fetch/domain/repository/main_repository.dart';
import 'package:docu_fetch/domain/usecase/usecase.dart';
import 'package:docu_fetch/util/resource.dart';

class GetLocalFolderListUseCase
    implements UseCase<Resource<List<Folder>>, int?> {
  final MainRepository mainRepository;

  const GetLocalFolderListUseCase({required this.mainRepository});

  @override
  Future<Resource<List<Folder>>> call(int? parentFolderId) async =>
      mainRepository.getLocalFolderList(parentFolderId);
}
