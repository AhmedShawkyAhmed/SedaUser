import 'package:fluttertoast/fluttertoast.dart';

import '../../presentation/styles/app_colors.dart';

enum ToastState {
  success,
  warning,
  error,
}

showToast(String text, ToastState state) async {
  await Fluttertoast.cancel();
  final backgroundColor = state == ToastState.success
      ? AppColors.green
      : state == ToastState.error
          ? AppColors.red
          : AppColors.yellow;
  final textColor = state == ToastState.success
      ? AppColors.white
      : state == ToastState.error
          ? AppColors.white
          : AppColors.black;
  Fluttertoast.showToast(
    msg: text,
    timeInSecForIosWeb: 1,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    fontSize: 16,
    backgroundColor: backgroundColor,
    textColor: textColor,
  );
}
