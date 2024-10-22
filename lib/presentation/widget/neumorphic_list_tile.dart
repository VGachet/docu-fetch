import 'package:docu_fetch/domain/model/text_icon.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_colors.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_margins.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NeumorphicListTile extends StatelessWidget {
  const NeumorphicListTile({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    this.leading,
    this.onTap,
    this.onLongPress,
    this.trailingDropdown,
    this.trailingDropdownPadding = 0,
    this.onDismissed,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.dismissible = false,
    this.onCheckboxChanged,
  });

  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? leading;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Offset distance = const Offset(2, 2);
  final double blur = 6.0;
  final Map<TextIcon, Function>? trailingDropdown;
  final double trailingDropdownPadding;
  final DismissDirectionCallback? onDismissed;
  final bool isSelectionMode;
  final bool isSelected;
  final bool dismissible;
  final ValueChanged<bool?>? onCheckboxChanged;

  @override
  Widget build(BuildContext context) => dismissible
      ? Dismissible(
          key: UniqueKey(),
          onDismissed: onDismissed,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: listTileWidget(),
        )
      : listTileWidget();

  Widget listTileWidget() => Container(
        decoration: BoxDecoration(
          color: CustomColors.colorGreyLight,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CustomColors.colorGrey,
              offset: distance,
              blurRadius: blur,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: CustomColors.colorGrey,
              offset: distance,
              blurRadius: blur,
              spreadRadius: 1,
            )
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: CustomMargins.margin8),
          title: title != null ? Text(title!, style: CustomTheme.body) : null,
          subtitle: subtitle != null
              ? Text(subtitle!, style: CustomTheme.body)
              : null,
          leading: isSelectionMode
              ? Checkbox(
                  value: isSelected,
                  onChanged: onCheckboxChanged,
                  side: BorderSide(color: Get.theme.colorScheme.primary),
                  splashRadius: 20,
                  fillColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return Get.theme.colorScheme
                          .primary; // Black background when selected
                    }
                    return Get.theme.colorScheme
                        .primary; // Black background when not selected
                  }),
                  checkColor: Get.theme.colorScheme.surface, // White tick
                )
              : leading,
          trailing: trailingDropdown != null
              ? Row(mainAxisSize: MainAxisSize.min, children: [
                  PopupMenuButton<TextIcon>(
                    elevation: 6,
                    color: CustomColors.colorGreyLight,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    offset: const Offset(16, 45),
                    onSelected: (TextIcon value) {
                      trailingDropdown?[value]!();
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<TextIcon>>[
                      for (TextIcon textIcon in trailingDropdown!.keys)
                        PopupMenuItem<TextIcon>(
                          value: textIcon,
                          child: ListTile(
                            leading: Icon(textIcon.icon),
                            title: Text(textIcon.text, style: CustomTheme.body),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: trailingDropdownPadding),
                ])
              : trailing,
          onTap: onTap,
          onLongPress: onLongPress,
        ),
      );
}
