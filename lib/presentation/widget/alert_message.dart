import 'package:docu_fetch/presentation/ui/theme/custom_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AlertMessage {
  static void show({required String message, bool isError = true}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor:
            isError ? CustomColors.colorRed : CustomColors.colorGreen,
        textColor: CustomColors.colorWhite,
        fontSize: 16.0);
  }
}
