import 'dart:async';

import 'package:get/get.dart';

class MainController extends GetxController {
  RxBool isLoading = false.obs;
  Timer? maxLoadingTimer;
  Timer? minLoadingTimer;
  RxBool isLoadingCanStop = true.obs;

  @override
  void onInit() async {
    super.onInit();

    //Manage full screen loader with min loading time of 250ms and max of 10sec
    isLoading.listen((value) async {
      isLoadingCanStop.value = false;

      if (value) {
        minLoadingTimer?.cancel();
        maxLoadingTimer?.cancel();

        maxLoadingTimer = Timer(const Duration(milliseconds: 10000), () {
          isLoading.value = false;
        });

        minLoadingTimer = Timer(const Duration(milliseconds: 250), () {});
      } else {
        maxLoadingTimer?.cancel();

        if (minLoadingTimer != null && minLoadingTimer!.isActive) {
          await Future.delayed(const Duration(milliseconds: 250));
          isLoadingCanStop.value = true;
        } else {
          isLoadingCanStop.value = true;
        }
      }
    });
  }
}
