import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/business_logic/rate_cubit/rate_cubit.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/views/order_views/end_views/thank_rate_driver_bottom_sheet.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:seda/src/presentation/widgets/default_text_field.dart';
import 'package:seda/src/presentation/widgets/rating_buttons.dart';
import 'package:sizer/sizer.dart';

class RateDriverBottomSheet extends StatefulWidget {
  const RateDriverBottomSheet({Key? key}) : super(key: key);

  @override
  State<RateDriverBottomSheet> createState() => _RateDriverBottomSheetState();
}

class _RateDriverBottomSheetState extends State<RateDriverBottomSheet> {
  TextEditingController commentController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  double rate = 5;
  bool checkLeft = false;
  bool checkRight = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        width: 100.w,
        constraints: BoxConstraints(maxHeight: 90.h),
        padding: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(50),
          ),
          color: isDark ? AppColors.darkGrey : AppColors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          waitingDriverToggleView.value = false;
                          Navigator.of(context).popUntil(
                            (route) => route.isFirst,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(50)),
                          child: DefaultText(
                            text: 'Skip',
                            fontWeight: FontWeight.w500,
                            textColor: AppColors.black,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                    DefaultText(
                      text: context.rateDriver,
                      textColor: AppColors.darkGrey,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 10.h,
                      height: 10.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.midGrey.withOpacity(0.7),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child:
                          OrderCubit.get(context).orderModel?.captain?.image !=
                                  null
                              ? Image.network(
                                  "${EndPoints.imageBaseUrl}${OrderCubit.get(context).orderModel?.captain?.image!}",
                                  fit: BoxFit.cover,
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(15),
                                  child: FittedBox(
                                    child: Icon(
                                      Icons.person,
                                      color: AppColors.darkGrey,
                                      size: 65,
                                    ),
                                  ),
                                ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RatingBar.builder(
                      initialRating: rate,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      unratedColor: AppColors.lightGrey,
                      textDirection: TextDirection.ltr,
                      itemSize: 25.sp,
                      glow: false,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star_outlined,
                        color: AppColors.yellow,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          rate = rating;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RatingButtons(
                          text: context.leftWindowClosed,
                          width: 50.w,
                        ),
                        RatingButtons(
                          text: context.carCond,
                          width: 26.w,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RatingButtons(
                          text: context.impol,
                          width: 25.w,
                        ),
                        RatingButtons(
                          text: context.arrLate,
                          width: 25.w,
                        ),
                        RatingButtons(
                          text: context.badDrive,
                          width: 25.w,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    DefaultTextField(
                      height: 50,
                      controller: commentController,
                      hintText: context.leaveComment,
                      // color: AppColors.lightGrey.withOpacity(0.5),
                      borderColor: AppColors.transparent,
                      bottom: 6,
                      border: const Border(
                        bottom:
                            BorderSide(width: 1, color: AppColors.lightGrey),
                      ),
                      prefix: Image.asset('assets/images/comment.png'),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: DefaultText(
                          text: context.thankDriverWithTip(
                              OrderCubit.get(context)
                                      .orderModel
                                      ?.captain
                                      ?.name ??
                                  ''),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 85.w,
                      height: 7.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border:
                              Border.all(color: AppColors.primary, width: 1)),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                checkRight = false;
                                checkLeft = true;
                              });
                            },
                            child: Container(
                              width: 25.w,
                              height: 7.h,
                              decoration: BoxDecoration(
                                color: checkLeft
                                    ? AppColors.midGreen
                                    : AppColors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  bottomLeft: Radius.circular(50),
                                ),
                              ),
                              child: Center(
                                child: DefaultText(
                                  text: "15 SAR",
                                  textColor: checkLeft
                                      ? AppColors.white
                                      : AppColors.darkGrey,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 1.2.h),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                      color: AppColors.primary, width: 1),
                                  right: BorderSide(
                                      color: AppColors.primary, width: 1),
                                ),
                              ),
                              child: DefaultTextField(
                                height: 6.h,
                                bottom: 6,
                                textAlign: TextAlign.center,
                                controller: priceController,
                                fontSize: 11.sp,
                                hintText: context.addTip,
                                borderColor: AppColors.white,
                                textColor: AppColors.darkGrey,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                checkRight = true;
                                checkLeft = false;
                              });
                            },
                            child: Container(
                              width: 25.w,
                              height: 7.h,
                              decoration: BoxDecoration(
                                color: checkRight
                                    ? AppColors.midGreen
                                    : AppColors.white,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
                                ),
                              ),
                              child: Center(
                                child: DefaultText(
                                  text: "5 SAR",
                                  textColor: checkRight
                                      ? AppColors.white
                                      : AppColors.darkGrey,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              DefaultAppButton(
                title: context.submit,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => const LoadingIndicator(),
                  );
                  RateCubit.get(context).addRate(
                    afterError: () => Navigator.pop(context),
                    driverId: OrderCubit.get(context).orderModel!.captain!.id!,
                    rate: rate.toInt(),
                    comment: commentController.text,
                    afterSuccess: () {
                      resetOrder();
                      showModalBottomSheet<dynamic>(
                        isScrollControlled: true,
                        enableDrag: false,
                        isDismissible: false,
                        backgroundColor: AppColors.transparent,
                        context: context,
                        builder: (BuildContext bc) {
                          return const ThankRateDriverBottomSheet();
                        },
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
