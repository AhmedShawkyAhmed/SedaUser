import 'package:flutter/material.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class SettingRowView extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final Widget widget;
  final bool hasWidget;
  final Function()? onTap;

  const SettingRowView({
    required this.title,
    required this.color,
    required this.icon,
    required this.widget,
    required this.hasWidget,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 80.w,
          height: 8.h,
          child: Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              DefaultText(
                text: title,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
              ),
              const Spacer(),
              hasWidget
                  ? widget
                  : Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 15.sp,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
