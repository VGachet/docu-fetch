import 'package:docu_fetch/presentation/ui/theme/custom_margins.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_theme.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:get/get.dart';

class NeumorphicButton extends StatelessWidget {
  NeumorphicButton({
    super.key,
    required this.onTap,
    this.icon,
    this.size = const Size(56, 56),
    this.isRound = false,
    this.text,
    this.isDisabled = false,
  });

  final RxBool isElevated = false.obs;
  final IconData? icon;
  final VoidCallback onTap;
  final Size size;
  final Rx<Offset> distance = const Offset(2, 2).obs;
  final RxDouble blur = 6.0.obs;
  final bool isRound;
  final String? text;
  final bool isDisabled;
  final Color disabledColor = Get.theme.colorScheme.surfaceDim;
  final Color iconColor = Get.theme.colorScheme.onSecondary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      onTapDown: (_) {
        if (isDisabled) {
          return;
        }
        isElevated.value = true;
        distance.value = const Offset(1, 1);
        blur.value = 8.0;
      },
      onTapUp: (_) {
        if (isDisabled) {
          return;
        }
        isElevated.value = false;
        distance.value = const Offset(1, 1);
        blur.value = 4.0;
      },
      child: Obx(
        () => Container(
          padding: text != null
              ? const EdgeInsets.symmetric(
                  horizontal: CustomMargins.margin16,
                  vertical: CustomMargins.margin8)
              : null,
          height: text != null ? null : size.width,
          width: text != null ? null : size.height,
          decoration: BoxDecoration(
            color: isDisabled ? disabledColor : Get.theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(isRound ? size.width : 12),
            boxShadow: [
              BoxShadow(
                color: Get.theme.colorScheme.shadow,
                offset: distance.value,
                blurRadius: blur.value,
                spreadRadius: 1,
                inset: isElevated.value,
              ),
              BoxShadow(
                color: Get.theme.colorScheme.shadow,
                offset: distance.value,
                blurRadius: blur.value,
                spreadRadius: 1,
                inset: isElevated.value,
              )
            ],
          ),
          child: icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Icon(icon, size: 20, color: iconColor),
                      if (text != null)
                        const SizedBox(width: CustomMargins.margin8),
                      if (text != null)
                        Text(text ?? '',
                            style: isDisabled
                                ? CustomTheme.bodyDisabled
                                : CustomTheme.body),
                    ])
              : Text(text ?? '',
                  style:
                      isDisabled ? CustomTheme.bodyDisabled : CustomTheme.body),
        ),
      ),
    );
  }
}
