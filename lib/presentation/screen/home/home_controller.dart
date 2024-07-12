import 'dart:async';

import 'package:clean_architecture_getx/data/networking/networking.dart';
import 'package:clean_architecture_getx/domain/model/download_pdf_param.dart';
import 'package:clean_architecture_getx/domain/model/pdf.dart';
import 'package:clean_architecture_getx/domain/usecase/download_pdf_use_case.dart';
import 'package:clean_architecture_getx/presentation/main_controller.dart';
import 'package:clean_architecture_getx/util/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController {
  HomeController({required this.downloadPdfUseCase});

  final DownloadPdfUseCase downloadPdfUseCase;

  final MainController mainController = Get.find();

  RxList<Pdf> pdfList = RxList.empty();

  Rx<double> downloadProgress = 0.0.obs;
  Rx<double> maxProgressValue = 0.0.obs;

  final TextEditingController pdfUrlController = TextEditingController()
    ..text = 'https://research.nhm.org/pdfs/10840/10840-001.pdf';

  Future<void> downloadPdf() async {
    final path = '${(await getApplicationDocumentsDirectory()).path}/pdfs';

    Get.find<Networking>().setOnDownloadProgressReceived((received, total) {
      downloadProgress.value = received / total;
    });

    final downloadPdfResult = await downloadPdfUseCase(
        DownloadPdfParam(url: pdfUrlController.text, path: path));

    if (downloadPdfResult is Success) {
      print('Downloaded PDF: ${downloadPdfResult.data}');
      pdfList.add(downloadPdfResult.data!);
    } else {
      //Display error
    }
  }
}
