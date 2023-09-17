import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;
  final bool isNew;
  final double imageWidth;
  final double? imageHeight;
  final double? width;
  final double? height;

  const CategoryItem({
    required this.title,
    required this.image,
    required this.onTap,
    required this.imageWidth,
    this.imageHeight,
    this.height,
    this.isNew = false,
    this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height ?? 10.h,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.only(
                  left: isNew ? 28 : 12,
                  right: 16,
                  top: 18,
                  bottom: 12,
                ),
                width: width ?? 35.w,
                // height: 10.h,
                decoration: BoxDecoration(
                  gradient: isNew
                      ? const LinearGradient(
                          colors: [
                            AppColors.white,
                            AppColors.white,
                          ],
                        )
                      : const LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            AppColors.green,
                            AppColors.midGreen,
                            AppColors.darkGreen,
                          ],
                        ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isNew
                      ? [
                          BoxShadow(
                            color: AppColors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(
                              0,
                              0,
                            ), // changes position of shadow
                          ),
                        ]
                      : null,
                ),
                child: isNew
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: imageWidth,
                            height: imageHeight,
                            child: SvgPicture.asset(image),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: DefaultText(
                              text: title,
                              textColor: isDark
                                  ? AppColors.darkGrey
                                  : AppColors.black1,
                              letterSpacing: 1.0,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Calibri',
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: imageWidth,
                            height: imageHeight,
                            child: Image.asset(
                              image,
                            ),
                          ),
                          const Spacer(),
                          DefaultText(
                            text: title,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            textColor:
                                AppColors.white,
                            fontFamily: 'Calibri',
                          ),
                          const Spacer(flex: 2,),
                        ],
                      ),
              ),
            ),
            isNew
                ? Align(
                    alignment:
                        context.isAr ? Alignment.topLeft : Alignment.topRight,
                    child: Container(
                      width: 22.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: context.isAr
                              ? const Radius.circular(0)
                              : const Radius.circular(10),
                          bottomRight: context.isAr
                              ? const Radius.circular(10)
                              : const Radius.circular(0),
                          topLeft: context.isAr
                              ? const Radius.circular(10)
                              : const Radius.circular(0),
                          bottomLeft: context.isAr
                              ? const Radius.circular(0)
                              : const Radius.circular(10),
                        ),
                        color: AppColors.midGreen,
                      ),
                      child: Center(
                        child: DefaultText(
                          text: context.newT,
                          textColor: AppColors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Calibri',
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
