import 'package:docu_fetch/presentation/ui/theme/custom_colors.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_margins.dart';
import 'package:flutter/material.dart';

class NeumorphicListTile extends StatelessWidget {
  NeumorphicListTile({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Offset distance = const Offset(2, 2);
  final double blur = 6.0;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(
            vertical: CustomMargins.margin8,
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
          trailing: trailing,
          onTap: onTap,
        ));
  }
}
