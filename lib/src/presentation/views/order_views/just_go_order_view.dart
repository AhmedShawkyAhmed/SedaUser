import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seda/src/business_logic/global_cubit/global_cubit.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/order_views/just_go_extended_view.dart';
import 'package:seda/src/presentation/views/order_views/safety_view.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:seda/src/presentation/widgets/default_text_field.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/end_points.dart';
import '../../router/app_router_names.dart';

class JustGoOrderView extends StatefulWidget {
  const JustGoOrderView(
      {Key? key,
      required this.cancelOrder,
      required this.started,
      required this.driverArrived})
      : super(key: key);
  final Function() cancelOrder;
  final bool started;
  final bool driverArrived;

  @override
  State<JustGoOrderView> createState() => _JustGoOrderViewState();
}

class _JustGoOrderViewState extends State<JustGoOrderView>
    with TickerProviderStateMixin {
  bool expand = false;
  bool animationEnded = false;

  bool safetyAnimate = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    animationEnded = true;

    setState(() {
      defaultHeight = widget.started ? 40.h : 47.h;
      location = defaultHeight;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _countDownTimer?.cancel();
    super.dispose();
  }

  Timer? _countDownTimer;
  int _time = 300;

  String _getTimer(int timeInSeconds) {
    final min = (timeInSeconds ~/ 60).toString().padLeft(2, '0');
    final sec = (timeInSeconds % 60).toString().padLeft(2, '0');
    final time = '$min : $sec';
    return time;
  }

  void _initializeTimer() {
    _countDownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (mounted) {
          setState(() {
            if (_time == 0) {
              _countDownTimer?.cancel();
              _time = 300;
            } else {
              _time--;
            }
          });
        }
      },
    );
  }

  @override
  void didUpdateWidget(dynamic oldWidget) {
    super.didUpdateWidget(oldWidget);
    defaultHeight = widget.started ? 40.h : 47.h;
  }

  bool changeView = false;

  _onDragEnd(DragEndDetails details) {
    printError("${details.primaryVelocity}");
    final toLocations = OrderCubit.get(context).orderModel!.toLocation!;
    if (details.primaryVelocity != 0) {
      if (height > 10.h && !expand) {
        expand = true;
        animationEnded = false;
        location = 78.h + (3.h * toLocations.length);
        setState(() {});
      } else if (height < (80.h + (3.h * toLocations.length))) {
        expand = false;
        animationEnded = true;
        location = defaultHeight;
        setState(() {});
      }
      opacity = 1;
    } else {
      if (location > defaultHeight && !expand) {
        location = 78.h + (3.h * toLocations.length);
        expand = true;
        animationEnded = false;
        opacity = 1;
        setState(() {});
      } else if (location < (78.h + (3.h * toLocations.length)) && expand) {
        location = defaultHeight;
        expand = false;
        animationEnded = true;
        opacity = 1;
        setState(() {});
      }
    }
  }

  _onDragUpdate(DragUpdateDetails details) {
    height =
        (MediaQuery.of(context).size.height - details.globalPosition.dy).abs();
    setState(() {
      printSuccess("${details.primaryDelta}");
      if (height > defaultHeight &&
          height < 80.h &&
          (details.primaryDelta != 0.0)) {
        opacity =
            location < 60.h ? (1 - (location / 60.h)) : ((location / 60.h) - 1);
        location = height;

        setState(() {});
      }
    });
  }

  double height = 0;

  double location = 47.h;

  double defaultHeight = 47.h;

  double opacity = 1;

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

  int select = 0;

  String safetyItem = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<GlobalCubit, GlobalState>(
      listener: (context, state) {
        if (state is SocketDriverArrived) {
          _initializeTimer();
        }
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 100.w,
              height: location,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(35),
                ),
                color: isDark ? AppColors.darkGrey : AppColors.white,
              ),
              child: GestureDetector(
                onVerticalDragEnd: _onDragEnd,
                onVerticalDragUpdate: _onDragUpdate,
                child: AnimatedSwitcher(
                  key: ValueKey(expand),
                  duration: const Duration(milliseconds: 600),
                  child: expand
                      ? JustGoExtendedView(
                          started: widget.started,
                          opacity: opacity,
                          cancelOrder: widget.cancelOrder,
                        )
                      : AnimatedOpacity(
                          opacity: opacity,
                          duration: const Duration(milliseconds: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                ),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(35),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 1.5.h,
                                    ),
                                    Container(
                                      height: 1.w,
                                      width: 15.w,
                                      decoration: BoxDecoration(
                                          color: AppColors.lightGrey,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    SizedBox(
                                      height: 1.3.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              DefaultText(
                                                text:
                                                    "${OrderCubit.get(context).orderModel?.vehicle?.vehicleTypesCompany ?? ''} ${OrderCubit.get(context).orderModel?.vehicle?.vehicleTypesType ?? ''}  ${OrderCubit.get(context).orderModel?.vehicle?.vehicleTypesModel ?? ''} ",
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.sp,
                                                textColor: AppColors.white,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: AppColors.white,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9)),
                                                child: DefaultText(
                                                  text: OrderCubit.get(context)
                                                          .orderModel
                                                          ?.vehicle
                                                          ?.carNumber ??
                                                      "",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13.sp,
                                                  textColor: AppColors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            DefaultText(
                                              text: !widget.started
                                                  ? widget.driverArrived
                                                      ? context.driverWaiting
                                                      : context.remainingTime
                                                  : context.tripTime,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 8.sp,
                                              textColor: AppColors.white,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 12),
                                              decoration: BoxDecoration(
                                                  color: AppColors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(9)),
                                              child: Column(
                                                children: [
                                                  DefaultText(
                                                    text: widget.driverArrived
                                                        ? _getTimer(_time)
                                                        : (OrderCubit.get(
                                                                    context)
                                                                .orderModel
                                                                ?.timeTaken ??
                                                            " "),
                                                    align: TextAlign.center,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13.sp,
                                                    maxLines: 2,
                                                    textColor:
                                                        AppColors.darkGrey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3.5.h,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 4.h),
                                            child: Stack(
                                              children: [
                                                Image.asset(
                                                  'assets/images/carRed1.png',
                                                  // height: 60,
                                                  // width: 100,
                                                  color:
                                                      const Color(0xffff0000),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if (OrderCubit.get(
                                                                  context)
                                                              .orderModel
                                                              ?.captain !=
                                                          null) {
                                                        Navigator.pushNamed(
                                                            context,
                                                            AppRouterNames
                                                                .captainProfile,
                                                            arguments:
                                                                OrderCubit.get(
                                                                        context)
                                                                    .orderModel
                                                                    ?.captain);
                                                      }
                                                    },
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Container(
                                                          width: 5.5.h,
                                                          height: 5.5.h,
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          clipBehavior: Clip
                                                              .antiAliasWithSaveLayer,
                                                          child: OrderCubit.get(
                                                                          context)
                                                                      .orderModel
                                                                      ?.captain
                                                                      ?.image ==
                                                                  null
                                                              ? Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(5
                                                                              .w),
                                                                  child:
                                                                      const FittedBox(
                                                                    child: Icon(
                                                                      Icons
                                                                          .person,
                                                                      color: AppColors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Image.network(
                                                                  "${EndPoints.imageBaseUrl}${OrderCubit.get(context).orderModel?.captain?.image}",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        8),
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 40),
                                                            decoration: BoxDecoration(
                                                                color: AppColors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50)),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .star_rounded,
                                                                  color: AppColors
                                                                      .yellow,
                                                                  size: 11.sp,
                                                                ),
                                                                const SizedBox(
                                                                  width: 4,
                                                                ),
                                                                DefaultText(
                                                                  text:
                                                                      "(${OrderCubit.get(context).orderModel?.captain?.rate ?? 0})",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      9.sp,
                                                                  textColor:
                                                                      AppColors
                                                                          .darkGrey,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              DefaultText(
                                                text: OrderCubit.get(context)
                                                        .orderModel
                                                        ?.captain
                                                        ?.name ??
                                                    " ",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.sp,
                                              ),
                                              // const SizedBox(
                                              //   height: 8,
                                              // ),
                                              // DefaultText(
                                              //   text: OrderCubit.get(context)
                                              //       .orderModel
                                              //       ?.captain
                                              //       ?.email ??
                                              //       " ",
                                              //   align: TextAlign.center,
                                              //   fontWeight: FontWeight.w300,
                                              //   fontSize: 10.sp,
                                              //   textColor: isDark
                                              //       ? AppColors.lightGrey
                                              //       : AppColors.grey,
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if (!widget.started)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            DefaultTextField(
                                              controller: controller,
                                              hintText: context
                                                  .anyNotesOnTheMeetingPoint,
                                              height: 5.h,
                                              width: 75.w,
                                              radius: 50,
                                              readOnly: true,
                                              // padding: const EdgeInsets.only(
                                              //   bottom: 8,
                                              // ),
                                              color: AppColors.lightGrey,
                                              borderColor: AppColors.lightGrey,
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    AppRouterNames.chat);
                                              },
                                            ),
                                            GestureDetector(
                                              onTap: () => setState(() {
                                                _makePhoneCall(
                                                    OrderCubit.get(context)
                                                            .orderModel
                                                            ?.captain
                                                            ?.phone ??
                                                        " ");
                                              }),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: AppColors.lightGrey,
                                                ),
                                                child: SvgPicture.asset(
                                                  'assets/images/phone.svg',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      SizedBox(
                                        height: 1.7.h,
                                      ),
                                      Container(
                                        height: 3.h,
                                        color: AppColors.lightGrey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
          if (animationEnded && widget.started)
            Align(
              alignment:
                  context.isAr ? Alignment.bottomRight : Alignment.bottomLeft,
              child: AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(milliseconds: 20),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: location + 10,
                    left: 20,
                    right: 20,
                  ),
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet<dynamic>(
                        isScrollControlled: true,
                        backgroundColor: AppColors.transparent,
                        context: context,
                        builder: (BuildContext bc) {
                          return const SafetyView();
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkGrey : AppColors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.darkGrey.withOpacity(0.2),
                              spreadRadius: 4,
                              blurRadius: 2)
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shield_rounded,
                            size: 26,
                            color: isDark
                                ? AppColors.lightGrey
                                : AppColors.primary,
                          ),
                          DefaultText(
                            text: safetyItem,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
