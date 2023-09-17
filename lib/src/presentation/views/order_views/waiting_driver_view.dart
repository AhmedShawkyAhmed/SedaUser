import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/business_logic/global_cubit/global_cubit.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/order_views/driver_offer_view.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

import 'collecting_driver_data_view.dart';

class WaitingDriverView extends StatelessWidget {
  const WaitingDriverView({Key? key, required this.cancelOrder})
      : super(key: key);

  final Function() cancelOrder;
  @override
  Widget build(BuildContext context) {
    printSuccess("shipmentTypeId waiting: $shipmentTypeId");
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 2.h),
        // height: 20.h,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkGrey : AppColors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(3, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (shipmentTypeId == 3)
              Padding(
                padding: EdgeInsets.only(bottom: 15, left: 7.w, right: 7.w),
                child: Column(
                  children: [
                    DefaultText(
                      text: context.driversOffer,
                      fontSize: 13.sp,
                    ),
                    SizedBox(
                      height: 40.h,
                      child: BlocBuilder<GlobalCubit, GlobalState>(
                        builder: (context, state) {
                          final cubit = GlobalCubit.get(context);
                          return cubit.diversOffers.isNotEmpty
                              ? ListView.separated(
                                  itemCount: cubit.diversOffers.length,
                                  itemBuilder: (context, index) =>
                                      DriverOfferView(
                                    driverOffer: cubit.diversOffers[index],
                                    confirmOffer: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => WillPopScope(
                                          onWillPop: () => Future.value(
                                            false,
                                          ),
                                          child: const LoadingIndicator(),
                                        ),
                                      );
                                      OrderCubit.get(context)
                                          .confirmDriverOffer(
                                        orderSentToDriverId: cubit
                                            .diversOffers[index]
                                            .order_sent_to_driver_id!,
                                        afterSuccess: () {
                                          GlobalCubit.get(context)
                                              .onAcceptDriverOffer(
                                                  cubit.diversOffers[index]);
                                          Navigator.pop(context);
                                        },
                                        afterError: () =>
                                            Navigator.pop(context),
                                      );
                                    },
                                  ),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: 2.h,
                                  ),
                                )
                              : Center(
                                  child: DefaultText(
                                    text: context.waitDriverOffer,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            if (shipmentTypeId != 3)
              CollectingDriverDataScreen(
                cancelOrder: cancelOrder,
              )
          ],
        ),
      ),
    );
  }
}
