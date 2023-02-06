import 'package:clean_architecture_getx/presentation/screen/home/home_binding.dart';
import 'package:clean_architecture_getx/presentation/screen/home/home_screen.dart';
import 'package:clean_architecture_getx/presentation/screen/splashscreen/splash_screen.dart';
import 'package:clean_architecture_getx/presentation/screen/splashscreen/splash_screen_binding.dart';
import 'package:get/get.dart';

mixin Routes {
  static const String home = '/home';
  static const String splashscreen = '/splash_screen';

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
  ];
}
