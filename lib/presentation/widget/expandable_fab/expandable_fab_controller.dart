import 'package:get/get.dart';

class ExpandableFabController extends GetxController {
  final RxBool isOpen = false.obs;

  void toggle() {
    isOpen.value = !isOpen.value;
  }
}
