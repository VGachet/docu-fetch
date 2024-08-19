import 'package:docu_fetch/domain/model/TextIcon.dart';
import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/presentation/routes.dart';
import 'package:docu_fetch/presentation/screen/home/home_controller.dart';
import 'package:docu_fetch/presentation/ui/lower_case_input_formatter.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_colors.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_margins.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_theme.dart';
import 'package:docu_fetch/presentation/widget/expandable_fab/expandable_fab.dart';
import 'package:docu_fetch/presentation/widget/neumorphic_button.dart';
import 'package:docu_fetch/presentation/widget/neumorphic_list_tile.dart';
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
          'repository_list'.tr: showRepositoryListDialog,
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
                        child: NeumorphicListTile(
                            title: pdf.getTitle(),
                            subtitle: 'version'
                                .trParams({'version': '${pdf.version}'}),
                            trailingDropdown: {
                              TextIcon(
                                  text: 'open'.tr,
                                  icon: Icons.open_in_new_outlined): () {
                                Get.toNamed(Routes.pdf, arguments: pdf);
                              },
                              TextIcon(
                                  text: 'rename'.tr,
                                  icon: Icons.edit_outlined): () {
                                showRenamePdfDialog(pdf);
                              },
                              TextIcon(
                                  text: 'delete'.tr,
                                  icon: Icons.delete_outline): () async {
                                showDeleteConfirmDialog(pdf);
                              },
                            },
                            onTap: () {
                              Get.toNamed(Routes.pdf, arguments: pdf);
                            })))
                    .toList(),
              ))));

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
                    await controller.downloadPdf(
                        repositoryUrl: controller.repoJsonUrlController.text);
                  }
                },
                text: 'validate'.tr,
              )),
        ],
      ),
    );
  }

  void showDeleteConfirmDialog(Pdf pdf) {
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
            Text(
                'delete_pdf_confirmation'
                    .trParams({'pdfTitle': pdf.getTitle()}),
                style: CustomTheme.body),
          ],
        ),
        actions: [
          NeumorphicButton(
            onTap: Get.back,
            text: 'cancel'.tr,
          ),
          NeumorphicButton(
            onTap: () async {
              await controller.deleteLocalPdf(pdf);
              Get.back();
            },
            text: 'delete'.tr,
          ),
        ],
      ),
    );
  }

  void showRepositoryListDialog() {
    showDialog(
      context: Get.overlayContext!,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 0, vertical: CustomMargins.margin8),
        elevation: 4,
        backgroundColor: CustomColors.colorGreyLight,
        content: SizedBox(
          height: 300,
          width: Get.width,
          child: Obx(
            () => ListView.builder(
              shrinkWrap: true,
              itemCount: controller.repositoryList.length,
              itemBuilder: (context, index) {
                final repo = controller.repositoryList[index];
                return NeumorphicListTile(
                  title: repo.name,
                  subtitle: repo.url,
                  onTap: () {
                    Get.back();
                    controller.downloadPdf(repositoryUrl: repo.url);
                  },
                  trailing: NeumorphicButton(
                    icon: Icons.delete,
                    onTap: () async {
                      await controller.deleteLocalRepository(repo);
                    },
                  ),
                );
              },
            ),
          ),
        ),
        actions: [
          NeumorphicButton(
            onTap: Get.back,
            text: 'close'.tr,
          ),
        ],
      ),
    );
  }

  void showRenamePdfDialog(Pdf pdf) {
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
              controller: controller.renamePdfController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'enter_new_pdf_name'.tr,
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
          ],
        ),
        actions: [
          NeumorphicButton(
            onTap: () {
              controller.renamePdfController.clear();
              Get.back();
            },
            text: 'cancel'.tr,
          ),
          Obx(
            () => NeumorphicButton(
              onTap: () async {
                Get.back();
                await controller.renamePdf(pdf.copyWith(
                    renamedTitle: controller.renamePdfController.text));
              },
              isDisabled: controller.isRenameButtonDisabled.value,
              text: 'rename'.tr,
            ),
          ),
        ],
      ),
    );
  }
}
