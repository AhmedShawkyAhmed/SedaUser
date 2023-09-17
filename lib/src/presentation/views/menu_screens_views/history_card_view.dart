import 'package:flutter/material.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/data/models/reponse_models/order_history_response.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class HistoryCardView extends StatelessWidget {
  const HistoryCardView({
    Key? key,
    required this.order,
    required this.onTap,
  }) : super(key: key);

  final Orders order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100.w,
        height: 30.h,
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
        ),
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DefaultText(
                  text: "ID : ${order.id}",
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                ),
                DefaultText(
                  text:
                      order.fromLocation?.createdAtStr?.split(" ").first ?? "",
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: 3.w,
                      height: 3.w,
                      decoration: BoxDecoration(
                          color: AppColors.midGreen,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    Container(
                      width: 0.5.w,
                      height: 7.h,
                      decoration: BoxDecoration(
                          color: AppColors.midGreen,
                          borderRadius: BorderRadius.circular(3)),
                    ),
                    Container(
                      width: 3.w,
                      height: 3.w,
                      decoration: BoxDecoration(
                          color: AppColors.lightRed,
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 75.w,
                      height: 5.5.h,
                      decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DefaultText(
                              text: context.start,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: DefaultText(
                                text: order.fromLocation?.address ?? "",
                                textColor: AppColors.darkGrey,
                                fontWeight: FontWeight.w300,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 75.w,
                      height: 5.5.h,
                      decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DefaultText(
                              text: context.end,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: DefaultText(
                                text: order.toLocation?.last.address ?? "",
                                textColor: AppColors.darkGrey,
                                fontWeight: FontWeight.w300,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 25,
                right: 25,
              ),
              child: Divider(
                thickness: 2,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 9.w,
                  height: 9.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.midGreen,
                  ),
                  child: Icon(
                    Icons.payments_outlined,
                    color: AppColors.white,
                    size: 20.sp,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                DefaultText(
                  text: "${order.price}",
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
                const Spacer(),
                DefaultText(
                  text: order.status ?? "",
                  fontSize: 13.sp,
                  textColor: AppColors.midGreen,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(
                  height: 9.w,
                  width: 10,
                ),
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: AppColors.grey,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
