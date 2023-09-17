// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as toolkit;
import 'package:seda/src/business_logic/app_cubit/app_cubit.dart';
import 'package:seda/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda/src/business_logic/global_cubit/global_cubit.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/business_logic/wallet_cubit/wallet_cubit.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/constants/shared_preference_keys.dart';
import 'package:seda/src/constants/tools/log_util.dart';
import 'package:seda/src/data/data_provider/local/cache_helper.dart';
import 'package:seda/src/data/data_provider/remote/dio_helper.dart';
import 'package:seda/src/data/models/order_model.dart';
import 'package:seda/src/data/models/reponse_models/google_map_directions_reponse/google_map_directions_reponse.dart';
import 'package:seda/src/data/models/request_models/make_order_request.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/notifications/notification_service.dart';
import 'package:seda/src/presentation/router/app_router_names.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/home_views/home_above_sheet.dart';
import 'package:seda/src/presentation/views/home_views/home_bottom_view.dart';
import 'package:seda/src/presentation/views/home_views/home_waiting_driver_view.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/widgets/toast.dart';
import 'package:sizer/sizer.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.orderProcessing}) : super(key: key);

  final OrderModel? orderProcessing;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  SnappingSheetController snappingSheetController = SnappingSheetController();
  GoogleMapController? _controller;
  late final NotificationService service;
  late ValueNotifier<Map<String, Marker>> _markersValueNotifier;
  late ValueNotifier<double> _markerPaddingValueNotifier;
  late ValueNotifier<bool> _mapTypeValueNotifier;
  LatLng? _lastMapPosition;
  final ValueNotifier<bool> _showWhereTo = ValueNotifier(false);
  final ValueNotifier<bool> _fav = ValueNotifier(false);
  bool myLocation = false;
  final ValueNotifier<bool> _getLoc = ValueNotifier(false);
  Timer markerTimer = Timer(const Duration(), () {});
  Timer mainMarkerTimer = Timer(const Duration(), () {});

  late ValueNotifier<Set<Polyline>> _polylineValueNotifier;
  late ValueNotifier<bool> _cancelRideValueNotifier;
  GoogleMapDirections? _directions;
  bool _started = false;
  late final ValueNotifier<bool> _selectRide;
  final ValueNotifier<bool> _ended = ValueNotifier(false);
  int select = 0;
  final ValueNotifier<int> _hours = ValueNotifier(1);
  bool run = true;
  bool expand = false;
  double location = 64.h;
  double height = 0;

  void addMarker(
    LatLng position,
    String markerId, {
    BitmapDescriptor? markerIcon,
  }) async {
    BitmapDescriptor icon = markerIcon ??
        BitmapDescriptor.fromBytes(
          (await getBytesFromAsset(
            'assets/images/myLocation.png',
            Platform.isIOS ? 60.sp.toInt() : 40,
          )),
        );
    final marker = Marker(
      markerId: MarkerId(markerId),
      icon: icon,
      position: position,
    );
    _markersValueNotifier.value =
        Map<String, Marker>.from(_markersValueNotifier.value)
          ..removeWhere((key, value) => value.markerId.value == markerId)
          ..["fromLocation"] = marker;
    getAddress();
  }

  Future<void> _getMyLocation() async {
    await getMyLocation(
      (location, address) async {
        _controller?.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                location.latitude,
                location.longitude,
              ),
              zoom: 18,
            ),
          ),
        );
        addMarker(
          LatLng(location.latitude, location.longitude),
          "fromLocation",
        );

        fromLocationAddressController.text = address;
        fromLocationLat = location.latitude;
        fromLocationLon = location.longitude;
        printResponse(
          "FromLocationAddress: ${fromLocationAddressController.text}",
        );
      },
    );
  }

  Future<void> getAddress() async {
    if (_lastMapPosition != null) {
      await getLatLngDetails(
        lat: _lastMapPosition!.latitude,
        lon: _lastMapPosition!.longitude,
        afterSuccess: (data) async {
          switch (toLocations[0]) {
            case 1:
              toLocationLat = _lastMapPosition!.latitude;
              toLocationLon = _lastMapPosition!.longitude;
              toLocationAddressController.text = "${data.houseNumber ?? ''} "
                  "${data.road ?? ''} "
                  "${data.neighbourhood ?? ''} "
                  "${data.state ?? ''} "
                  "${data.country ?? ''}";
              break;
            case 2:
              toLocationLat1 = _lastMapPosition!.latitude;
              toLocationLon1 = _lastMapPosition!.longitude;
              toLocationAddressController1.text = "${data.houseNumber ?? ''} "
                  "${data.road ?? ''} "
                  "${data.neighbourhood ?? ''} "
                  "${data.state ?? ''} "
                  "${data.country ?? ''}";
              break;
            case 3:
              toLocationLat2 = _lastMapPosition!.latitude;
              toLocationLon2 = _lastMapPosition!.longitude;
              toLocationAddressController2.text = "${data.houseNumber ?? ''} "
                  "${data.road ?? ''} "
                  "${data.neighbourhood ?? ''} "
                  "${data.state ?? ''} "
                  "${data.country ?? ''}";
              break;
          }
          _markerPaddingValueNotifier.value = 0.0;
          printResponse(
              "ToLocationAddress${toLocations[0]}: ${toLocationAddressController.text}");
        },
      );
    }
  }

  void _onCameraMove(CameraPosition position) {
    _markerPaddingValueNotifier.value = 3.0;
    _lastMapPosition = position.target;
  }

  void addCarMarker(LatLng position, String id, rotation) async {
    final Uint8List markerIcon =
        await getCarMarkerBytesFromAsset('assets/images/car_green.png', 40);

    BitmapDescriptor icon = BitmapDescriptor.fromBytes(markerIcon);
    final marker = Marker(
        flat: true,
        markerId: MarkerId(id),
        icon: icon,
        position: position,
        rotation: rotation);
    _markersValueNotifier.value =
        Map<String, Marker>.from(_markersValueNotifier.value)
          ..removeWhere((key, val) => key == id)
          ..[id] = marker;
  }

  _startMyLocation(double plus) {
    try {
      myLocation = true;
      getMyLocation((location, address) {
        var lat = location.latitude;
        var lng = location.longitude;
        List<LatLng> positionList = [];
        List<double> rotations = List.filled(9, 0);
        positionList.add(LatLng(lat - Random().nextDouble() * .0074458,
            lng - Random().nextDouble() * .0057458));
        positionList.add(LatLng(lat + Random().nextDouble() * .0057458,
            lng + Random().nextDouble() * .0057458));
        positionList.add(LatLng(lat - Random().nextDouble() * .0077458,
            lng - Random().nextDouble() * .0077458));
        positionList.add(LatLng(lat + Random().nextDouble() * .0057458,
            lng - Random().nextDouble() * .0077458));
        positionList.add(LatLng(lat + Random().nextDouble() * .0057458,
            lng - Random().nextDouble() * .0077458));
        positionList.add(LatLng(lat + Random().nextDouble() * .0047458,
            lng - Random().nextDouble() * .0067458));
        positionList.add(LatLng(lat - Random().nextDouble() * .0017458,
            lng + Random().nextDouble() * .0057458));
        positionList.add(LatLng(lat - Random().nextDouble() * .0067458,
            lng + Random().nextDouble() * .0057458));
        positionList.add(LatLng(lat - Random().nextDouble() * .0057458,
            lng - Random().nextDouble() * .0067458));
        addCarMarker(positionList[0], '0', 180.0);
        addCarMarker(positionList[1], '1', 90.0);
        addCarMarker(positionList[2], '2', 180.0);
        addCarMarker(positionList[3], '3', 360.0);
        addCarMarker(positionList[4], '4', 360.0);
        addCarMarker(positionList[5], '5', 180.0);
        addCarMarker(positionList[6], '6', 270.0);
        addCarMarker(positionList[6], '7', 270.0);
        addCarMarker(positionList[6], '8', 180.0);
        mainMarkerTimer = Timer.periodic(
          const Duration(seconds: 60),
          (timer) {
            final rand1 = Random().nextInt(9);
            final rand2 = Random().nextInt(9);
            final rand3 = Random().nextInt(9);
            final rand4 = Random().nextInt(9);
            final rand5 = Random().nextInt(9);
            var random = {rand1, rand2, rand3, rand4, rand5};
            for (var i in random) {
              rotations[i] = Random().nextInt(4) * 90.0;
            }
            markerTimer = Timer.periodic(
              const Duration(milliseconds: 100),
              (timer) {
                if (timer.tick == 200) {
                  markerTimer.cancel();
                  plus = 0.0;
                  return;
                }
                plus += .000008;
                for (var i in rotations) {
                  if (i == 0) {
                    addCarMarker(
                        LatLng(
                            positionList[rotations.indexOf(i)].latitude + plus,
                            positionList[rotations.indexOf(i)].longitude),
                        '${rotations.indexOf(i)}',
                        0.0);
                  } else if (i == 90) {
                    addCarMarker(
                        LatLng(
                            positionList[rotations.indexOf(i)].latitude,
                            positionList[rotations.indexOf(i)].longitude +
                                plus),
                        '${rotations.indexOf(i)}',
                        i);
                  } else if (i == 180) {
                    addCarMarker(
                        LatLng(
                            positionList[rotations.indexOf(i)].latitude - plus,
                            positionList[rotations.indexOf(i)].longitude),
                        '${rotations.indexOf(i)}',
                        i);
                  } else {
                    addCarMarker(
                        LatLng(
                            positionList[rotations.indexOf(i)].latitude,
                            positionList[rotations.indexOf(i)].longitude -
                                plus),
                        '${rotations.indexOf(i)}',
                        i);
                  }
                }
              },
            );
          },
        );
      });
    } catch (e) {
      printError('FakeCars Error:  $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    dev.log("$state", name: "HomeStateObserver");
    switch (state) {
      case AppLifecycleState.resumed:
        if (waitingDriverToggleView.value) {
          OrderCubit.get(context).getLastOrderStatus(
            afterSuccess: (order) {
              if (order != null) {
                switch (order.status) {
                  case "start":
                    if (GlobalCubit.get(context).state is! SocketStartOrder) {
                      GlobalCubit.get(context).emitState(SocketStartOrder());
                    } else {
                      setState(() {});
                    }
                    break;
                  case "accept":
                    if (GlobalCubit.get(context).state is! SocketAcceptOrder) {
                      GlobalCubit.get(context).emitState(
                        SocketAcceptOrder(
                          orderModel: order,
                        ),
                      );
                    } else {
                      setState(() {});
                    }
                    break;
                  case "end":
                    if (select > 0) {
                    } else if (select == 0) {
                      _removeRequest();
                      waitingDriverToggleView.value = false;
                    } else {
                      Navigator.pushNamed(context, AppRouterNames.checkout);
                    }
                    break;
                  case "arrived":
                    if (GlobalCubit.get(context).state
                        is! SocketDriverArrived) {
                      GlobalCubit.get(context).emitState(
                        SocketDriverArrived(
                          orderDModel: order,
                        ),
                      );
                    } else {
                      setState(() {});
                    }
                    break;
                  case "cancelled":
                    waitingDriverToggleView.value = false;
                    break;
                  case "partially_cancelled":
                    GlobalCubit.get(context).resetState();
                    break;
                  default:
                    break;
                }
              }
            },
          );
        }
        break;
      default:
        break;
    }
  }

  Future _fetchMapStyle() async {
    if (isDark) {
      final theme = await DefaultAssetBundle.of(context)
          .loadString('assets/map/mapDarkTheme.json');
      mapTheme = theme;
    } else {
      final theme = await DefaultAssetBundle.of(context)
          .loadString('assets/map/mapLightTheme.json');
      mapTheme = theme;
    }
    _setMapStyle();
  }

  Future _setMapStyle() async {
    _controller?.setMapStyle(mapTheme);
  }

  @override
  void initState() {
    _markersValueNotifier = ValueNotifier(<String, Marker>{});
    _polylineValueNotifier = ValueNotifier(<Polyline>{});
    _markerPaddingValueNotifier = ValueNotifier(0.0);
    _mapTypeValueNotifier = ValueNotifier(false);
    _cancelRideValueNotifier = ValueNotifier(false);
    _fetchMapStyle();
    _selectRide = ValueNotifier(OrderCubit.get(context).orderModel == null);
    WidgetsBinding.instance.addObserver(this);
    waitingDriverToggleView.addListener(() async {
      _markersValueNotifier.value =
          Map<String, Marker>.of(_markersValueNotifier.value)..clear();
      _polylineValueNotifier.value =
          Set<Polyline>.of(_polylineValueNotifier.value)..clear();
      if (waitingDriverToggleView.value) {
        mainMarkerTimer.cancel();
        markerTimer.cancel();
        await _initWaitingDriver();
      } else {
        _ended.value = false;
        _cancelRideValueNotifier.value = false;
        _time.clear();
        await _getMyLocation();
        await _startMyLocation(0.0);
      }
    });
    var plus = 0.0;
    _getMyLocation().then((value) {
      if (OrderCubit.get(context).orderModel == null) {
        _startMyLocation(plus);
      }
    });
    printResponse("UserToken: ${CacheHelper.getDataFromSharedPreference(
      key: SharedPreferenceKeys.userToken,
    )}");
    // LocationCubit.get(context)
    //   ..getFavouriteLocations()
    //   ..getRecentLocations();
    AuthCubit.get(context).getProfile(
        onSuccess: () => GlobalCubit.get(context)
            .connectSocket(AuthCubit.get(context).currentUser!.id));
    WalletCubit.get(context).getPointData();
    sendFcm(context);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.orderProcessing != null) {
        final status = widget.orderProcessing?.status;
        switch (status) {
          case "accept":
            GlobalCubit.get(context).emitState(SocketAcceptOrder());
            break;
          case "start":
            GlobalCubit.get(context).emitState(SocketStartOrder());
            break;
          case "arrived":
            GlobalCubit.get(context).emitState(
              SocketDriverArrived(
                orderDModel: widget.orderProcessing,
              ),
            );
            break;
          case "partially_cancelled":
            //TODO
            break;
          default:
            break;
        }
        if (status != "end" && status != "cancel") {
          waitingDriverToggleView.value = true;
        }
      }
    });
  }

  sendFcm(context) async {
    FirebaseMessaging.instance.getToken().then((value) {
      if (value != null) {
        printSuccess("firebase messaging token: $value");
        AuthCubit.get(context).sendFCM(fcm: value, afterSuccess: () {});
      }
    });
  }

  @override
  void dispose() {
    printResponse('dispose Home');
    mainMarkerTimer.cancel();
    markerTimer.cancel();
    printResponse("MarkerTimerIsActive: ${markerTimer.isActive}");
    super.dispose();
  }

  List<dynamic> paymentMethods(BuildContext context) => <List<dynamic>>[
        ['wallet', context.wallet],
        ['assets/images/visa.svg', context.visa],
        ['assets/images/cash1.svg', context.cash]
      ];

  Future<void> _setPolyLine(
    PointLatLng origin,
    List<PointLatLng> destination,
  ) async {
    final resultPort = ReceivePort();
    try {
      await Isolate.spawn(
        _isolateSetPolyline,
        [
          resultPort.sendPort,
          origin,
          destination,
        ],
        errorsAreFatal: true,
        onExit: resultPort.sendPort,
        onError: resultPort.sendPort,
      );
    } catch (e) {
      printError("GetPolyline Isolate Error: $e");
      resultPort.close();
    }

    final response = (await resultPort.first) as List<dynamic>?;

    if (response != null) {
      OrderCubit.get(context).orderModel?.timeTaken = response[0];
      _directions = response[1];
      _polylineValueNotifier.value =
          Set<Polyline>.from(_polylineValueNotifier.value)
            ..clear()
            ..add(response[2]);
    }
  }

  static Future<void> _isolateSetPolyline(List<dynamic> args) async {
    DioHelper.init();
    SendPort resultPort = args[0];
    PointLatLng origin = args[1];
    List<PointLatLng> destination = args[2];

    final direction = await GlobalCubit.getDirections(
      LatLng(
        origin.latitude,
        origin.longitude,
      ),
      destination
          .map(
            (e) => LatLng(
              e.latitude,
              e.longitude,
            ),
          )
          .toList(),
    );
    if (direction != null) {
      final duration = direction.routes![0].legs![0].duration!.text;
      final polylineCoordinates = <LatLng>[];
      for (var element in direction.routes![0].legs!) {
        for (var element in element.steps!) {
          for (var element in element.polyline!.points!) {
            polylineCoordinates.add(
              LatLng(
                element.latitude,
                element.longitude,
              ),
            );
          }
        }
      }
      final result = Polyline(
        polylineId: const PolylineId('polyline'),
        width: 4,
        color: AppColors.darkGrey,
        jointType: JointType.round,
        points: polylineCoordinates,
      );
      Isolate.exit(resultPort, [
        duration,
        direction,
        result,
      ]);
    } else {
      Isolate.exit(resultPort, null);
    }
  }

  Future<void> getDropLocation() async {
    //animate to dropoff location
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: toLocations.last == 2
              ? LatLng(
                  toLocationLat1,
                  toLocationLon1,
                )
              : toLocations.last == 3
                  ? LatLng(
                      toLocationLat2,
                      toLocationLon2,
                    )
                  : LatLng(
                      toLocationLat,
                      toLocationLon,
                    ),
          // zoom: 16,
        ),
      ),
    );
    addMarker(
      toLocations.last == 2
          ? LatLng(
              toLocationLat1,
              toLocationLon1,
            )
          : toLocations.last == 3
              ? LatLng(
                  toLocationLat2,
                  toLocationLon2,
                )
              : LatLng(
                  toLocationLat,
                  toLocationLon,
                ),
      "dropOffMarker",
      markerIcon: await bitmapDescriptorFromSvgAsset(
          context: context, assetName: 'assets/images/dropOff.svg'),
    );
    if (toLocations.length == 2) {
      await Future.delayed(const Duration(milliseconds: 800), () {});

      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: toLocations.first == 2
                ? LatLng(
                    toLocationLat1,
                    toLocationLon1,
                  )
                : toLocations.first == 3
                    ? LatLng(
                        toLocationLat2,
                        toLocationLon2,
                      )
                    : LatLng(
                        toLocationLat,
                        toLocationLon,
                      ),
            // zoom: 16,
          ),
        ),
      );
      addMarker(
        toLocations.first == 2
            ? LatLng(
                toLocationLat1,
                toLocationLon1,
              )
            : toLocations.first == 3
                ? LatLng(
                    toLocationLat2,
                    toLocationLon2,
                  )
                : LatLng(
                    toLocationLat,
                    toLocationLon,
                  ),
        "dropOffMarker1",
        markerIcon: await bitmapDescriptorFromSvgAsset(
            context: context, assetName: 'assets/images/dropOff.svg'),
      );
    } else if (toLocations.length == 3) {
      addMarker(
        toLocations.first == 2
            ? LatLng(
                toLocationLat1,
                toLocationLon1,
              )
            : toLocations.first == 3
                ? LatLng(
                    toLocationLat2,
                    toLocationLon2,
                  )
                : LatLng(
                    toLocationLat,
                    toLocationLon,
                  ),
        "dropOffMarker1",
        markerIcon: await bitmapDescriptorFromSvgAsset(
            context: context, assetName: 'assets/images/dropOff.svg'),
      );
      addMarker(
        toLocations[1] == 2
            ? LatLng(
                toLocationLat1,
                toLocationLon1,
              )
            : toLocations[1] == 3
                ? LatLng(
                    toLocationLat2,
                    toLocationLon2,
                  )
                : LatLng(
                    toLocationLat,
                    toLocationLon,
                  ),
        "dropOffMarker2",
        markerIcon: await bitmapDescriptorFromSvgAsset(
            context: context, assetName: 'assets/images/dropOff.svg'),
      );
    }
    await Future.delayed(const Duration(milliseconds: 800), () {});
    // animate to pickup location
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            fromLocationLat,
            fromLocationLon,
          ),
          // zoom: 16,
        ),
      ),
    );
    addMarker(
      LatLng(
        fromLocationLat,
        fromLocationLon,
      ),
      "pickupMarker",
      markerIcon: await bitmapDescriptorFromSvgAsset(
          context: context, assetName: 'assets/images/pickup.svg'),
    );
    _setMapFitToTour(_polylineValueNotifier.value);
  }

  void _setMapFitToTour(Set<Polyline> p) {
    if (p.isNotEmpty) {
      double minLat = p.first.points.first.latitude;
      double minLong = p.first.points.first.longitude;
      double maxLat = p.last.points.last.latitude;
      double maxLong = p.last.points.last.longitude;
      for (var poly in p) {
        for (var point in poly.points) {
          if (point.latitude < minLat) minLat = point.latitude;
          if (point.latitude > maxLat) maxLat = point.latitude;
          if (point.longitude < minLong) minLong = point.longitude;
          if (point.longitude > maxLong) maxLong = point.longitude;
        }
      }
      _controller?.moveCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
              southwest: LatLng(minLat, minLong),
              northeast: LatLng(maxLat, maxLong)),
          50,
        ),
      );
    } else {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(
                fromLocationLat,
                fromLocationLon,
              ),
              zoom: 15),
        ),
      );
    }
  }

  void addDriverMarker(
    LatLng position,
    String markerId,
    double heading,
    bool to,
  ) async {
    final Uint8List markerIcon =
        await getCarMarkerBytesFromAsset('assets/images/car_green.png', 50);
    BitmapDescriptor icon = BitmapDescriptor.fromBytes(markerIcon);

    bool forceUpdate = _started == false && to == true ? true : false;
    if (forceUpdate == true) {
      _started = true;
    }

    printSuccess("toLocations: $toLocations");
    printSuccess("TripStarted: $to");

    /// remove first point from to locations when reached
    if (to) {
      final toLocation = toLocations.first == 1
          ? toolkit.LatLng(
              toLocationLat,
              toLocationLon,
            )
          : toLocations.first == 2
              ? toolkit.LatLng(
                  toLocationLat1,
                  toLocationLon1,
                )
              : toolkit.LatLng(
                  toLocationLat2,
                  toLocationLon2,
                );
      final distToFirstEnd = toolkit.SphericalUtil.computeDistanceBetween(
        toolkit.LatLng(
          position.latitude,
          position.longitude,
        ),
        toLocation,
      ).toDouble();

      if (distToFirstEnd <= 20 && toLocations.length != 1) {
        final location = toLocations.removeAt(0);
        location == 1
            ? () {
                toLocationLat = 0.0;
                toLocationLon = 0.0;
                toLocationAddressController.clear();
              }
            : location == 2
                ? () {
                    toLocationLat1 = 0.0;
                    toLocationLon1 = 0.0;
                    toLocationAddressController1.clear();
                  }
                : () {
                    toLocationLat2 = 0.0;
                    toLocationLon2 = 0.0;
                    toLocationAddressController2.clear();
                  };
      }
    }

    double? minDistance;
    int index = 0;
    int legIndex = 0;

    ///  check if driver is on polyline or took another road to update map polyline
    ///  using minDistance between driver location and polyline
    if (_directions != null && to) {
      minDistance = double.infinity;
      final legs = _directions!.routes![0].legs!;
      final steps = _directions!.routes![0].legs![0].steps!;
      final points = steps.length >= 2
          ? [
              ...steps[0].polyline!.points!,
              ...steps[1].polyline!.points!,
            ]
          : legs.length >= 2
              ? [
                  ...steps[0].polyline!.points!,
                  ...legs[1].steps![0].polyline!.points!,
                ]
              : steps[0].polyline!.points!;

      for (int i = 0; i < points.length - 1; i++) {
        double distance = pointToLineDistance(
          toolkit.LatLng(
            position.latitude,
            position.longitude,
          ),
          toolkit.LatLng(points[i].latitude, points[i].longitude),
          toolkit.LatLng(points[i + 1].latitude, points[i + 1].longitude),
        );
        if (distance < minDistance!) {
          minDistance = distance;
          index = i < steps[0].polyline!.points!.length ? 0 : 1;
          legIndex = index == 1 && steps.length == 1 && legs.length > 1 ? 1 : 0;
        }
      }

      if (minDistance! <= 20) {
        printSuccess("On the current polyline");
      } else {
        printError("Out of the current polyline");
      }
    }

    /// check multiple to decide when update polyline or removing past steps or past legs
    if (minDistance == null || minDistance > 20 || forceUpdate) {
      if (index == 0) {
        if (to) {
          printSuccess(
            "++++++++++++++++++++++++++++Started======================",
          );
          await _setPolyLine(
            PointLatLng(position.latitude, position.longitude),
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
        } else {
          printSuccess(
            "++++++++++++++++++++++++++Accepted======================",
          );
          await _setPolyLine(
            PointLatLng(position.latitude, position.longitude),
            [
              PointLatLng(
                fromLocationLat,
                fromLocationLon,
              ),
            ],
          );
        }
      } else {
        if (legIndex == 0) {
          _directions!.routes![0].legs![0].steps!.removeAt(0);
        } else {
          _directions!.routes![0].legs!.removeAt(0);
        }
      }
    }

    final marker = Marker(
      markerId: MarkerId(markerId),
      icon: icon,
      position: position,
      rotation: heading,
      anchor: const Offset(.5, .5),
    );
    _markersValueNotifier.value =
        Map<String, Marker>.of(_markersValueNotifier.value)
          ..removeWhere((key, element) => element.markerId.value == markerId)
          ..[markerId] = marker;

    if (to) {
      _setMapFitToTour(_polylineValueNotifier.value);
    } else {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 18,
          ),
        ),
      );
    }
  }

  _initWaitingDriver() {
    _cancelRideValueNotifier.value = false;
    _selectRide.value = OrderCubit.get(context).orderModel == null;
    _getEstimatedTime(context);
    shipmentTypeId = 2;
    _setPolyLine(
      PointLatLng(
        fromLocationLat,
        fromLocationLon,
      ),
      toLocations
          .map(
            (e) => e == 1
                ? PointLatLng(toLocationLat, toLocationLon)
                : e == 2
                    ? PointLatLng(toLocationLat1, toLocationLon1)
                    : PointLatLng(toLocationLat2, toLocationLon2),
          )
          .toList(),
    ).then((value) => getDropLocation());
  }

  _makeOrder() {
    if (rideTypeId == 0) {
      showToast(
        context.selectRideError,
        color: AppColors.yellow,
        textColor: AppColors.black,
      );
      return;
    }
    final toLocationData = toLocations
        .map((e) => e == 1
            ? <dynamic>[
                toLocationLat,
                toLocationLon,
                toLocationAddressController.text,
              ]
            : e == 2
                ? <dynamic>[
                    toLocationLat1,
                    toLocationLon1,
                    toLocationAddressController1.text,
                  ]
                : <dynamic>[
                    toLocationLat2,
                    toLocationLon2,
                    toLocationAddressController2.text,
                  ])
        .toList();
    if (fromLocationLat == 0.0 ||
        fromLocationLon == 0.0 ||
        toLocationData
            .any((element) => element[0] == 0.0 || element[1] == 0.0)) {
      showToast(context.makeOrderValidationError, color: AppColors.yellow);
      return;
    }
    printSuccess(toLocations.toString());
    OrderCubit.get(context).makeOrder(
      makeOrderRequest: MakeOrderRequest(
        hours: _hours.value * 60,
        fromLocationLat: fromLocationLat,
        fromLocationLon: fromLocationLon,
        fromLocationAddress: fromLocationAddressController.text,
        toLocations: toLocationData,
      ),
      afterError: () {
        if (_selectRide.value) {
          showToast(context.rideRequested);
          printSuccess("shipmentTypeId: $shipmentTypeId");
          _selectRide.value = false;
        }
      },
      afterSuccess: () {
        if (_selectRide.value) {
          showToast(context.rideRequested);
          printSuccess("shipmentTypeId: $shipmentTypeId");
          _selectRide.value = false;
        }
      },
    );
  }

  _removeRequest() {
    if (_ended.value == false) {
      _ended.value = true;
      showDialog(
        context: context,
        builder: (_) => WillPopScope(
          child: const LoadingIndicator(),
          onWillPop: () => Future.value(false),
        ),
      );
      Future.delayed(const Duration(seconds: 1)).then((value) => {
            resetOrder(),
            GlobalCubit.get(context).resetState(),
            waitingDriverToggleView.value = false,
            Navigator.popUntil(context, (route) => route.isFirst)
          });
    }
  }

  /// Select Ride Functions
  final List<String> _time = [];

  _onDragEnd(DragEndDetails details) {
    if (height > 10.h && !expand) {
      if (height < 64.h) {
        expand = false;
        location = 64.h;
      } else {
        expand = true;
        location = 90.h;
      }
    } else if (height < 90.h && expand) {
      expand = false;
      location = 64.h;
    }
  }

  _onDragUpdate(DragUpdateDetails details) {
    height =
        (MediaQuery.of(context).size.height - details.globalPosition.dy).abs();
    setState(() {
      if (height > 64.h && height < 90.h && (details.primaryDelta != 0.0)) {
        location = height;
      }
    });
  }

  Future _getEstimatedTime(BuildContext context) async {
    LatLng from;
    LatLng to;
    for (int i = 0; i < toLocations.length; i++) {
      if (i == 0) {
        from = LatLng(fromLocationLat, fromLocationLon);
        to = toLocations[i] == 1
            ? LatLng(toLocationLat, toLocationLon)
            : toLocations[i] == 2
                ? LatLng(toLocationLat1, toLocationLon1)
                : LatLng(toLocationLat2, toLocationLon2);
      } else {
        from = toLocations[i - 1] == 1
            ? LatLng(toLocationLat, toLocationLon)
            : toLocations[i - 1] == 2
                ? LatLng(toLocationLat1, toLocationLon1)
                : LatLng(toLocationLat2, toLocationLon2);
        to = toLocations[i] == 1
            ? LatLng(toLocationLat, toLocationLon)
            : toLocations[i] == 2
                ? LatLng(toLocationLat1, toLocationLon1)
                : LatLng(toLocationLat2, toLocationLon2);
      }
      await GlobalCubit.get(context).getDistanceMatrix(
        fromLat: from.latitude,
        fromLon: from.longitude,
        toLat: to.latitude,
        toLon: to.longitude,
        context: context,
        afterSuccess: (time) {
          setState(() {
            _time.add(time);
          });
        },
      );
    }
  }

  _onAdd() {
    _hours.value++;
  }

  _onMinus() {
    if (_hours.value > 1) {
      _hours.value -= 1;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: waitingDriverToggleView,
        builder: (context, waitingDriver, child) {
          return BlocConsumer<AppCubit, AppState>(
            listener: (context, state) {
              if (state is AppThemeUpdateState) {
                _fetchMapStyle();
              }
            },
            builder: (context, state) {
              return Scaffold(
                body: SnappingSheet(
                  controller: snappingSheetController,
                  lockOverflowDrag: true,
                  snappingPositions: const [
                    // SnappingPosition.factor(
                    //   positionFactor: 0.20,
                    //   grabbingContentOffset: GrabbingContentOffset.bottom,
                    // ),
                    SnappingPosition.factor(
                      positionFactor: 0.84,
                      snappingDuration: Duration(milliseconds: 300),
                    ),
                    SnappingPosition.factor(
                      positionFactor: 0.20,
                      grabbingContentOffset: GrabbingContentOffset.top,
                    ),
                  ],
                  grabbingHeight: 30,
                  grabbing: waitingDriver
                      ? const SizedBox()
                      : Container(
                          decoration: BoxDecoration(
                            color:
                                isDark ? AppColors.darkGrey : AppColors.white,
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.grey.withOpacity(0.7),
                                spreadRadius: 4,
                                blurRadius: 2,
                                offset: const Offset(
                                  0,
                                  0,
                                ), // changes position of shadow
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 0.5.h,
                              width: 58,
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),
                  onSnapCompleted: (sheetPosition, snappingPosition) {
                    printSuccess(
                        "onSnapCompleted SheepPosition: ${sheetPosition.pixels}");
                    printResponse(
                        "onSnapCompleted snappingPosition: ${snappingPosition.grabbingContentOffset}");
                  },
                  onSheetMoved: (sheetPosition) {
                    if (sheetPosition.pixels > 78.h) {
                      _showWhereTo.value = true;
                    } else {
                      _showWhereTo.value = false;
                    }
                  },
                  sheetAbove: SnappingSheetContent(
                    draggable: true,
                    child: waitingDriver
                        ? Container()
                        : ValueListenableBuilder(
                            valueListenable: _showWhereTo,
                            builder: (context, showWhereTo, child) {
                              return ValueListenableBuilder(
                                  valueListenable: _fav,
                                  builder: (context, fav, child) {
                                    return HomeAboveSheet(
                                      fav: fav,
                                      showWhereTo: showWhereTo,
                                      updateState: () => setState(() {}),
                                      updateFav: (nFav) {
                                        _fav.value = nFav;
                                      },
                                    );
                                  },);
                            },),
                  ),
                  child: Stack(
                    children: [
                      ValueListenableBuilder(
                          valueListenable: _polylineValueNotifier,
                          builder: (context, polyline, child) {
                            return ValueListenableBuilder(
                              valueListenable: _mapTypeValueNotifier,
                              builder: (context, mapType, child) {
                                return ValueListenableBuilder<
                                    Map<String, Marker>>(
                                  valueListenable: _markersValueNotifier,
                                  builder: (context, markers, child) {
                                    return GoogleMap(
                                      key: const ValueKey(1),
                                      initialCameraPosition: initial,
                                      onCameraMove: (position) {
                                        if (!waitingDriver) {
                                          _onCameraMove(position);
                                        }
                                      },
                                      zoomControlsEnabled: false,
                                      rotateGesturesEnabled: true,
                                      onCameraIdle: () {
                                        if (!waitingDriver) {
                                          getAddress();
                                        }
                                      },
                                      myLocationButtonEnabled: false,
                                      mapType: mapType == true
                                          ? MapType.satellite
                                          : MapType.normal,
                                      polylines: polyline,
                                      markers: markers.values.toSet(),
                                      onMapCreated: (GoogleMapController
                                          googleMapController) {
                                        googleMapController
                                            .setMapStyle(mapTheme);
                                        _controller = googleMapController;
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          }),
                      waitingDriver
                          ? HomeWaitingDriverView(
                              time: _time,
                              location: location,
                              onDragEnd: _onDragEnd,
                              onDragUpdate: _onDragUpdate,
                              expand: expand,
                              hours: _hours,
                              onAdd: _onAdd,
                              onMinus: _onMinus,
                              updateState: () => setState(() {}),
                              makeOrder: _makeOrder,
                              paymentMethods: paymentMethods,
                              cancelRideValueNotifier: _cancelRideValueNotifier,
                              selectRide: _selectRide,
                              addDriverMarker: addDriverMarker,
                              removeRequest: _removeRequest,
                              getDropLocation: getDropLocation,
                              ended: _ended,
                              updateSelect: () {
                                logWarning("selecttttt: $select");
                                if (select < 8) {
                                  Future.delayed(const Duration(seconds: 30))
                                      .then(
                                    (value) => {
                                      _makeOrder(),
                                      select++,
                                    },
                                  );
                                } else {
                                  _removeRequest();
                                  select = 0;
                                }
                              },
                              setPolyLine: _setPolyLine,
                              markersValueNotifier: _markersValueNotifier,
                              controller: _controller,
                              setMapFitToTour: () => _setMapFitToTour(
                                _polylineValueNotifier.value,
                              ),
                            )
                          : ValueListenableBuilder(
                              valueListenable: _showWhereTo,
                              builder: (context, showWhereTo, child) {
                                return HomeBottomView(
                                  getMyLocation: _getMyLocation,
                                  showWhereTo: showWhereTo,
                                  mapTypeValueNotifier: _mapTypeValueNotifier,
                                  markerPaddingValueNotifier:
                                      _markerPaddingValueNotifier,
                                  getLoc: _getLoc,
                                );
                              }),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
