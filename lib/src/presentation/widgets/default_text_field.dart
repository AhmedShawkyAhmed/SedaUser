import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:sizer/sizer.dart';

class DefaultTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onTap;
  final String hintText;
  final double? height;
  final double? width;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final Color? hintTextColor;
  final Color? cursorColor;
  final double? fontSize;
  final int? maxLine;
  final bool? enabled;
  final bool? readOnly;
  final bool? focused;
  final Widget? prefix;
  final Widget? suffix;
  final double? bottom;
  final double? radius;
  final EdgeInsets? padding;
  final TextAlign? textAlign;
  final AlignmentGeometry? alignment;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final BoxBorder? border;
  final BoxShadow? shadow;
  final TextInputAction? textInputAction;
  final Function(String val)? onChanged;
  final int? maxLength;

  const DefaultTextField({
    required this.controller,
    required this.hintText,
    this.onTap,
    this.height,
    this.color,
    this.textColor,
    this.borderColor,
    this.cursorColor,
    this.fontSize,
    this.width,
    this.enabled,
    this.readOnly,
    this.focused,
    this.maxLine,
    this.prefix,
    this.suffix,
    this.alignment,
    this.bottom,
    this.radius,
    this.border,
    this.shadow,
    this.keyboardType,
    this.onChanged,
    this.hintTextColor,
    this.textInputAction,
    Key? key,
    this.inputFormatters,
    this.textAlign,
    this.padding,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 8.h,
      width: width ?? 100.w,
      margin: const EdgeInsets.symmetric(vertical: 7.5),
      decoration: BoxDecoration(
        color:
            focused == true ? AppColors.white : color ?? AppColors.transparent,
        borderRadius:
            border == null ? BorderRadius.circular(radius ?? 10) : null,
        border: border ??
            Border.all(
              color: borderColor ?? AppColors.green,
              width: 1.5,
            ),
        boxShadow: shadow != null && focused == true
            ? [
                BoxShadow(
                  color: AppColors.shadowGrey.withOpacity(0.2),
                  spreadRadius: 4,
                  blurRadius: 30,
                  offset: const Offset(0, 0), // changes position of shadow
                ),
              ]
            : null,
      ),
      padding: padding ?? const EdgeInsets.all(0),
      alignment: alignment ?? Alignment.center,
      child: TextFormField(
        onTap: onTap,
        onTapOutside: (e) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        maxLength: maxLength,
        textInputAction: textInputAction,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType ?? TextInputType.text,
        textAlignVertical: TextAlignVertical.center,
        textAlign: textAlign == null
            ? context.isAr
                ? TextAlign.right
                : TextAlign.left
            : TextAlign.center,
        enabled: enabled ?? true,
        readOnly: readOnly ?? false,
        controller: controller,
        textDirection: TextDirection.ltr,
        style: TextStyle(
          color: textColor ?? AppColors.darkGrey,
          fontSize: fontSize ?? 12.sp,
        ),
        cursorColor: cursorColor ?? AppColors.darkGrey,
        maxLines: maxLine ?? 1,
        decoration: InputDecoration(
          counterText: '',
          prefixIcon: prefix,
          suffixIcon: suffix,
          hintText: hintText,
          alignLabelWithHint: true,
          hintStyle: TextStyle(
            color: hintTextColor ?? AppColors.darkGrey.withOpacity(0.7),
            fontSize: 16,
          ),
          border: InputBorder.none,
          hintTextDirection: TextDirection.ltr,
          filled: true,
          fillColor: AppColors.transparent,
          contentPadding: EdgeInsets.only(
            bottom: prefix == null && suffix == null ? 12 : bottom ?? -8,
            left: 10,
            right: 10,
          ),
        ),
      ),
    );
  }
}
