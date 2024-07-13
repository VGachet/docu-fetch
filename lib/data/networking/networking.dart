import 'dart:async';

import 'package:dio/dio.dart';

abstract class Networking {
  Future<Response> download({required String url, required String path});
  Future<Response> get({required String url});
  void setOnDownloadProgressReceived(
      Function(int, int) onDownloadProgressReceived);
}
