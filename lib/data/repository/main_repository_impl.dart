import 'package:clean_architecture_getx/data/networking/networking.dart';
import 'package:clean_architecture_getx/domain/model/pdf.dart';
import 'package:clean_architecture_getx/domain/repository/main_repository.dart';
import 'package:clean_architecture_getx/util/error_manager.dart';
import 'package:clean_architecture_getx/util/resource.dart';

class MainRepositoryImpl implements MainRepository {
  MainRepositoryImpl({required this.networking});

  final Networking networking;

  @override
  Future<Resource<Pdf>> downloadPdf(
      {required String url, required String path}) async {
    if (url.split('.').last == 'pdf') {
      try {
        final response = await networking.download(url: url, path: path);
        print(response);
        return Success(
            Pdf(path: path, title: url.split('/').last.split('.').first));
      } catch (e) {
        return const Error(ErrorStatus.unexpected);
      }
    } else {
      return const Error(ErrorStatus.unexpected);
    }
  }
}
