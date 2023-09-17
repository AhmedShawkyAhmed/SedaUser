// ignore_for_file: unused_field

import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/menu_screens_views/add_card_view.dart';
import 'package:seda/src/presentation/views/scooter_views/scooter_trip_summary_view.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class ScooterTripScreen extends StatefulWidget {
  const ScooterTripScreen({Key? key}) : super(key: key);

  @override
  State<ScooterTripScreen> createState() => _ScooterTripScreenState();
}

class _ScooterTripScreenState extends State<ScooterTripScreen> {
  final CountDownController _controller = CountDownController();

  final pController = PageController();

  Duration duration = const Duration();
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => incTimer());
  }

  void incTimer() {
    const addSecond = 1;
    setState(() {
      var seconds = duration.inSeconds + addSecond;
      if (seconds <= 180) {
        duration = Duration(seconds: seconds);
      } else {
        resetTimer();
      }
    });
  }

  void stopTimer() {
    setState(() => timer!.cancel());
  }

  void resetTimer() {
    stopTimer();
    setState(() => duration = const Duration(seconds: 1));
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stopTimer();
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 300,
                width: 300,
                margin: const EdgeInsets.only(
                    top: 70, bottom: 16, right: 40, left: 40),
                decoration: BoxDecoration(
                    color: const Color(0xFF68FED4).withOpacity(0.44),
                    borderRadius: BorderRadius.circular(1000)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 88, right: 80),
                child: Image.asset(
                  'assets/images/scooterRide.png',
                  scale: 1.15,
                ),
              ),
            ],
          ),
          Container(
            height: 500,
            padding: EdgeInsets.only(
              top: 5.h,
              right: 15.w,
              left: 15.w,
            ),
            decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // CircularCountDownTimer(
                  //   duration: 180,
                  //   initialDuration: 0,
                  //   controller: _controller,
                  //   width: 50.w,
                  //   height: 50.w,
                  //   ringColor: AppColors.white,
                  //   fillColor: AppColors.lightGreen,
                  //   backgroundColor: AppColors.white,
                  //   strokeWidth: 5.0,
                  //   strokeCap: StrokeCap.round,
                  //   textStyle: TextStyle(
                  //     fontSize: 20.sp,
                  //     color: AppColors.darkGrey,
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  //   textFormat: CountdownTextFormat.HH_MM_SS,
                  //   isTimerTextShown: true,
                  //   autoStart: true,
                  //   onStart: () {
                  //     debugPrint('Countdown Started');
                  //   },
                  //   onComplete: () {
                  //     debugPrint('Countdown Ended');
                  //   },
                  // ),
                  DefaultText(
                    text: context.yourTrip,
                    textColor: AppColors.darkGrey,
                    fontSize: 25.sp,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Calibri',
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 93,
                            width: 123,
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColors.grey.withOpacity(0.2),
                                      offset: const Offset(1, 1),
                                      blurRadius: 2,
                                      spreadRadius: 1)
                                ]),
                            alignment: Alignment.center,
                            child: DefaultText(
                              text: minutes,
                              textColor: AppColors.darkGrey,
                              fontSize: 25.sp,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          DefaultText(
                            text: context.minutes,
                            textColor: AppColors.darkGrey,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          DefaultText(
                            text: ':',
                            textColor: AppColors.darkGrey,
                            fontSize: 30.sp,
                            height: 1.35,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          DefaultText(
                            text: '',
                            textColor: AppColors.darkGrey,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 93,
                            width: 123,
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColors.grey.withOpacity(0.2),
                                      offset: const Offset(1, 1),
                                      blurRadius: 2,
                                      spreadRadius: 1)
                                ]),
                            alignment: Alignment.center,
                            child: DefaultText(
                              text: seconds,
                              textColor: AppColors.darkGrey,
                              fontSize: 25.sp,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          DefaultText(
                            text: context.seconds,
                            textColor: AppColors.darkGrey,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  DefaultAppButton(
                    width: 33.w,
                    height: 5.h,
                    title: context.recharge,
                    fontFamily: 'Calibri',
                    fontWeight: FontWeight.w400,
                    fontSize: 17.sp,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (builder) {
                          return const AddCardView();
                        },
                      );
                    },
                    isGradient: false,
                    buttonColor: AppColors.darkGrey,
                  ),
                  SizedBox(
                    height: 3.5.h,
                  ),
                  DefaultAppButton(
                    title: context.endTrip,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (builder) {
                          return const ScooterTripSummaryView();
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
