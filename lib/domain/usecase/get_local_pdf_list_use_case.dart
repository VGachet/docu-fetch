import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/domain/repository/main_repository.dart';
import 'package:docu_fetch/domain/usecase/usecase.dart';
import 'package:docu_fetch/util/resource.dart';

class GetLocalPdfListUseCase implements UseCase<Resource<List<Pdf>>, int?> {
  final MainRepository mainRepository;

  const GetLocalPdfListUseCase({required this.mainRepository});

  @override
  Future<Resource<List<Pdf>>> call(int? folderId) async =>
      mainRepository.getLocalPdfList(folderId);
}
