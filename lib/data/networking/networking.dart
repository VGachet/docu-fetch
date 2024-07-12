import 'dart:async';

import 'package:dio/dio.dart';

abstract class Networking {
  Future<Response> download({required String url, required String path});
  void setOnDownloadProgressReceived(
      Function(int, int) onDownloadProgressReceived);
}
