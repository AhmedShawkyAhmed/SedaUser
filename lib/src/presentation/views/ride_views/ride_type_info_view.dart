import 'package:flutter/material.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class RideTypeInfoView extends StatelessWidget {
  final String title;
  final String subTitle;
  final String price;
  final String time;
  final String image;

  const RideTypeInfoView({
    required this.title,
    required this.image,
    required this.price,
    required this.subTitle,
    required this.time,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? AppColors.grey : AppColors.grey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              color: isDark ? AppColors.darkGrey : AppColors.white,
              width: 100.w,
              height: 22.h,
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultText(
                    text: title,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DefaultText(
                    text: subTitle,
                    textColor:
                        isDark ? AppColors.lightGrey : AppColors.darkGrey,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: AppColors.lightGrey,
                        )),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person,
                          color:
                              isDark ? AppColors.lightGrey : AppColors.darkGrey,
                          size: 12.sp,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        DefaultText(
                          text: '4',
                          textColor:
                              isDark ? AppColors.lightGrey : AppColors.darkGrey,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
              top: 10,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultText(
                      text: context.upfrontFare,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    DefaultText(
                      text: price,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                DefaultText(
                  text: time,
                  fontSize: 9.sp,
                  maxLines: 6,
                  fontWeight: FontWeight.w300,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  // var radius = 5.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width, 100);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
