import 'package:docu_fetch/domain/model/repository.dart';
import 'package:docu_fetch/domain/repository/main_repository.dart';
import 'package:docu_fetch/domain/usecase/usecase.dart';
import 'package:docu_fetch/util/resource.dart';

class GetLocalRepositoryListUseCase
    implements SimpleUseCase<Resource<List<Repository>>> {
  final MainRepository mainRepository;

  const GetLocalRepositoryListUseCase({required this.mainRepository});

  @override
  Future<Resource<List<Repository>>> call() async =>
      mainRepository.getLocalRepositoryList();
}
