import 'package:docu_fetch/presentation/routes.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  void onReady() async {
    super.onReady();

    await Future<void>.delayed(const Duration(seconds: 1));
    Get.offNamed(Routes.home);
  }
}
