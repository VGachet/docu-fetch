import 'package:docu_fetch/presentation/ui/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin CustomTheme {
  //Theme applied when the device is in light mode
  static ThemeData get light => ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: CustomColors.colorBlack,
          secondary: CustomColors.colorGreyLight,
          surface: CustomColors.colorWhite,
          error: CustomColors.colorRedStrong,
          onError: CustomColors.colorRedStrong,
          onPrimary: CustomColors.colorBlack,
          onSecondary: CustomColors.colorBlack,
          onSurface: CustomColors.colorBlack,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: CustomColors.colorWhite,
          selectedItemColor: CustomColors.colorBlack,
          unselectedItemColor: CustomColors.colorInactive,
        ),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: CustomColors.colorBlack),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.all(CustomColors.colorBlue),
          checkColor: WidgetStateProperty.all(CustomColors.colorWhite),
          overlayColor: WidgetStateProperty.all(CustomColors.colorGreyLight),
          side: const BorderSide(
            color: CustomColors.colorBlue,
            width: 2,
          ),
        ),
      );

  //Theme applied when the device is in dark mode
  static ThemeData get dark => ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: CustomColors.colorWhite,
          secondary: CustomColors.colorGreyLight,
          surface: CustomColors.colorBlack,
          error: CustomColors.colorBlack,
          onError: CustomColors.colorRedStrong,
          onPrimary: CustomColors.colorWhite,
          onSecondary: CustomColors.colorWhite,
          onSurface: CustomColors.colorWhite,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: CustomColors.colorBlack,
          selectedItemColor: CustomColors.colorWhite,
          unselectedItemColor: CustomColors.colorInactive,
        ),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: CustomColors.colorWhite),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.all(CustomColors.colorGreyLight),
          checkColor: WidgetStateProperty.all(CustomColors.colorBlack),
          overlayColor: WidgetStateProperty.all(CustomColors.colorGreyLight),
        ),
      );

  static TextStyle get title => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Get.theme.colorScheme.primary,
      );

  static TextStyle get subtitle => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Get.theme.colorScheme.primary,
      );

  static TextStyle get body => TextStyle(
        fontSize: 14,
        color: Get.theme.colorScheme.primary,
      );

  static TextStyle get bodyDisabled => const TextStyle(
        fontSize: 14,
        color: CustomColors.colorInactive,
      );

  static TextStyle get bodyRed => TextStyle(
        fontSize: 14,
        color: Get.theme.colorScheme.onError,
      );
}
