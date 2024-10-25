import 'dart:io';

import 'package:docu_fetch/presentation/screen/pdf_screen/pdf_controller.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_margins.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_theme.dart';
import 'package:docu_fetch/presentation/widget/page_container.dart';
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
          : PageContainer(
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
              body: Stack(
                children: [
                  Obx(
                    () => SfPdfViewer.file(
                      File(controller.pdf.value!.path!),
                      key: _pdfViewerKey,
                      controller: controller.pdfViewerController,
                      scrollDirection: controller.pdf.value!.isHorizontal
                          ? PdfScrollDirection.horizontal
                          : PdfScrollDirection.vertical,
                      initialPageNumber: controller.pdf.value!.lastPageOpened,
                      enableDoubleTapZooming: false,
                      pageLayoutMode: controller.pdf.value!.isContinuous
                          ? PdfPageLayoutMode.continuous
                          : PdfPageLayoutMode.single,
                      maxZoomLevel: 2,
                      canShowPageLoadingIndicator: false,
                      onZoomLevelChanged: (zoomLevel) {
                        controller.zoomLevel.value = zoomLevel.newZoomLevel;
                      },
                      onPageChanged: (pageChanceCallback) {
                        controller.pdf.value!.lastPageOpened =
                            pageChanceCallback.newPageNumber;
                      },
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        controller.toggleAppBarVisibility();
                      },
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 0,
                    height: Get.height - 50,
                    width: 50,
                    child: GestureDetector(
                      onTap: () {
                        controller.pdfViewerController.previousPage();
                      },
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 0,
                    height: Get.height - 50,
                    width: 50,
                    child: GestureDetector(
                      onTap: () {
                        controller.pdfViewerController.nextPage();
                      },
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
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
              ListTile(
                title: Text('toggle_layout_mode'.tr, style: CustomTheme.body),
                trailing: Obx(
                  () => Switch(
                    value: controller.pdf.value!.isContinuous,
                    thumbColor: WidgetStateProperty.all(
                        Get.theme.colorScheme.secondary),
                    onChanged: (bool value) {
                      controller.toggleLayoutMode();
                    },
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 120,
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: CustomMargins.margin16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: CustomMargins.margin16),
                        child: Text('zoom'.tr, style: CustomTheme.body),
                      ),
                      const SizedBox(height: CustomMargins.margin32),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          inactiveTrackColor: Get.theme.colorScheme.onSurface,
                          inactiveTickMarkColor: Get.theme.colorScheme.surface,
                          valueIndicatorTextStyle: CustomTheme.body.copyWith(
                            color: Get.theme.colorScheme.secondary,
                          ),
                        ),
                        child: Slider(
                          value: controller.zoomLevel.value,
                          min: 1.0,
                          max: 2.0,
                          divisions: 2,
                          label: '${controller.zoomLevel.value}x',
                          onChanged: (double value) {
                            controller.updateZoomLevel(value);
                          },
                        ),
                      ),
                    ],
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
