
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:next_gen_ai_healthcare/theme/app_theme.dart';

void showToastMessage(String message) {
  try {
    if (!kIsWeb) {
      Fluttertoast.showToast(
        msg: message,
        backgroundColor: const Color.fromARGB(134, 29, 160, 242),
        gravity: ToastGravity.BOTTOM,
      );
    }
  } catch (e) {
    debugPrint("Flutter Toast is not compatible with web");
    // You can use an alternative approach for web, such as showing a SnackBar or an AlertDialog
    // For example, you can use the following code to show a SnackBar:
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text(message)),
    // );
  }
}
