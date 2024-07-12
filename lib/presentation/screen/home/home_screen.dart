import 'package:clean_architecture_getx/presentation/routes.dart';
import 'package:clean_architecture_getx/presentation/screen/home/home_controller.dart';
import 'package:clean_architecture_getx/presentation/widget/page_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) => PageContainer(
          body: SingleChildScrollView(
              child: Column(
        children: [
          TextField(
            style: const TextStyle(fontSize: 16, color: Colors.black),
            controller: controller.pdfUrlController,
            decoration: const InputDecoration(
              hintText: 'Enter PDF URL',
              border: OutlineInputBorder(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              displayDownloadProgressPopup();
              controller.downloadPdf();
            },
            child: const Text('Download PDF'),
          ),
          Obx(() => controller.pdfList.isEmpty
              ? Container()
              : Column(
                  children: controller.pdfList
                      .map((pdf) => ListTile(
                          title: Text(pdf.title,
                              style: const TextStyle(color: Colors.black)),
                          onTap: () {
                            Get.toNamed(Routes.pdf, arguments: pdf);
                          }))
                      .toList(),
                )),
        ],
      )));

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
