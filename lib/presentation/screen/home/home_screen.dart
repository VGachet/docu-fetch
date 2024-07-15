import 'package:docu_fetch/presentation/routes.dart';
import 'package:docu_fetch/presentation/screen/home/home_controller.dart';
import 'package:docu_fetch/presentation/widget/page_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) => PageContainer(
          body: Column(
        children: [
          TextField(
            style: const TextStyle(fontSize: 16, color: Colors.black),
            controller: controller.pdfUrlController,
            decoration: InputDecoration(
              hintText: 'enter_url_json'.tr,
              border: const OutlineInputBorder(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              displayDownloadProgressPopup();
              controller.downloadPdf();
            },
            child: const Text('Download PDF'),
          ),
          Expanded(
              child: Obx(() => controller.pdfList.isEmpty
                  ? Container()
                  : RefreshIndicator(
                      onRefresh: controller.loadLocalPdfList,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: controller.pdfList
                            .map((pdf) => ListTile(
                                title: Text(pdf.title,
                                    style:
                                        const TextStyle(color: Colors.black)),
                                trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.black),
                                    onPressed: () async {
                                      await controller.deleteLocalPdf(pdf);
                                    }),
                                onTap: () {
                                  Get.toNamed(Routes.pdf, arguments: pdf);
                                }))
                            .toList(),
                      )))),
        ],
      ));

  void displayDownloadProgressPopup() {
    showDialog(
      context: Get.overlayContext!,
      builder: (context) => AlertDialog(
        title: const Text('Downloading PDF'),
        content: Obx(() => SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              value: controller.downloadProgress.value,
            ))),
      ),
    );
  }
}
