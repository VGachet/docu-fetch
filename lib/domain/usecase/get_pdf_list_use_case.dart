import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/domain/repository/main_repository.dart';
import 'package:docu_fetch/domain/usecase/usecase.dart';
import 'package:docu_fetch/util/resource.dart';

class GetPdfListUseCase implements UseCase<Resource<List<Pdf>>, String> {
  final MainRepository mainRepository;

  const GetPdfListUseCase({required this.mainRepository});

  @override
  Future<Resource<List<Pdf>>> call(String url) async =>
      mainRepository.getPdfList(url: url);
}
