import 'package:flutter/material.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/data/models/driver_offer_model.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class DriverOfferView extends StatelessWidget {
  const DriverOfferView({
    Key? key,
    required this.driverOffer,
    required this.confirmOffer,
  }) : super(key: key);

  final DriverOfferModel driverOffer;
  final Function() confirmOffer;

  @override
  Widget build(BuildContext context) {
    printResponse("${driverOffer.driver?.image}");
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 2.5.h,
                  backgroundColor:
                      isDark ? AppColors.grey.withOpacity(0.2) : AppColors.grey,
                  child: Icon(
                    Icons.person,
                    color: AppColors.white,
                    size: 3.h,
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultText(
                      text: "${driverOffer.driver?.name}",
                      textColor:
                          isDark ? AppColors.lightGrey : AppColors.darkGrey,
                      fontSize: 12.sp,
                    ),
                    DefaultText(
                      text: "\$ ${driverOffer.driver_price}",
                      fontSize: 13.sp,
                      textColor: AppColors.lightRed,
                    )
                  ],
                ),
              ],
            ),
          ),
          DefaultAppButton(
            width: 25.w,
            height: 5.h,
            fontSize: 13.sp,
            title: context.confirm,
            onTap: confirmOffer,
          ),
        ],
      ),
    );
  }
}
