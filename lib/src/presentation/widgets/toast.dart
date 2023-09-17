import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';

final FToast fToast = FToast();

showToast(
  String? text, {
  ToastGravity? gravity,
  Color? color,
  Color? textColor,
  bool shortLength = true,
}) {
  Fluttertoast.showToast(
    msg: text!,
    timeInSecForIosWeb: 1,
    toastLength: shortLength ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
    gravity: gravity ?? ToastGravity.TOP,
    backgroundColor: color ?? AppColors.grey,
    textColor: textColor ?? AppColors.black,
  );
}
