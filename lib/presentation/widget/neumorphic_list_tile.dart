import 'package:docu_fetch/domain/model/TextIcon.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_colors.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_margins.dart';
import 'package:flutter/material.dart';

class NeumorphicListTile extends StatelessWidget {
  const NeumorphicListTile({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.trailingDropdown,
  });

  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Offset distance = const Offset(2, 2);
  final double blur = 6.0;
  final Map<TextIcon, Function>? trailingDropdown;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(
            vertical: CustomMargins.margin4,
            horizontal: CustomMargins.margin16),
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
          title: title != null
              ? Text(title!, style: const TextStyle(color: Colors.black))
              : null,
          subtitle: subtitle != null
              ? Text(subtitle!, style: const TextStyle(color: Colors.black))
              : null,
          //trailing: trailing,
          trailing: trailingDropdown != null
              ? PopupMenuButton<TextIcon>(
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
                          title: Text(textIcon.text),
                        ),
                      ),
                  ],
                )
              : trailing,
          onTap: onTap,
        ));
  }
}
