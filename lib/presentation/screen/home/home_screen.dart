import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:docu_fetch/domain/model/folder.dart';
import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/domain/model/text_icon.dart';
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
import 'package:docu_fetch/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.find();

  final AutoScrollController scrollController = AutoScrollController();

  @override
  Widget build(BuildContext context) => PageContainer(
      backgroundColor: CustomColors.colorGreyLight,
      floatingActionButton: ExpandableFab(
        children: {
          'add_pdf_from_url'.tr: showUrlFormDialog,
          'add_pdf_from_file'.tr: controller.pickPdfFromDevice,
          'repository_list'.tr: showRepositoryListDialog,
          'create_folder'.tr: showRenameFolderDialog,
          'docufetch_tutorial'.tr: () => launchUrlString(Constants.readMeUrl),
        },
      ),
      body: Obx(() => controller.treeNodeList.isEmpty
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
          : Column(children: [
              Obx(() => controller.pdfAllowingSelection.isNotEmpty ||
                      controller.selectedPdfs.isNotEmpty
                  ? Container(
                      color: CustomColors.colorGreyLight,
                      padding: const EdgeInsets.all(CustomMargins.margin8),
                      child: Row(
                        children: [
                          const Spacer(),
                          NeumorphicButton(
                            onTap: showDeleteConfirmDialog,
                            text: 'delete'.tr,
                            icon: Icons.delete_outline,
                          ),
                          const SizedBox(width: CustomMargins.margin8),
                          if (controller.selectedPdfs.isNotEmpty)
                            Obx(
                              () => NeumorphicButton(
                                onTap: controller.cutSelectedPdfs,
                                text: 'cut'.tr,
                                isDisabled: controller.isCutMode.value,
                                icon: Icons.content_cut,
                                iconColor: controller.isCutMode.value
                                    ? CustomColors.colorWhite
                                    : CustomColors.colorBlack,
                                disabledColor: CustomColors.colorBlue,
                              ),
                            ),
                          if (controller.selectedPdfs.isNotEmpty)
                            const SizedBox(width: CustomMargins.margin8),
                          NeumorphicButton(
                            onTap: controller.cancelCutMode,
                            text: 'cancel'.tr,
                            icon: Icons.cancel_outlined,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox()),
              Expanded(
                  child: RefreshIndicator(
                      onRefresh: controller.loadLocalPdfList,
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          ...controller.treeNodeList.map((node) {
                            return SliverTreeView.simple(
                              scrollController: scrollController,
                              tree: node,
                              showRootNode: false,
                              expansionIndicatorBuilder: (context, node) =>
                                  ChevronIndicator.rightDown(
                                tree: node,
                                alignment: Alignment.centerRight,
                                color: CustomColors.colorBlack,
                                padding: const EdgeInsets.all(
                                    CustomMargins.margin16),
                              ),
                              indentation: const Indentation(
                                  style: IndentStyle.squareJoint),
                              onItemTap: (item) {},
                              onTreeReady: (treeViewController) {
                                controller.treeViewController =
                                    treeViewController;
                              },
                              builder: (context, node) {
                                if (node.data is Pdf) {
                                  return getPdfListTile(node.data as Pdf);
                                } else if (node.data is Folder) {
                                  return getFolderListTile(node.data as Folder);
                                }
                                return const SizedBox();
                              },
                            );
                          }),
                          const SliverToBoxAdapter(
                            child:
                                SizedBox(height: 80), // Adjust height as needed
                          ),
                        ],
                      )))
            ])));

  Widget getPdfListTile(Pdf pdf) => Obx(() => Padding(
      padding: const EdgeInsets.all(CustomMargins.margin8),
      child: NeumorphicListTile(
        title: pdf.getTitle(),
        subtitle: pdf.version != null
            ? 'version'.trParams({'version': '${pdf.version}'})
            : null,
        leading: controller.pdfAllowingSelection.contains(pdf)
            ? Checkbox(
                value: controller.selectedPdfs.contains(pdf),
                onChanged: (value) {
                  if (value == true) {
                    controller.selectedPdfs.add(pdf);
                  } else {
                    controller.selectedPdfs.remove(pdf);
                  }
                },
              )
            : null,
        onLongPress: () {
          // Toggle selection mode and select PDFs in the same folder
          controller.toggleSelectionMode(pdf: pdf);
        },
        trailingDropdown: controller.pdfAllowingSelection.isNotEmpty ||
                controller.selectedPdfs.isNotEmpty
            ? null
            : {
                TextIcon(text: 'open'.tr, icon: Icons.open_in_new_outlined):
                    () => Get.toNamed(Routes.pdf, arguments: pdf),
                TextIcon(text: 'rename'.tr, icon: Icons.edit_outlined): () {
                  controller.renamePdfController.text = pdf.getTitle();
                  showRenamePdfDialog(pdf);
                },
                TextIcon(text: 'delete'.tr, icon: Icons.delete_outline): () =>
                    showDeleteConfirmDialog(pdf: pdf),
              },
        onTap: () => controller.pdfAllowingSelection.contains(pdf)
            ? controller.selectedPdfs.contains(pdf)
                ? controller.selectedPdfs.remove(pdf)
                : controller.selectedPdfs.add(pdf)
            : controller.selectedPdfs.isNotEmpty
                ? null
                : Get.toNamed(Routes.pdf, arguments: pdf),
      )));

  Widget getFolderListTile(Folder folder) => Padding(
      padding: const EdgeInsets.all(CustomMargins.margin8),
      child: Obx(
        () => NeumorphicListTile(
            title: folder.title,
            trailingDropdownPadding: CustomMargins.margin16,
            trailingDropdown: {
              TextIcon(text: 'rename'.tr, icon: Icons.edit_outlined): () {
                controller.renameFolderController.text = folder.title;
                showRenameFolderDialog(folder: folder);
              },
              TextIcon(text: 'delete'.tr, icon: Icons.delete_outline): () =>
                  showDeleteConfirmDialog(folder: folder),
            },
            onTap: controller.isCutMode.value
                ? () => controller.moveSelectedPdfToFolder(folder)
                : null),
      ));

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
                await controller.deleteSelectedPdfs();
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
                    controller.downloadPdf(
                        repositoryUrl: repo.url, repositoryName: repo.name);
                  },
                  trailingDropdown: {
                    TextIcon(text: 'update'.tr, icon: Icons.update): () =>
                        controller.downloadPdf(
                            repositoryUrl: repo.url, repositoryName: repo.name),
                    TextIcon(text: 'delete'.tr, icon: Icons.delete_outline):
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
}
