import 'package:clean_architecture_getx/di/injector.dart';
import 'package:clean_architecture_getx/presentation/routes.dart';
import 'package:clean_architecture_getx/presentation/ui/theme/custom_theme.dart';
import 'package:clean_architecture_getx/util/localization/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Dependencies injection
  await initDependencies();

  runApp(MyApp(key: UniqueKey()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GetMaterialApp(
      initialRoute: Routes.splashscreen,
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.light,
      darkTheme: CustomTheme.dark,
      themeMode: ThemeMode.system,
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      translationsKeys: AppTranslation.translationsKeys,
      getPages: Routes.pages,
      defaultTransition: Transition.rightToLeft,
      transitionDuration: Get.defaultTransitionDuration,
    );
  }
}
