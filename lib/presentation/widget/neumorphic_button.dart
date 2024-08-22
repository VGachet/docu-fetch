import 'package:docu_fetch/presentation/ui/theme/custom_colors.dart';
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
    this.disabledColor = CustomColors.colorGreyLight,
    this.iconColor = CustomColors.colorBlack,
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
  final Color disabledColor;
  final Color iconColor;

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
            color: isDisabled ? disabledColor : CustomColors.colorGreyLight,
            borderRadius: BorderRadius.circular(isRound ? size.width : 12),
            boxShadow: [
              BoxShadow(
                color: CustomColors.colorGrey,
                offset: distance.value,
                blurRadius: blur.value,
                spreadRadius: 1,
                inset: isElevated.value,
              ),
              BoxShadow(
                color: CustomColors.colorGrey,
                offset: distance.value,
                blurRadius: blur.value,
                spreadRadius: 1,
                inset: isElevated.value,
              )
            ],
          ),
          child: icon != null
              ? Icon(icon, size: 20, color: iconColor)
              : Text(text ?? '',
                  style:
                      isDisabled ? CustomTheme.bodyDisabled : CustomTheme.body),
        ),
      ),
    );
  }
}
