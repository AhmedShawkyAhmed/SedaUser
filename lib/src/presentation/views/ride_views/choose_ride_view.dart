import 'package:flutter/material.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class ChooseRideView extends StatelessWidget {
  final String title;
  final String subTitle;
  final String price;
  final String currency;
  final String time;
  final String image;
  final bool selected;
  final int shipmentTypeId;

  const ChooseRideView({
    required this.title,
    required this.image,
    required this.price,
    required this.currency,
    required this.subTitle,
    required this.time,
    required this.selected,
    required this.shipmentTypeId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInCubic,
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 10,
            bottom: 10,
          ),
          // margin: const EdgeInsets.only(
          //   top: 2.5,
          //   bottom: 2.5,
          // ),
          decoration: BoxDecoration(
              color: isDark ? AppColors.darkGrey : AppColors.white,
              borderRadius: BorderRadius.circular(19),
              boxShadow: [
                BoxShadow(
                  color: selected
                      ? isDark
                          ? AppColors.white.withOpacity(0.25)
                          : AppColors.grey.withOpacity(0.15)
                      : AppColors.transparent,
                  spreadRadius: 5,
                  blurRadius: 3,
                  offset: const Offset(0, 0),
                ),
              ]),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: selected ? 30.w : 20.w,
                height: selected ? 9.h : 8.h,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: image.contains('http')
                            ? Image.network(
                                image,
                              ).image
                            : Image.asset(
                                image,
                              ).image)),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultText(
                    text: title,
                    fontSize: selected ? 13.sp : 12.sp,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  DefaultText(
                    text: subTitle,
                    fontSize: selected ? 10.sp : 9.sp,
                    fontWeight: selected ? FontWeight.w400 : FontWeight.w300,
                  ),
                ],
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DefaultText(
                    text: currency,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  FittedBox(
                    child: DefaultText(
                      text: price,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
