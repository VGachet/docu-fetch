import 'package:docu_fetch/presentation/routes.dart';
import 'package:docu_fetch/presentation/screen/home/home_controller.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_colors.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_margins.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_theme.dart';
import 'package:docu_fetch/presentation/widget/expandable_fab/expandable_fab.dart';
import 'package:docu_fetch/presentation/widget/page_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) => PageContainer(
      backgroundColor: CustomColors.colorGreyLight,
      floatingActionButton: ExpandableFab(
        children: {
          'add_pdf_from_url'.tr: showUrlFormDialog,
          'add_pdf_from_file'.tr: controller.pickPdfFromDevice,
        },
      ),
      body: Obx(() => controller.pdfList.isEmpty
          ? SizedBox(
              height: Get.height - Get.statusBarHeight,
              width: Get.width,
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: CustomMargins.margin16),
                    child: Text('empty_pdf_list'.tr,
                        style: CustomTheme.body, textAlign: TextAlign.center)),
              ))
          : RefreshIndicator(
              onRefresh: controller.loadLocalPdfList,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: controller.pdfList
                    .map((pdf) => Padding(
                        padding: const EdgeInsets.all(CustomMargins.margin8),
                        child: Material(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: CustomMargins.margin8),
                                child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: CustomMargins.margin16),
                                    title: Text(pdf.title,
                                        style: const TextStyle(
                                            color: Colors.black)),
                                    trailing: Material(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        clipBehavior: Clip.antiAlias,
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color: Colors.black,
                                              shadows: [
                                                Shadow(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    blurRadius: 10)
                                              ],
                                            ),
                                            onPressed: () async {
                                              await controller
                                                  .deleteLocalPdf(pdf);
                                            })),
                                    onTap: () {
                                      Get.toNamed(Routes.pdf, arguments: pdf);
                                    })))))
                    .toList(),
              ))));

  void displayDownloadProgressPopup() {
    showDialog(
      barrierDismissible: false,
      context: Get.overlayContext!,
      builder: (context) => AlertDialog(
        title: Text('downloading_pdf'.tr,
            style: CustomTheme.body, textAlign: TextAlign.center),
        content: SizedBox(
            width: Get.width,
            height: 100,
            child: Center(
                child: Stack(children: [
              Center(
                  child: SizedBox(
                      height: 60,
                      width: 60,
                      child: Obx(() => CircularProgressIndicator(
                            value: controller.downloadProgress.value,
                          )))),
              Center(
                  child: Obx(() => Text(
                        '${(controller.downloadProgress.value * 100).round()}%',
                        style: CustomTheme.body,
                        textAlign: TextAlign.center,
                      ))),
            ]))),
      ),
    );
  }

  void showUrlFormDialog() {
    showDialog(
      context: Get.overlayContext!,
      builder: (context) => AlertDialog(
        content: TextField(
          style: CustomTheme.body,
          controller: controller.pdfUrlController,
          decoration: InputDecoration(
            hintText: 'enter_url_json'.tr,
            labelText: 'enter_url_json'.tr,
            border: const OutlineInputBorder(),
            labelStyle: CustomTheme.body,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('cancel'.tr, style: CustomTheme.bodyRed),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              displayDownloadProgressPopup();
              controller.downloadPdf();
            },
            child: Text('validate'.tr, style: CustomTheme.body),
          ),
        ],
      ),
    );
  }

  void showDeleteConfirmDialog() {}
}
