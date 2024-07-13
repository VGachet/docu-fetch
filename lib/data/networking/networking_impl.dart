import 'dart:async';

import 'package:clean_architecture_getx/data/networking/networking.dart';
import 'package:dio/dio.dart';

class NetworkingImpl implements Networking {
  NetworkingImpl({required this.dio});

  final Dio dio;

  Function(int, int)? _onDownloadProgressReceived;

  @override
  Future<Response> download({required String url, required String path}) {
    return dio.download(url, path,
        onReceiveProgress: _onDownloadProgressReceived);
  }

  @override
  void setOnDownloadProgressReceived(
      Function(int, int) onDownloadProgressReceived) {
    _onDownloadProgressReceived = onDownloadProgressReceived;
  }

  @override
  Future<Response> get({required String url}) {
    return dio.get(url);
  }
}
