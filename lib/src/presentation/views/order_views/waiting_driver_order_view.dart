import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/business_logic/global_cubit/global_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/order_views/cancel_views/cancel_ride_view.dart';
import 'package:seda/src/presentation/views/order_views/just_go_order_view.dart';
import 'package:seda/src/presentation/views/order_views/waiting_driver_view.dart';
import 'package:sizer/sizer.dart';

class WaitingDriverOrderView extends StatelessWidget {
  const WaitingDriverOrderView({
    super.key,
    required this.cancelRideValueNotifier,
  });

  final ValueNotifier<bool> cancelRideValueNotifier;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        final cubit = GlobalCubit.get(context);
        return Stack(
          children: [
            if (state is SocketStartOrder ||
                state is UserLiveTracking ||
                state is SocketEndOrder)
              if (shipmentTypeId == 2 || shipmentTypeId == 6)
                JustGoOrderView(
                  key: const ValueKey(2),
                  cancelOrder: () {
                    cancelRideValueNotifier.value = true;
                  },
                  started: true,
                  driverArrived: false,
                ),
            ValueListenableBuilder<bool>(
              valueListenable: cancelRideValueNotifier,
              builder: (context, cancelRide, child) {
                if (((state is SocketAcceptOrder ||
                            state is SocketNewMessage ||
                            state is SocketDriverArrived) &&
                        cancelRide == false) &&
                    (shipmentTypeId == 2 || shipmentTypeId == 6)) {
                  return JustGoOrderView(
                    key: const ValueKey(1),
                    cancelOrder: () {
                      cancelRideValueNotifier.value = true;
                    },
                    started: false,
                    driverArrived: cubit.driverArrived,
                  );
                }
                if ((state is! SocketAcceptOrder &&
                        state is! SocketDriverArrived &&
                        state is! SocketStartOrder &&
                        state is! UserLiveTracking &&
                        state is! SocketEndOrder &&
                        state is! SocketNewMessage) &&
                    cancelRide == false) {
                  return WaitingDriverView(
                    cancelOrder: () {
                      cancelRideValueNotifier.value = true;
                    },
                  );
                }
                if (cancelRide == true &&
                    ((state is SocketAcceptOrder) ||
                        (state is! SocketStartOrder &&
                            state is! SocketAcceptOrder))) {
                  return CancelRideView(
                    updateCancel: () {
                      cancelRideValueNotifier.value = false;
                    },
                    accepted: state is SocketAcceptOrder,
                    driverArrived: cubit.driverArrived,
                  );
                }
                return const SizedBox();
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: cancelRideValueNotifier,
              builder: (context, cancelRide, child) {
                if (cancelRide == true &&
                    ((state is SocketAcceptOrder) ||
                        (state is! SocketStartOrder &&
                            state is! SocketAcceptOrder))) {
                  return Positioned(
                    top: 5.h,
                    left: 5.w,
                    child: Material(
                      type: MaterialType.circle,
                      color: isDark ? AppColors.darkGrey : AppColors.white,
                      child: InkWell(
                        onTap: () {
                          cancelRideValueNotifier.value = false;
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            size: 26,
                            color:
                                isDark ? AppColors.white : AppColors.darkGrey,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        );
      },
    );
  }
}
