import 'dart:io';

import 'package:docu_fetch/presentation/screen/pdf_screen/pdf_controller.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfScreen extends StatelessWidget {
  final PdfController controller = Get.find();

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  PdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.pdf.value == null
          ? const SizedBox()
          : Scaffold(
              appBar: controller.isAppBarVisible.value
                  ? AppBar(
                      title: Text(
                          controller.pdf.value!.renamedTitle ??
                              controller.pdf.value!.title,
                          style: CustomTheme.title),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () => _showSettingsDialog(context),
                        ),
                      ],
                    )
                  : null,
              backgroundColor: Get.theme.colorScheme.secondary,
              body: GestureDetector(
                onTap: controller.toggleAppBarVisibility,
                child: Stack(
                  children: [
                    SfPdfViewer.file(
                      File(controller.pdf.value!.path!),
                      key: _pdfViewerKey,
                      scrollDirection: controller.pdf.value!.isHorizontal
                          ? PdfScrollDirection.horizontal
                          : PdfScrollDirection.vertical,
                      initialPageNumber: controller.pdf.value!.lastPageOpened,
                      onPageChanged: (pageChanceCallback) {
                        controller.pdf.value!.lastPageOpened =
                            pageChanceCallback.newPageNumber;
                      },
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height:
                          50, // Height of the tappable area to show the AppBar
                      child: GestureDetector(
                        onTap: () {
                          if (!controller.isAppBarVisible.value) {
                            controller.toggleAppBarVisibility();
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('settings'.tr, style: CustomTheme.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('toggle_orientation'.tr, style: CustomTheme.body),
                trailing: Obx(
                  () => Switch(
                    value: controller.pdf.value!.isHorizontal,
                    thumbColor: WidgetStateProperty.all(
                        Get.theme.colorScheme.secondary),
                    onChanged: (bool value) {
                      controller.toggleScrollDirection();
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'close'.tr,
                style: CustomTheme.body,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
