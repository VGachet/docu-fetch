import 'package:docu_fetch/domain/model/folder.dart';
import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/domain/model/text_icon.dart';
import 'package:docu_fetch/presentation/routes.dart';
import 'package:docu_fetch/presentation/screen/pdf_list/pdf_list_controller.dart';
import 'package:docu_fetch/presentation/ui/lower_case_input_formatter.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_colors.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_margins.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_theme.dart';
import 'package:docu_fetch/presentation/widget/neumorphic_button.dart';
import 'package:docu_fetch/presentation/widget/neumorphic_list_tile.dart';
import 'package:docu_fetch/presentation/widget/page_container.dart';
import 'package:docu_fetch/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PdfListScreen extends StatelessWidget {
  final PdfListController controller = Get.find();

  PdfListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PageContainer(
        appBar: AppBar(
          title: Text(
              controller.parentFolderList.isNotEmpty
                  ? controller.parentFolderList.last!.title
                  : '',
              style: CustomTheme.title),
          backgroundColor: Get.theme.colorScheme.secondary,
          leadingWidth: 72,
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
        backgroundColor: Get.theme.colorScheme.secondary,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.onSurface,
                ),
                child: Text(
                  'DocuFetch',
                  style: CustomTheme.title
                      .copyWith(color: Get.theme.colorScheme.secondary),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: Text('add_pdf_from_phone'.tr, style: CustomTheme.body),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickPdfFromDevice();
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_outlined),
                title: Text('add_pdf_from_url'.tr, style: CustomTheme.body),
                onTap: () {
                  Navigator.pop(context);
                  showUrlFormDialog();
                },
              ),
              Container(
                height: 1,
                color: Get.theme.colorScheme.onSurface,
              ),
              ListTile(
                leading: const Icon(Icons.create_new_folder),
                title: Text('create_folder'.tr, style: CustomTheme.body),
                onTap: () {
                  Navigator.pop(context);
                  showRenameFolderDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.list_alt),
                title: Text('repository_list'.tr, style: CustomTheme.body),
                onTap: () {
                  Navigator.pop(context);
                  showRepositoryListDialog();
                },
              ),
              Container(
                height: 1,
                color: Get.theme.colorScheme.onSurface,
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: Text('docufetch_tutorial'.tr, style: CustomTheme.body),
                onTap: () {
                  Navigator.pop(context);
                  launchUrlString(Constants.readMeUrl);
                },
              ),
            ],
          ),
        ),
        body: Obx(
          () => controller.pdfList.isNotEmpty ||
                  controller.folderList.isNotEmpty ||
                  controller.parentFolderList.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.parentFolderList.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: CustomMargins.margin32,
                          bottom: CustomMargins.margin8,
                          left: CustomMargins.margin16,
                          right: CustomMargins.margin16,
                        ),
                        child: NeumorphicButton(
                          icon: Icons.arrow_back,
                          text: 'back'.tr,
                          onTap: () {
                            controller.parentFolderList.removeLast();
                            controller.loadFolderContent(
                                controller.parentFolderList.isNotEmpty
                                    ? controller.parentFolderList.last
                                    : null);
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: CustomMargins.margin24,
                        bottom: CustomMargins.margin24,
                        left: CustomMargins.margin8,
                        right: CustomMargins.margin8,
                      ),
                      child: SizedBox(
                        width: Get.width,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.end,
                          runAlignment: WrapAlignment.end,
                          alignment: WrapAlignment.end,
                          verticalDirection: VerticalDirection.up,
                          runSpacing:
                              CustomMargins.margin16, // gap between lines
                          children: [
                            if (controller.isSelectionMode.value &&
                                controller.selectedList.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: CustomMargins.margin8,
                                ),
                                child: NeumorphicButton(
                                  text: 'deselect_all'.tr,
                                  icon: Icons.deselect,
                                  onTap: controller.deselectAll,
                                ),
                              ),
                            if (controller.isSelectionMode.value)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: CustomMargins.margin8,
                                ),
                                child: NeumorphicButton(
                                  text: 'select_all'.tr,
                                  icon: Icons.check_box_outlined,
                                  onTap: controller.addAllToSelectedList,
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: CustomMargins.margin8,
                              ),
                              child: NeumorphicButton(
                                text: controller.isSelectionMode.value
                                    ? 'cancel'.tr
                                    : 'select'.tr,
                                icon: controller.isSelectionMode.value
                                    ? Icons.cancel
                                    : Icons.select_all,
                                onTap: () {
                                  controller.toggleSelectionMode();
                                  if (controller.isCutMode.value) {
                                    controller.toggleCutMode();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (controller.isSelectionMode.value)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!controller.isCutMode.value)
                            NeumorphicButton(
                              icon: Icons.content_cut,
                              text: 'cut'.tr,
                              isDisabled: controller.selectedList.isEmpty,
                              onTap: controller.toggleCutMode,
                            ),
                          if (controller.isCutMode.value)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: CustomMargins.margin16,
                                  vertical: CustomMargins.margin8),
                              child: NeumorphicButton(
                                icon: Icons.paste,
                                text: 'paste'.tr,
                                onTap: () {
                                  controller.moveSelectionToFolder();
                                },
                              ),
                            ),
                          if (!controller.isCutMode.value)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: CustomMargins.margin16,
                                  vertical: CustomMargins.margin8),
                              child: NeumorphicButton(
                                icon: Icons.delete,
                                text: 'delete'.tr,
                                isDisabled: controller.selectedList.isEmpty,
                                onTap: showDeleteConfirmDialog,
                              ),
                            ),
                        ],
                      ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => controller.loadFolderContent(
                            controller.parentFolderList.isNotEmpty
                                ? controller.parentFolderList.last
                                : null),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: CustomMargins.margin16,
                              vertical: CustomMargins.margin8),
                          itemCount: controller.pdfList.length +
                              controller.folderList.length,
                          itemBuilder: (context, index) {
                            if (index < controller.folderList.length) {
                              final folder = controller.folderList[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: CustomMargins.margin8),
                                child: Obx(
                                  () => NeumorphicListTile(
                                      title: folder.title,
                                      leading: const Icon(Icons.folder),
                                      isSelectionMode:
                                          controller.isSelectionMode.value,
                                      isSelected: controller.selectedList
                                          .map((e) => e.id)
                                          .contains(folder.id),
                                      onCheckboxChanged: (value) {
                                        controller.toggleSelection(folder);
                                      },
                                      onLongPress: () {
                                        controller.toggleSelectionMode();
                                        controller.selectedList.add(folder);
                                      },
                                      onTap: () {
                                        if (!controller.selectedList
                                            .contains(folder)) {
                                          controller.loadFolderContent(folder);
                                        }
                                      },
                                      /*dismissible: !controller.isSelectionMode.value,
                                /onDismissed: (_) {
                                  showDeleteConfirmDialog(folder: folder);
                                },*/
                                      trailingDropdown: controller
                                              .isSelectionMode.value
                                          ? null
                                          : {
                                              TextIcon(
                                                      text: 'open'.tr,
                                                      icon: Icons
                                                          .arrow_circle_right_outlined):
                                                  () => controller
                                                      .loadFolderContent(
                                                          folder),
                                              TextIcon(
                                                      text: 'delete'.tr,
                                                      icon:
                                                          Icons.delete_outline):
                                                  () => showDeleteConfirmDialog(
                                                      folder: folder),
                                              TextIcon(
                                                      text: 'rename'.tr,
                                                      icon: Icons
                                                          .drive_file_rename_outline):
                                                  () => showRenameFolderDialog(
                                                      folder: folder),
                                              TextIcon(
                                                  text: 'select'.tr,
                                                  icon: Icons
                                                      .check_box_outlined): () {
                                                controller
                                                    .toggleSelectionMode();
                                                controller.selectedList
                                                    .add(folder);
                                              },
                                            }),
                                ),
                              );
                            } else {
                              final pdf = controller.pdfList[
                                  index - controller.folderList.length];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: CustomMargins.margin8),
                                child: Obx(
                                  () => NeumorphicListTile(
                                    title: pdf.renamedTitle ?? pdf.title,
                                    leading: const Icon(Icons.picture_as_pdf),
                                    isSelectionMode:
                                        controller.isSelectionMode.value,
                                    isSelected: controller.selectedList
                                        .map((e) => e.id)
                                        .contains(pdf.id),
                                    onCheckboxChanged: (value) {
                                      controller.toggleSelection(pdf);
                                    },
                                    onLongPress: () {
                                      controller.toggleSelectionMode();
                                      controller.selectedList.add(pdf);
                                    },
                                    onTap: () {
                                      if (controller.isSelectionMode.value) {
                                        controller.toggleSelection(pdf);
                                      } else {
                                        Get.toNamed(Routes.pdf, arguments: pdf)
                                            ?.then((_) {
                                          controller.loadFolderContent(
                                              controller.parentFolderList
                                                      .isNotEmpty
                                                  ? controller
                                                      .parentFolderList.last
                                                  : null);
                                        });
                                      }
                                    },
                                    /*dismissible: !controller.isSelectionMode.value,
                              onDismissed: (_) {
                                if (!controller.isSelectionMode.value) {
                                  showDeleteConfirmDialog(pdf: pdf);
                                }
                              },*/
                                    trailingDropdown: controller
                                            .isSelectionMode.value
                                        ? null
                                        : {
                                            TextIcon(
                                                    text: 'open'.tr,
                                                    icon: Icons
                                                        .arrow_circle_right_outlined):
                                                () => Get.toNamed(Routes.pdf,
                                                    arguments: pdf),
                                            TextIcon(
                                                    text: 'delete'.tr,
                                                    icon: Icons.delete_outline):
                                                () => showDeleteConfirmDialog(
                                                    pdf: pdf),
                                            TextIcon(
                                                    text: 'rename'.tr,
                                                    icon: Icons
                                                        .drive_file_rename_outline):
                                                () => showRenamePdfDialog(pdf),
                                            TextIcon(
                                                text: 'select'.tr,
                                                icon: Icons
                                                    .check_box_outlined): () {
                                              controller.toggleSelectionMode();
                                              controller.selectedList.add(pdf);
                                            },
                                          },
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    'no_folder_pdf'.tr,
                    style: CustomTheme.body,
                  ),
                ),
        ),
      ),
    );
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
                    await controller.downloadPdf(
                        repositoryUrl: controller.repoJsonUrlController.text,
                        repositoryName: controller.repoNameController.text);
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

  void showRenameFolderDialog({Folder? folder}) {
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
              controller: controller.renameFolderController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: folder != null
                    ? 'enter_new_folder_name'.tr
                    : 'enter_folder_name'.tr,
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
              controller.renameFolderController.clear();
              Get.back();
            },
            text: 'cancel'.tr,
          ),
          Obx(
            () => NeumorphicButton(
              onTap: () async {
                Get.back();
                if (folder != null) {
                  await controller.renameFolder(folder);
                } else {
                  await controller.createFolder(
                      folderName: controller.renameFolderController.text);
                }
              },
              isDisabled: controller.isFolderRenameButtonDisabled.value,
              text: folder != null ? 'rename'.tr : 'validate'.tr,
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteConfirmDialog({Pdf? pdf, Folder? folder}) {
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
                pdf != null
                    ? 'delete_pdf_confirmation'
                        .trParams({'pdfTitle': pdf.getTitle()})
                    : folder != null
                        ? 'delete_folder_confirmation'
                            .trParams({'folderTitle': folder.title})
                        : 'delete_selected_pdfs_confirmation'.tr,
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
              if (folder != null) {
                await controller.deleteFolder(folder);
              } else if (pdf != null) {
                await controller.deleteLocalPdf(pdf);
              } else {
                await controller.deleteSelectedItems();
              }
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
        contentPadding: const EdgeInsets.all(CustomMargins.margin8),
        elevation: 4,
        backgroundColor: CustomColors.colorGreyLight,
        content: SizedBox(
          height: 300,
          width: Get.width,
          child: Obx(
            () => controller.repositoryList.isEmpty
                ? Center(
                    child: Text(
                      'empty_repository_list'.tr,
                      style: CustomTheme.body,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.repositoryList.length,
                    itemBuilder: (context, index) {
                      final repo = controller.repositoryList[index];
                      return NeumorphicListTile(
                        title: repo.name,
                        subtitle: repo.url,
                        onTap: () {
                          Get.back();
                          controller.downloadPdf(
                              repositoryUrl: repo.url,
                              repositoryName: repo.name);
                        },
                        trailingDropdown: {
                          TextIcon(text: 'update'.tr, icon: Icons.update): () =>
                              controller.downloadPdf(
                                  repositoryUrl: repo.url,
                                  repositoryName: repo.name),
                          TextIcon(
                                  text: 'delete'.tr,
                                  icon: Icons.delete_outline):
                              () => controller.deleteLocalRepository(repo),
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
              isDisabled: controller.isPdfRenameButtonDisabled.value,
              text: 'rename'.tr,
            ),
          ),
        ],
      ),
    );
  }
}
