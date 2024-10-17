import 'package:docu_fetch/presentation/routes.dart';
import 'package:docu_fetch/presentation/screen/pdf_list/pdf_list_controller.dart';
import 'package:docu_fetch/presentation/ui/lower_case_input_formatter.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_colors.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_margins.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_theme.dart';
import 'package:docu_fetch/presentation/widget/neumorphic_button.dart';
import 'package:docu_fetch/presentation/widget/neumorphic_list_tile.dart';
import 'package:docu_fetch/presentation/widget/page_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PdfListScreen extends StatelessWidget {
  final PdfListController controller = Get.find();

  PdfListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(
                vertical: CustomMargins.margin8,
                horizontal: CustomMargins.margin16),
            child: NeumorphicButton(
              icon: Icons.menu,
              onTap: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
      ),
      backgroundColor: Get.theme.colorScheme.surface,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.onSurface,
              ),
              child: Text(
                'Docu Fetch',
                style: CustomTheme.title
                    .copyWith(color: Get.theme.colorScheme.secondary),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: Text('add_pdf_from_file'.tr, style: CustomTheme.body),
              onTap: () {
                Navigator.pop(context);
                controller.pickPdfFromDevice();
              },
            ),
            ListTile(
              leading: const Icon(Icons.create_new_folder),
              title: Text('add_pdf_from_url'.tr, style: CustomTheme.body),
              onTap: () {
                Navigator.pop(context);
                showUrlFormDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: Text('display_unsorted_pdf'.tr, style: CustomTheme.body),
              onTap: () {
                Navigator.pop(context);
                // Implement the action to display unsorted PDFs
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort),
              title: Text('display_sorted_pdf'.tr, style: CustomTheme.body),
              onTap: () {
                Navigator.pop(context);
                // Implement the action to display sorted PDFs
              },
            ),
          ],
        ),
      ),
      body: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.parentFolderIdList.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  top: CustomMargins.margin32,
                  bottom: CustomMargins.margin8,
                  left: CustomMargins.margin16,
                ),
                child: NeumorphicButton(
                  icon: Icons.arrow_back,
                  text: 'back'.tr,
                  onTap: () {
                    controller.parentFolderIdList.removeLast();
                    controller.loadFolderContent(
                        controller.parentFolderIdList.isNotEmpty
                            ? controller.parentFolderIdList.last
                            : null);
                  },
                ),
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.loadFolderContent(
                    controller.parentFolderIdList.isNotEmpty
                        ? controller.parentFolderIdList.last
                        : null),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                      horizontal: CustomMargins.margin16,
                      vertical: CustomMargins.margin8),
                  itemCount:
                      controller.pdfList.length + controller.folderList.length,
                  itemBuilder: (context, index) {
                    if (index < controller.folderList.length) {
                      final folder = controller.folderList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: CustomMargins.margin8),
                        child: NeumorphicListTile(
                          title: folder.title,
                          leading: const Icon(Icons.folder),
                          onTap: () => controller.loadFolderContent(folder.id),
                        ),
                      );
                    } else {
                      final pdf = controller
                          .pdfList[index - controller.folderList.length];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: CustomMargins.margin8),
                        child: NeumorphicListTile(
                          title: pdf.title,
                          leading: const Icon(Icons.picture_as_pdf),
                          trailing: IconButton(
                            icon: const Icon(Icons.cut),
                            onPressed: () => controller.cutPdfToFolder(pdf),
                          ),
                          onTap: () => Get.toNamed(Routes.pdf, arguments: pdf),
                          onDismissed: (direction) {
                            controller.deleteLocalPdf(pdf);
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => controller.selectedPdfList.isNotEmpty
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

  void showUrlFormDialog() {
    showDialog(
      context: Get.overlayContext!,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(CustomMargins.margin16),
        elevation: 4,
        backgroundColor: CustomColors.colorGreyLight,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: CustomTheme.body,
              controller: controller.repoNameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'enter_repo_name'.tr,
                hintText: 'repo_name_example'.tr,
                border: const OutlineInputBorder(),
                labelStyle: CustomTheme.body,
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.colorBlack)),
                disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.colorBlack)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.colorBlack)),
              ),
            ),
            const SizedBox(height: CustomMargins.margin16),
            Obx(
              () => TextField(
                style: CustomTheme.body,
                controller: controller.repoJsonUrlController,
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: 'enter_json_repo_url'.tr,
                  hintText: 'json_repo_url_example'.tr,
                  border: const OutlineInputBorder(),
                  labelStyle: CustomTheme.body,
                  errorText: controller.repoUrlFieldError.value,
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: CustomColors.colorBlack)),
                  disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: CustomColors.colorBlack)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: CustomColors.colorBlack)),
                ),
                inputFormatters: [LowerCaseTextFormatter()],
              ),
            ),
          ],
        ),
        actions: [
          NeumorphicButton(
            onTap: () {
              controller.repoJsonUrlController.clear();
              controller.repoNameController.clear();
              Get.back();
            },
            text: 'cancel'.tr,
          ),
          Obx(() => NeumorphicButton(
                isDisabled: controller.isValidateButtonDisabled.value,
                onTap: () async {
                  Get.back();
                  final bool isRepoAdded = await controller.insertRepository();
                  if (isRepoAdded) {
                    await controller.downloadPdf();
                  } else {
                    controller.repoNameController.clear();
                    controller.repoJsonUrlController.clear();
                  }
                },
                text: 'validate'.tr,
              )),
        ],
      ),
    );
  }
}
