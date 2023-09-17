import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seda/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/router/app_router_names.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryDetailsScreen extends StatefulWidget {
  const HistoryDetailsScreen({Key? key}) : super(key: key);

  @override
  State<HistoryDetailsScreen> createState() => _HistoryDetailsScreenState();
}

class _HistoryDetailsScreenState extends State<HistoryDetailsScreen> {
  // TextEditingController codeController = TextEditingController();
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = AuthCubit.get(context).orderDetails;
    if (order?.data?.orders?.createdAtStr?.isNotEmpty == true) {}
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        toolbarHeight: 8.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.white,
            size: 20.sp,
          ),
        ),
        title: DefaultText(
          text: "${context.yourTrip}  ${order?.data?.orders?.id ?? ''}",
          fontSize: 18.sp,
          textColor: isDark ? AppColors.darkGrey : AppColors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: order?.data?.orders?.captain != null ? 88.h : 80.h,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.grey.withOpacity(0.7),
                spreadRadius: 4,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (order?.data?.orders?.captain != null) {
                        Navigator.pushNamed(
                            context, AppRouterNames.captainProfile,
                            arguments: order?.data?.orders?.captain);
                      }
                    },
                    child: Container(
                      width: 18.w,
                      height: 18.w,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: order?.data?.orders?.captain?.image == null
                            ? AppColors.darkGrey
                            : null,
                      ),
                      child: order?.data?.orders?.captain?.image == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: AppColors.white,
                            )
                          : Image.network(
                              "${EndPoints.imageBaseUrl}${order?.data?.orders?.captain?.image}",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultText(
                        text: order?.data?.orders?.captain?.name ?? "",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 4.w,
                            height: 4.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100)),
                            child: Image.asset("assets/images/star.png"),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          DefaultText(
                            text: order?.data?.orders?.captain?.rate ?? '',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      SizedBox(
                        width: 15.w,
                        height: 15.w,
                        child: Center(
                          child: Image.asset("assets/images/car.png"),
                        ),
                      ),
                      DefaultText(
                        text: "w a f 758",
                        textColor: AppColors.midGreen,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      DefaultText(
                        text: "MG5 - RED",
                        textColor: AppColors.darkGrey,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 2.5.h,
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
                      Column(
                        children: List.generate(
                          order!.data!.orders!.toLocation!.length,
                          (index) => Column(
                            children: [
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
                        ),
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
                              // DefaultText(
                              //   text: "Trip Start",
                              //   fontWeight: FontWeight.w400,
                              //   fontSize: 12.sp,
                              // ),
                              Expanded(
                                child: DefaultText(
                                  text: order.data?.orders?.fromLocation
                                          ?.address ??
                                      '',
                                  // textColor: AppColors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                          children: List.generate(
                        order.data!.orders!.toLocation!.length,
                        (index) => Column(
                          children: [
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // DefaultText(
                                    //   text: "Trip Location",
                                    //   fontWeight: FontWeight.w400,
                                    //   fontSize: 12.sp,
                                    // ),
                                    Expanded(
                                      child: DefaultText(
                                        text: order.data?.orders
                                                ?.toLocation?[index].address ??
                                            '',
                                        // textColor: AppColors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 2.5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      DefaultText(
                        text: context.distance,
                        textColor: AppColors.darkGrey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      DefaultText(
                        text: order.data?.orders?.distance ?? '',
                        textColor: AppColors.darkGrey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      DefaultText(
                        text: context.time,
                        textColor: AppColors.darkGrey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      DefaultText(
                        text: order.data?.orders?.timeTaken ?? '',
                        textColor: AppColors.darkGrey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      DefaultText(
                        text: context.special,
                        textColor: AppColors.darkGrey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      const Icon(
                        Icons.star_outlined,
                        color: AppColors.orange,
                      ),
                    ],
                  ),
                ],
              ),
              // SizedBox(
              //   height: 2.5.h,
              // ),
              // Container(
              //   height: 6.h,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     color: AppColors.lightGrey,
              //   ),
              //   child: Row(
              //     children: [
              //       const SizedBox(
              //         width: 20,
              //       ),
              //       SizedBox(
              //         width: 8.w,
              //         height: 8.w,
              //         child: Image.asset("assets/images/coupon.png"),
              //       ),
              //       const Spacer(),
              //       DefaultTextField(
              //         height: 6.h,
              //         width: 65.w,
              //         controller: codeController,
              //         hintText: "Promo Code",
              //         borderColor: AppColors.lightGrey,
              //         textColor: AppColors.darkGrey,
              //         color: AppColors.lightGrey,
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 2.5.h,
              ),
              Container(
                width: 100.w,
                height: 13.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.lightGrey,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultText(
                        text: context.tripDate,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: const BoxDecoration(
                              color: AppColors.midGreen,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(Icons.access_time_filled_outlined,
                                  size: 12.sp, color: AppColors.white),
                            ),
                          ),
                          DefaultText(
                            text:
                                "Day : ${order.data?.orders?.createdAtStr != null ? DateFormat('EEEE').format(DateFormat('yyyy-MM-dd').parse("${order.data?.orders?.createdAtStr}")) : ''}",
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                          ),
                          Container(
                            width: 0.5.w,
                            height: 10.w,
                            margin: EdgeInsets.symmetric(horizontal: 1.w),
                            decoration: BoxDecoration(
                              color: AppColors.grey,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          DefaultText(
                            text:
                                "Date : ${order.data?.orders?.createdAtStr?.substring(0, 10) ?? ''}",
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 2.5.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: DefaultText(
                  text: context.price,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(
                height: 2.5.h,
              ),
              Container(
                width: 35.w,
                height: 35.w,
                decoration: BoxDecoration(
                  color: AppColors.midGreen,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: FittedBox(
                    child: DefaultText(
                      text: "${order.data?.orders?.price ?? ''}\$",
                      fontWeight: FontWeight.w400,
                      textColor: AppColors.white,
                      fontSize: 24.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.5.h,
              ),
              if (order.data?.orders?.captain != null)
                DefaultAppButton(
                  height: 7.h,
                  title: context.callCaptain,
                  textColor: AppColors.white,
                  onTap: () => setState(() {
                    _makePhoneCall(order.data?.orders?.captain?.phone ?? " ");
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
