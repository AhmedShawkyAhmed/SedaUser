import 'package:flutter/material.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class NotificationCardView extends StatelessWidget {
  final String title;
  final String subTitle;
  final VoidCallback onTap;

  const NotificationCardView({
    required this.onTap,
    required this.title,
    required this.subTitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      margin: const EdgeInsets.all(10.0),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDark ? AppColors.lightGrey : AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.8),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DefaultText(
            text: title,
            fontSize: 12.sp,
            textColor: isDark ? AppColors.darkGrey : null,
          ),
          const SizedBox(
            height: 10,
          ),
          DefaultText(
            text: subTitle,
            fontSize: 10.sp,
            textColor: isDark ? AppColors.darkGrey : null,
            fontWeight: FontWeight.w400,
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}
