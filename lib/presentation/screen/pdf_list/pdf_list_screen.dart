import 'package:docu_fetch/presentation/routes.dart';
import 'package:docu_fetch/presentation/screen/pdf_list/pdf_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PdfListScreen extends StatelessWidget {
  final PdfListController controller = Get.find();

  PdfListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF List'),
        actions: [
          IconButton(
            icon: Icon(Icons.create_new_folder),
            onPressed: () {
              // Show dialog to create a new folder
              showCreateFolderDialog();
            },
          ),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            if (controller.parentFolderIdList.isNotEmpty)
              ListTile(
                title: Text('..'),
                onTap: () => controller
                    .loadFolderContent(controller.parentFolderIdList.last),
              ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    controller.pdfList.length + controller.folderList.length,
                itemBuilder: (context, index) {
                  if (index < controller.folderList.length) {
                    final folder = controller.folderList[index];
                    return ListTile(
                      title: Text(folder.title),
                      onTap: () => controller.loadFolderContent(folder.id),
                    );
                  } else {
                    final pdf = controller
                        .pdfList[index - controller.folderList.length];
                    return ListTile(
                      title: Text(pdf.title),
                      trailing: IconButton(
                        icon: Icon(Icons.cut),
                        onPressed: () => controller.cutPdfToFolder(pdf),
                      ),
                      onTap: () => Get.toNamed(Routes.pdf, arguments: pdf),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => controller.cutPdfList.isNotEmpty
            ? FloatingActionButton(
                onPressed: () {
                  // Show dialog to select folder to paste the PDF
                  showPastePdfDialog();
                },
                child: Icon(Icons.paste),
              )
            : Container(),
      ),
    );
  }

  void showCreateFolderDialog() {
    // Implementation of dialog to create a new folder
  }

  void showPastePdfDialog() {
    // Implementation of dialog to select folder to paste the PDF
  }
}
