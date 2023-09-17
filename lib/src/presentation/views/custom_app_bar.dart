import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class CustomAppBar extends StatelessWidget {
  final double height;
  final String title;
  final Widget customWidget;
  final Widget historyWidget;
  final bool forChat;
  final bool hasBack;
  final VoidCallback onTap;

  const CustomAppBar({
    required this.height,
    required this.title,
    required this.customWidget,
    required this.historyWidget,
    this.hasBack = true,
    this.forChat = false,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: AppColors.midGreen,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 6.h,
            left: 10,
            right: 10,
          ),
          child: Column(
            children: [
              forChat
                  ? Row(
                      children: [
                        InkWell(
                          onTap: onTap,
                          child: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 15.w,
                          height: 15.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Image.asset(
                            "assets/images/person.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        DefaultText(
                          text: title,
                          textColor: AppColors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        const Spacer(),
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Icon(
                              Icons.phone_iphone_outlined,
                              color: AppColors.midGreen,
                              size: 20.sp,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        hasBack
                            ? InkWell(
                                onTap: onTap,
                                child: const Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: AppColors.white,
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          width: 20,
                        ),
                        DefaultText(
                          text: title,
                          textColor: AppColors.white,
                          fontSize: 20.sp,
                        ),
                        const Spacer(),
                        historyWidget
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
              customWidget
            ],
          ),
        ),
      ),
    );
  }
}
