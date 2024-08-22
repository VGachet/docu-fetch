import 'package:docu_fetch/domain/model/repository.dart';
import 'package:docu_fetch/domain/repository/main_repository.dart';
import 'package:docu_fetch/domain/usecase/usecase.dart';
import 'package:docu_fetch/util/resource.dart';

class DeleteLocalRepositoryUseCase
    implements UseCase<Resource<void>, Repository> {
  final MainRepository mainRepository;

  const DeleteLocalRepositoryUseCase({required this.mainRepository});

  @override
  Future<Resource<void>> call(Repository repository) async =>
      mainRepository.deleteLocalRepository(repository);
}
