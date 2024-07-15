import 'package:docu_fetch/util/error_manager.dart';

abstract class Resource<T> {
  final T? data;
  final ErrorStatus? errorStatus;

  const Resource({this.data, this.errorStatus});
}

class Success<T> extends Resource<T> {
  const Success(T data) : super(data: data);
}

class Error<T> extends Resource<T> {
  const Error(ErrorStatus errorStatus, {T? data})
      : super(errorStatus: errorStatus, data: data);
}
