import 'package:dio/dio.dart';
import 'package:get/get.dart';

enum ErrorStatus {
  none,
  empty,
  noNetwork,
  unexpected,
  notFound,
}

class ErrorCode {
  static const int notFound = 404;
  static const int internalServerError = 500;
}

ErrorStatus getErrorStatusByDioError(DioException error) {
  if (error.response != null &&
      error.response!.data != null &&
      error.response!.statusCode != null &&
      error.response!.data is Map<String, dynamic>) {
    switch (error.response!.statusCode) {
      case ErrorCode.notFound:
        return ErrorStatus.notFound;
      default:
        return ErrorStatus.unexpected;
    }
  }
  return ErrorStatus.unexpected;
}

String getErrorMessage(ErrorStatus errorStatus) {
  switch (errorStatus) {
    case ErrorStatus.notFound:
      return 'not_found'.tr;
    case ErrorStatus.unexpected:
    default:
      return 'unexpected_error'.tr;
  }
}
