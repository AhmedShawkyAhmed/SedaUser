// ignore_for_file: use_build_context_synchronously, unused_element

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seda/src/business_logic/global_cubit/global_cubit.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/default_text.dart';
import '../../widgets/toast.dart';

class SafetyView extends StatefulWidget {
  const SafetyView({Key? key}) : super(key: key);

  @override
  State<SafetyView> createState() => _SafetyViewState();
}

class _SafetyViewState extends State<SafetyView> {
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

  List<dynamic> _safetyElements(BuildContext context) => [
        [
          context.reportProblem,
          'assets/images/report_problem.png',
          () {
            showToast('Not available in your country',
                color: AppColors.yellow, textColor: AppColors.black);
          }
        ],
        [
          context.shareYourTrip,
          'assets/images/share1.png',
          () {
            showToast('Not available in your country',
                color: AppColors.yellow, textColor: AppColors.black);
          }
        ],
        [
          context.tripRecording,
          'assets/images/mic1.png',
          () {
            if (!alreadyRecording) {
              Map<String, dynamic> event;
              event = {
                "event": "Trip is recorded",
                "message": 'User started recording the trip',
                "data": {"record": true}
              };
              GlobalCubit.get(context).sendRecordToDriver({
                'room': "${EndPoints.appKey}.users.",
                'to':
                    OrderCubit.get(context).orderModel!.captain!.id!.toString(),
                'data': jsonEncode(event)
              }, context);
              setState(() {
                alreadyRecording = true;
              });
            } else {
              showToast(context.tripIsAlreadyRecording,
                  color: AppColors.yellow);
            }
          }
        ],
        [
          context.callPolice,
          'assets/images/police.png',
          () => setState(() {
                _makePhoneCall('911');
              })
        ],
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 45.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkGrey : AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 1.5.h,
          ),
          Container(
            height: 1.w,
            width: 15.w,
            decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(15)),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.5.h),
            child: DefaultText(
              text: context.toKeepYouSafe,
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  EdgeInsets.only(top: 2.h, bottom: 2.h, right: 10, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    List.generate(_safetyElements(context).length, (index) {
                  return GestureDetector(
                    onTap: _safetyElements(context)[index][2],
                    child: Container(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 12, left: 8, right: 8),
                        decoration: BoxDecoration(
                          color:
                              isDark ? AppColors.darkGrey : AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              _safetyElements(context)[index][1],
                              height: 31,
                              width: 26,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            DefaultText(
                              text: _safetyElements(context)[index][0],
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          ],
                        )),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
