import 'package:clean_architecture_getx/domain/model/pdf.dart';
import 'package:clean_architecture_getx/domain/repository/main_repository.dart';
import 'package:clean_architecture_getx/domain/usecase/usecase.dart';
import 'package:clean_architecture_getx/util/resource.dart';

class GetPdfListUseCase implements UseCase<Resource<List<Pdf>>, String> {
  final MainRepository mainRepository;

  const GetPdfListUseCase({required this.mainRepository});

  @override
  Future<Resource<List<Pdf>>> call(String url) async =>
      mainRepository.getPdfList(url: url);
}
