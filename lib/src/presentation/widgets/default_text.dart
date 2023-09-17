import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:sizer/sizer.dart';

class DefaultText extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double? fontSize;
  final int? maxLines;
  final bool underLined;
  final bool lineThrow;
  final FontWeight? fontWeight;
  final VoidCallback? onTap;
  final TextAlign? align;
  final double letterSpacing;
  final double? height;
  final String? fontFamily;
  final TextOverflow? overflow;
  final List<Shadow>? shadows;

  const DefaultText({
    required this.text,
    this.textColor,
    this.fontSize,
    this.underLined = false,
    this.lineThrow = false,
    this.maxLines,
    this.fontFamily,
    this.fontWeight,
    this.onTap,
    this.height,
    this.align,
    this.letterSpacing = 0.0,
    Key? key,
    this.overflow,
    this.shadows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        textAlign: align ?? (context.isAr ? TextAlign.right : TextAlign.left),
        style: TextStyle(
          height: height,
          letterSpacing: letterSpacing,
          decoration: underLined
              ? TextDecoration.underline
              : lineThrow
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
          color: textColor ?? (!isDark ? AppColors.black : AppColors.lightGrey),
          fontSize: fontSize ?? 17.sp,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: fontFamily ?? 'Inter',
          shadows: shadows,
        ),
        textDirection: ui.TextDirection.ltr,
        maxLines: maxLines ?? 1,
        overflow: overflow ?? TextOverflow.ellipsis,
      ),
    );
  }
}
