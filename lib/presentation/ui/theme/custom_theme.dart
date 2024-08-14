import 'package:docu_fetch/presentation/ui/theme/custom_colors.dart';
import 'package:flutter/material.dart';

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
      );

  static TextStyle get title => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: CustomColors.colorBlack,
      );

  static TextStyle get subtitle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: CustomColors.colorBlack,
      );

  static TextStyle get body => const TextStyle(
        fontSize: 14,
        color: CustomColors.colorBlack,
      );

  static TextStyle get bodyDisabled => const TextStyle(
        fontSize: 14,
        color: CustomColors.colorInactive,
      );

  static TextStyle get bodyRed => const TextStyle(
        fontSize: 14,
        color: CustomColors.colorRed,
      );
}
