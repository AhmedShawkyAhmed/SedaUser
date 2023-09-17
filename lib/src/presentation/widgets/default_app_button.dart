import 'package:flutter/material.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:sizer/sizer.dart';

class DefaultAppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? buttonColor;
  final Color? shadowColor;
  final double? fontSize;
  final double? width;
  final double? height;
  final double? radius;
  final double? spreadRadius;
  final double? blurRadius;
  final Offset? offset;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextDecoration? textDecoration;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  final List<Color>? gradientColors;
  final bool isGradient;
  final bool haveShadow;

  const DefaultAppButton({
    required this.title,
    required this.onTap,
    this.buttonColor,
    this.textColor,
    this.width,
    this.height,
    this.radius,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.textDecoration,
    this.begin,
    this.end,
    this.offset,
    this.gradientColors,
    this.shadowColor,
    this.spreadRadius,
    this.blurRadius,
    this.isGradient = true,
    this.haveShadow = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 80.w,
      height: height ?? 7.h,
      decoration: BoxDecoration(
        gradient: isGradient
            ? LinearGradient(
                begin: begin ?? Alignment.centerRight,
                end: end ?? Alignment.centerLeft,
                colors: gradientColors ??
                    [
                      AppColors.green,
                      AppColors.midGreen,
                      AppColors.darkGreen,
                    ],
              )
            : LinearGradient(
                colors: [
                  buttonColor ?? Colors.grey,
                  buttonColor ?? Colors.grey,
                ],
              ),
        boxShadow: [
          haveShadow
              ? BoxShadow(
                  color: shadowColor ?? Colors.black.withOpacity(0.5),
                  spreadRadius: spreadRadius ?? 5,
                  blurRadius: blurRadius ?? 5,
                  offset: offset ??
                      const Offset(1, 1), // changes position of shadow
                )
              : const BoxShadow(),
        ],
        borderRadius: BorderRadius.circular(radius ?? 50),
        color: buttonColor ?? Colors.grey,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: fontSize ?? 13.sp,
                fontWeight: fontWeight ?? FontWeight.w600,
                fontFamily: fontFamily ?? 'Inter',
                decoration: textDecoration ?? TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
