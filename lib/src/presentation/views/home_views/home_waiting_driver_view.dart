import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seda/src/business_logic/global_cubit/global_cubit.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/presentation/views/ride_views/select_ride_view.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/router/app_router_names.dart';
import 'package:seda/src/presentation/views/order_views/waiting_driver_order_view.dart';

class HomeWaitingDriverView extends StatelessWidget {
  const HomeWaitingDriverView({
    super.key,
    required this.time,
    required this.location,
    required this.onDragEnd,
    required this.onDragUpdate,
    required this.expand,
    required this.hours,
    required this.onAdd,
    required this.onMinus,
    required this.updateState,
    required this.makeOrder,
    required this.paymentMethods,
    required this.cancelRideValueNotifier,
    required this.selectRide,
    required this.addDriverMarker,
    required this.removeRequest,
    required this.getDropLocation,
    required this.updateSelect,
    required this.setPolyLine,
    required this.markersValueNotifier,
    required this.controller,
    required this.setMapFitToTour,
    required this.ended,
  });

  final List<String> time;
  final double location;
  final Function(DragEndDetails d) onDragEnd;
  final Function(DragUpdateDetails d) onDragUpdate;
  final bool expand;
  final ValueNotifier<int> hours;
  final Function() onAdd;
  final Function() onMinus;
  final Function() updateState;
  final Function() makeOrder;
  final List<dynamic> Function(BuildContext context) paymentMethods;
  final ValueNotifier<bool> cancelRideValueNotifier;
  final ValueNotifier<bool> selectRide;
  final Function(
    LatLng position,
    String markerId,
    double heading,
    bool to,
  ) addDriverMarker;
  final Function() removeRequest;
  final Function() getDropLocation;
  final Function() updateSelect;
  final Function(
    PointLatLng origin,
    List<PointLatLng> destination,
  ) setPolyLine;
  final ValueNotifier<Map<String, Marker>> markersValueNotifier;
  final GoogleMapController? controller;
  final Function() setMapFitToTour;
  final ValueNotifier<bool> ended;

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is AddNewDropOffSuccess) {
          getDropLocation();
        } else if (state is MakeOrderNoDrivers) {
          updateSelect();
        }
      },
      child: BlocConsumer<GlobalCubit, GlobalState>(
        listener: (context, state) async {
          if (state is CancelAfterArrived ||
              state is NoDriverAcceptedOrFoundedState) {
            removeRequest();
          } else if (state is SocketAcceptOrder) {
            if (state.orderModel != null) {
              OrderCubit.get(context).orderModel = state.orderModel;
              updateState();
            }
          } else if (state is SocketDriverArrived) {
            if (state.orderDModel != null) {
              OrderCubit.get(context).orderModel = state.orderDModel;
              updateState();
            }
          } else if (state is SocketStartOrder) {
            markersValueNotifier.value =
                Map<String, Marker>.of(markersValueNotifier.value)
                  ..remove("pickupMarker");
            if (OrderCubit.get(context).state is AddNewDropOffSuccess) {
              await setPolyLine(
                PointLatLng(GlobalCubit.get(context).liveLocation!.data!.lat!,
                    GlobalCubit.get(context).liveLocation!.data!.lng!),
                toLocations
                    .map(
                      (e) => e == 1
                          ? PointLatLng(toLocationLat, toLocationLon)
                          : e == 2
                              ? PointLatLng(toLocationLat1, toLocationLon1)
                              : PointLatLng(toLocationLat2, toLocationLon2),
                    )
                    .toList(),
              );
              setMapFitToTour();
            }
          } else if (state is SocketEndOrder) {
            if (ended.value == false) {
              ended.value = true;
              resetToLocations();
              showDialog(
                context: context,
                builder: (_) => WillPopScope(
                  child: const LoadingIndicator(),
                  onWillPop: () => Future.value(false),
                ),
              );
              Future.delayed(const Duration(seconds: 2)).then(
                (value) async {
                  if (state.orderModel != null) {
                    OrderCubit.get(context).orderModel = state.orderModel;
                  }
                  final appDir = await getApplicationDocumentsDirectory();
                  final directory = Directory(
                    "${appDir.path}/Seda/Records/${state.orderModel?.id}",
                  );
                  if (directory.existsSync()) {
                    await directory.delete(recursive: true);
                  }
                  GlobalCubit.get(context).resetState();
                  Navigator.popAndPushNamed(
                    context,
                    AppRouterNames.checkout,
                  );
                },
              );
            }
          }
          if (GlobalCubit.get(context).rebuild) {
            GlobalCubit.get(context).rebuild = false;
            if (state is SocketStartOrder) {
              addDriverMarker(
                  LatLng(GlobalCubit.get(context).liveLocation!.data!.lat!,
                      GlobalCubit.get(context).liveLocation!.data!.lng!),
                  'driverMarker',
                  GlobalCubit.get(context).liveLocation!.data!.heading!,
                  true);
            } else {
              addDriverMarker(
                  LatLng(GlobalCubit.get(context).liveLocation!.data!.lat!,
                      GlobalCubit.get(context).liveLocation!.data!.lng!),
                  'driverMarker',
                  GlobalCubit.get(context).liveLocation!.data!.heading!,
                  false);
            }
          }
        },
        builder: (context, state) {
          return ValueListenableBuilder(
              valueListenable: selectRide,
              builder: (context, selectRideVal, child) {
                return selectRideVal
                    ? SelectRideView(
                        time: time,
                        location: location,
                        onDragEnd: onDragEnd,
                        onDragUpdate: onDragUpdate,
                        expand: expand,
                        hours: hours,
                        onAdd: onAdd,
                        onMinus: onMinus,
                        updateState: updateState,
                        makeOrder: makeOrder,
                        paymentMethods: paymentMethods,
                      )
                    : WaitingDriverOrderView(
                        cancelRideValueNotifier: cancelRideValueNotifier,
                      );
              });
        },
      ),
    );
  }
}
