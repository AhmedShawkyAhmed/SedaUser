import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/business_logic/govern_cubit/govern_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/data/models/reponse_models/govern_response_model.dart';
import 'package:seda/src/data/models/request_models/apply_shared_order_request_model.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/government_views/location_view_bottom_sheet.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class GovernRideDetailsScreen extends StatefulWidget {
  const GovernRideDetailsScreen({
    Key? key,
    required this.trip,
  }) : super(key: key);

  final Order trip;

  @override
  State<GovernRideDetailsScreen> createState() =>
      _GovernRideDetailsScreenState();
}

class _GovernRideDetailsScreenState extends State<GovernRideDetailsScreen> {
  var _listSize = 0;

  initTripDetails() {
    if (widget.trip.points?.isEmpty == true) {
      _listSize = 2;
    } else {
      _listSize = widget.trip.points!.length + 2;
    }
  }

  @override
  void initState() {
    super.initState();
    initTripDetails();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GovernCubit, GovernState>(
      listener: (context, state) {
        if (state is ApplySharedOrderLoadingState) {
          showDialog(
            context: context,
            builder: (_) => WillPopScope(
              child: const LoadingIndicator(),
              onWillPop: () => Future.value(false),
            ),
          );
        } else if (state is ApplySharedOrderSuccessState) {
          Navigator.pop(context);
        } else if (state is ApplySharedOrderFailureState) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkGrey : AppColors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 12.h,
              width: double.infinity,
              padding: EdgeInsets.only(top: 2.5.h),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.lightGreen,
                    AppColors.green,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 32,
                        color: AppColors.white,
                      )),
                  DefaultText(
                    text: widget.trip.driver?.name ?? '_',
                    textColor: AppColors.white,
                    fontSize: 20.sp,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        DefaultText(
                          text: context.valid(widget.trip.valid.toString()),
                          textColor: AppColors.green,
                        ),
                        const Spacer(),
                        DefaultText(
                          text: context.status(widget.trip.status.toString()),
                          textColor: AppColors.green,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    DefaultText(
                      text: context.activePassengers(
                        widget.trip.passenger?.length.toString() ?? '',
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 7.w, bottom: 1.h),
                      width: 100.w,
                      child: DefaultText(
                        text: context.startPoint,
                        fontSize: 11.sp,
                        textColor: AppColors.green,
                      ),
                    ),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) => Row(
                        children: [
                          index == 0
                              ? Container(
                                  width: 5.w,
                                  height: 5.w,
                                  margin: const EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.grey,
                                    borderRadius: BorderRadius.circular(
                                      50,
                                    ),
                                  ),
                                )
                              : index == _listSize - 1
                                  ? Container(
                                      width: 5.w,
                                      height: 5.w,
                                      margin: const EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                        color: AppColors.midGreen,
                                        borderRadius: BorderRadius.circular(
                                          3,
                                        ),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.location_on,
                                      color: AppColors.green,
                                      size: 30,
                                    ),
                          SizedBox(
                            width: 1.h,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: DefaultText(
                                    text: (index == 0
                                            ? widget.trip.fromLocation?.address
                                            : index == _listSize - 1
                                                ? widget
                                                    .trip.toLocation?.address
                                                : widget.trip.points?[index - 1]
                                                    .address) ??
                                        '----',
                                    fontSize: 13.sp,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    final latitude = index == 0
                                        ? widget.trip.fromLocation?.latitude
                                        : index == _listSize - 1
                                            ? widget.trip.toLocation?.latitude
                                            : widget.trip.points?[index - 1]
                                                .latitude;
                                    final longitude = index == 0
                                        ? widget.trip.fromLocation?.longitude
                                        : index == _listSize - 1
                                            ? widget.trip.toLocation?.longitude
                                            : widget.trip.points?[index - 1]
                                                .longitude;
                                    showModalBottomSheet(
                                      isDismissible: false,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) =>
                                          LocationViewBottomSheet(
                                        latitude: latitude ?? 0.00000,
                                        longitude: longitude ?? 0.00000,
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.location_on,
                                    color: AppColors.green,
                                    size: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      separatorBuilder: (context, index) => Row(
                        children: [
                          Container(
                            width: 1.5.w,
                            height: 6.h,
                            margin: EdgeInsets.only(
                              left: 3.w,
                              right: 1.5.w,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.grey,
                              borderRadius: BorderRadius.circular(
                                3,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 1.h,
                          ),
                          Expanded(
                            child: DefaultText(
                              text: index != _listSize - 2
                                  ? context.stopPoint((widget.trip.points!
                                              .indexWhere((element) =>
                                                  element.id ==
                                                  widget
                                                      .trip.points?[index].id) +
                                          1)
                                      .toString())
                                  : context.endPoint(),
                              fontSize: 11.sp,
                              textColor: AppColors.green,
                            ),
                          ),
                        ],
                      ),
                      itemCount: _listSize,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    DefaultAppButton(
                      title: context.reserveTrip,
                      onTap: () {
                        final cubit = GovernCubit.get(context);
                        final requestModel = ApplySharedOrderRequestModel(
                          widget.trip.id!,
                          5,
                          1037,
                          1038,
                        );
                        cubit.applySharedOrder(requestModel);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
