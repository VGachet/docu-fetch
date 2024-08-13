import 'dart:async';

import 'package:docu_fetch/data/networking/networking.dart';
import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/domain/usecase/delete_pdf_use_case.dart';
import 'package:docu_fetch/domain/usecase/download_pdf_use_case.dart';
import 'package:docu_fetch/domain/usecase/get_local_pdf_list_use_case.dart';
import 'package:docu_fetch/domain/usecase/get_pdf_list_use_case.dart';
import 'package:docu_fetch/domain/usecase/insert_local_pdf_use_case.dart';
import 'package:docu_fetch/presentation/main_controller.dart';
import 'package:docu_fetch/util/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class HomeController extends GetxController {
  HomeController(
      {required this.downloadPdfUseCase,
      required this.getPdfListUseCase,
      required this.insertLocalPdfUseCase,
      required this.deleteLocalPdfUseCase,
      required this.getLocalPdfListUseCase});

  final DownloadPdfUseCase downloadPdfUseCase;
  final GetPdfListUseCase getPdfListUseCase;
  final InsertLocalPdfUseCase insertLocalPdfUseCase;
  final GetLocalPdfListUseCase getLocalPdfListUseCase;
  final DeleteLocalPdfUseCase deleteLocalPdfUseCase;

  final MainController mainController = Get.find();

  RxList<Pdf> pdfList = RxList.empty();

  Rx<double> downloadProgress = 0.0.obs;
  Rx<double> maxProgressValue = 0.0.obs;

  final TextEditingController pdfUrlController = TextEditingController()
    ..text = 'https://vgachet.dev/wp-content/uploads/test/docu-fetch-test.json';

  @override
  void onReady() {
    super.onReady();
    loadLocalPdfList();
  }

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
          final pdfWithId =
              downloadPdfResource.data!.copyWith(id: const Uuid().toString());
          final insertLocalPdfResource = await insertLocalPdfUseCase(pdfWithId);

          if (insertLocalPdfResource is Success) {
            pdfList.add(pdfWithId);
          } else {
            print('insert PDF Error');
          }
        } else {
          print('download PDF Error');
        }
      }
    } else {
      print('get PDF List Error');
    }
    Get.back(closeOverlays: true);
  }

  Future<void> loadLocalPdfList() async {
    pdfList.clear();
    final localPdfListResource = await getLocalPdfListUseCase();

    if (localPdfListResource is Success) {
      pdfList.addAll(localPdfListResource.data!);
    } else {
      print('get Local PDF List Error');
    }
  }

  Future<void> deleteLocalPdf(Pdf pdf) async {
    final deleteLocalPdfResource = await deleteLocalPdfUseCase(pdf);

    if (deleteLocalPdfResource is Success) {
      pdfList.remove(pdf);
    } else {
      print('delete Local PDF Error');
    }
  }

  void pickPdfFromDevice() {}
}
