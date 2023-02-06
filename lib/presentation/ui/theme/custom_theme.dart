import 'package:clean_architecture_getx/presentation/ui/theme/custom_colors.dart';
import 'package:flutter/material.dart';

mixin CustomTheme {
  //Theme applied when the device is in light mode
  static ThemeData get light => ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: CustomColors.colorWhite,
          secondary: CustomColors.colorBlue,
          background: CustomColors.colorWhite,
          error: CustomColors.colorWhite,
          onBackground: CustomColors.colorBlack,
          onError: CustomColors.colorRedStrong,
          onPrimary: CustomColors.colorBlack,
          onSecondary: CustomColors.colorWhite,
          surface: CustomColors.colorBlue,
          onSurface: CustomColors.colorWhite,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: CustomColors.colorWhite,
          selectedItemColor: CustomColors.colorBlack,
          unselectedItemColor: CustomColors.colorInactive,
        ),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: CustomColors.colorBlue),
      );

  //Theme applied when the device is in dark mode
  static ThemeData get dark => ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: CustomColors.colorBlue,
          secondary: CustomColors.colorWhite,
          background: CustomColors.colorBlue,
          error: CustomColors.colorWhite,
          onBackground: CustomColors.colorWhite,
          onError: CustomColors.colorRedStrong,
          onPrimary: CustomColors.colorWhite,
          onSecondary: CustomColors.colorBlue,
          surface: CustomColors.colorWhite,
          onSurface: CustomColors.colorBlack,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: CustomColors.colorBlue,
          selectedItemColor: CustomColors.colorWhite,
          unselectedItemColor: CustomColors.colorInactive,
        ),
      );
}
