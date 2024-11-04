import 'package:docu_fetch/presentation/screen/splashscreen/splash_screen_controller.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_margins.dart';
import 'package:docu_fetch/presentation/ui/theme/custom_theme.dart';
import 'package:docu_fetch/presentation/widget/page_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashScreenController controller = Get.find();

  @override
  Widget build(BuildContext context) => PageContainer(
        backgroundColor: Get.theme.colorScheme.secondary,
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(CustomMargins.margin24),
                child: Text('DocuFetch', style: CustomTheme.title))),
      );
}
