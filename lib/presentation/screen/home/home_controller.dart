import 'dart:async';

import 'package:clean_architecture_getx/data/networking/networking.dart';
import 'package:clean_architecture_getx/domain/model/pdf.dart';
import 'package:clean_architecture_getx/domain/usecase/download_pdf_use_case.dart';
import 'package:clean_architecture_getx/domain/usecase/get_pdf_list_use_case.dart';
import 'package:clean_architecture_getx/presentation/main_controller.dart';
import 'package:clean_architecture_getx/util/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController {
  HomeController(
      {required this.downloadPdfUseCase, required this.getPdfListUseCase});

  final DownloadPdfUseCase downloadPdfUseCase;
  final GetPdfListUseCase getPdfListUseCase;

  final MainController mainController = Get.find();

  RxList<Pdf> pdfList = RxList.empty();

  Rx<double> downloadProgress = 0.0.obs;
  Rx<double> maxProgressValue = 0.0.obs;

  final TextEditingController pdfUrlController = TextEditingController()
    ..text = 'https://vgachet.dev/wp-content/uploads/test/docu-fetch-test.json';

  Future<void> downloadPdf() async {
    final localPath = '${(await getApplicationDocumentsDirectory()).path}/pdfs';

    Get.find<Networking>().setOnDownloadProgressReceived((received, total) {
      downloadProgress.value = received / total;
    });

    final pdfListResource = await getPdfListUseCase(pdfUrlController.text);

    if (pdfListResource is Success) {
      for (final pdf in pdfListResource.data!) {
        final downloadPdfResource = await downloadPdfUseCase(
            pdf.copyWith(path: '$localPath/${pdf.title}'));

        if (downloadPdfResource is Success) {
          pdfList.add(downloadPdfResource.data!);
        } else {
          print('download PDF Error');
        }
      }
    } else {
      print('get PDF List Error');
    }
  }
}
