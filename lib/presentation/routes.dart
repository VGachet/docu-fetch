import 'package:docu_fetch/presentation/screen/home/home_binding.dart';
import 'package:docu_fetch/presentation/screen/home/home_screen.dart';
import 'package:docu_fetch/presentation/screen/pdf_screen/pdf_binding.dart';
import 'package:docu_fetch/presentation/screen/pdf_screen/pdf_screen.dart';
import 'package:docu_fetch/presentation/screen/splashscreen/splash_screen.dart';
import 'package:docu_fetch/presentation/screen/splashscreen/splash_screen_binding.dart';
import 'package:get/get.dart';

mixin Routes {
  static const String home = '/home';
  static const String splashscreen = '/splash_screen';
  static const String pdf = '/pdf';

  static final pages = [
    GetPage(
      name: splashscreen,
      page: () => SplashScreen(),
      binding: SplashScreenBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: pdf,
      page: () => PdfScreen(),
      binding: PdfBinding(),
      transition: Transition.cupertino,
    ),
  ];
}
