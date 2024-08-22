import 'dart:async';

import 'package:docu_fetch/presentation/screen/pdf_screen/pdf_controller.dart';
import 'package:docu_fetch/presentation/widget/page_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';

class PdfScreen extends StatelessWidget {
  final PdfController controller = Get.find();

  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

  PdfScreen({super.key});

  @override
  Widget build(BuildContext context) => PageContainer(
          body: PDFView(
        filePath: controller.pdf.path,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        defaultPage: controller.pdf.lastPageOpened,
        onViewCreated: (PDFViewController pdfViewController) {
          _controller.complete(pdfViewController);
        },
        onPageChanged: (int? page, int? total) {
          controller.pdf.lastPageOpened = page!;
        },
      ));
}
