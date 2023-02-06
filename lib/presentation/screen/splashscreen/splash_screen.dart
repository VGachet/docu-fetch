import 'package:clean_architecture_getx/presentation/screen/splashscreen/splash_screen_controller.dart';
import 'package:clean_architecture_getx/presentation/widget/page_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final SplashScreenController controller = Get.find();

  @override
  Widget build(BuildContext context) => PageContainer(
        body: const Center(
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Clean Architecture GetX - Coingecko coin list'))),
      );
}
