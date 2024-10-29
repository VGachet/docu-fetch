import 'package:docu_fetch/presentation/screen/pdf_list/pdf_list_binding.dart';
import 'package:docu_fetch/presentation/screen/pdf_list/pdf_list_screen.dart';
import 'package:docu_fetch/presentation/screen/pdf_screen/pdf_binding.dart';
import 'package:docu_fetch/presentation/screen/pdf_screen/pdf_screen.dart';
import 'package:docu_fetch/presentation/screen/splashscreen/splash_screen.dart';
import 'package:docu_fetch/presentation/screen/splashscreen/splash_screen_binding.dart';
import 'package:get/get.dart';

mixin Routes {
  static const String splashscreen = '/splash_screen';
  static const String pdf = '/pdf';
  static const String pdfList = '/pdf_list';

  static final pages = [
    GetPage(
      name: splashscreen,
      page: () => SplashScreen(),
      binding: SplashScreenBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: pdf,
      page: () => PdfScreen(),
      binding: PdfBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: pdfList,
      page: () => PdfListScreen(),
      binding: PdfListBinding(),
      transition: Transition.noTransition,
    ),
  ];
}
