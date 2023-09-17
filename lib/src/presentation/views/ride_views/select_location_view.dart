import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/toast.dart';
import 'package:sizer/sizer.dart';

class SelectLocationView extends StatefulWidget {
  const SelectLocationView({Key? key}) : super(key: key);

  @override
  State<SelectLocationView> createState() => _SelectLocationViewState();
}

class _SelectLocationViewState extends State<SelectLocationView> {
  @override
  void initState() {
    try {
      getMyLocation();
    } catch (e) {
      printError('FakeCars Error:  $e');
    }

    super.initState();
  }

  bool _mapType = false;
  final _markers = <String, Marker>{};
  final _mapController = Completer<GoogleMapController>();
  final _result = <String, dynamic>{};
  double _padding = 0.0;
  static const LatLng _center = LatLng(45.343434, -122.545454);
  LatLng _lastMapPosition = _center;

  Position? position;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  void addMarker(LatLng position) async {
    BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 3.0),
        'assets/images/myLocation.png');
    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: const MarkerId("fromLocation"),
        icon: icon,
        position: position,
      );
      _markers["fromLocation"] = marker;
    });
    fromLocationLat = position.latitude;
    fromLocationLon = position.longitude;
    getAddress();
  }

  Future<Position> getMyLocation() async {
    await Permission.locationWhenInUse.request();
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            position!.latitude,
            position!.longitude,
          ),
          zoom: 18,
        ),
      ),
    );
    addMarker(LatLng(position!.latitude, position!.longitude));

    getLatLngDetails(
        lat: position!.latitude,
        lon: position!.longitude,
        afterSuccess: (data) {
          fromLocationAddressController.text = "${data.houseNumber ?? ''} "
              "${data.road ?? ''} "
              "${data.neighbourhood ?? ''} "
              "${data.state ?? ''} "
              "${data.country ?? ''}";
          printResponse(
              "FromLocationAddress: ${fromLocationAddressController.text}");
        });
    return position!;
  }

  Future<void> getAddress() async {
    getLatLngDetails(
        lat: _lastMapPosition.latitude,
        lon: _lastMapPosition.longitude,
        afterSuccess: (data) {
          _result["lat"] = _lastMapPosition.latitude;
          _result["lon"] = _lastMapPosition.longitude;
          _result["address"] = "${data.houseNumber ?? ''} "
              "${data.road ?? ''} "
              "${data.neighbourhood ?? ''} "
              "${data.state ?? ''} "
              "${data.country ?? ''}";
          setState(() {
            _padding = 0.0;
          });
        });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _padding = 3.0;
    });
    _lastMapPosition = position.target;
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await _mapController.future;
    controller.dispose();
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  bool getLoc = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: 100.w,
          height: 95.h,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: GoogleMap(
                  key: const ValueKey(1),
                  initialCameraPosition: initial,
                  onCameraMove: _onCameraMove,
                  zoomControlsEnabled: false,
                  rotateGesturesEnabled: true,
                  buildingsEnabled: false,
                  onCameraIdle: getAddress,
                  myLocationButtonEnabled: false,
                  mapType: _mapType ? MapType.satellite : MapType.normal,
                  markers: _markers.values.toSet(),
                  onMapCreated: (GoogleMapController googleMapController) {
                    googleMapController.setMapStyle(mapTheme);
                    _controller.complete(googleMapController);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 40,
                  left: 20,
                  right: 20,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => WillPopScope(
                          onWillPop: () => Future.value(false),
                          child: const LoadingIndicator(),
                        ),
                      );
                      Future.delayed(const Duration(seconds: 1))
                          .then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    },
                    child: Container(
                      height: 13.w,
                      width: 13.w,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkGrey : AppColors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? AppColors.darkGrey.withOpacity(0.7)
                                : AppColors.grey.withOpacity(0.7),
                            spreadRadius: 4,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color:
                          isDark ? AppColors.white : AppColors.darkGrey,
                          size: 15.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 20.h,
                  left: 20,
                  right: 20,
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _mapType = !_mapType;
                      });
                    },
                    child: Container(
                      height: 13.w,
                      width: 13.w,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkGrey : AppColors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey.withOpacity(0.7),
                            spreadRadius: 4,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          _mapType
                              ? Icons.map_rounded
                              : Icons.satellite_alt_rounded,
                          color: isDark
                              ? AppColors.lightGrey
                              : AppColors.darkGrey,
                          size: 15.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 12.h,
                  left: 20,
                  right: 20,
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        getLoc = true;
                      });
                      getMyLocation().then((value) => setState(() {
                        getLoc = false;
                      }));
                    },
                    child: Container(
                      height: 13.w,
                      width: 13.w,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkGrey : AppColors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey.withOpacity(0.7),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: getLoc
                          ? CircularProgressIndicator(
                        color: isDark
                            ? AppColors.lightGreen
                            : AppColors.darkGrey,
                      )
                          : Center(
                          child: Icon(
                            Icons.my_location,
                            color: isDark
                                ? AppColors.lightGreen
                                : AppColors.darkGrey,
                            size: 23,
                          )),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 85.h),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Center(
                    child: DefaultAppButton(
                      onTap: () {
                        if (_result['lat'] != null &&
                            _result['lon'] != null &&
                            _result['address'] != null) {
                          showDialog(
                            context: context,
                            builder: (context) => const LoadingIndicator(),
                          );
                          printResponse(
                            "new LocationLat: ${_result['lat']}",
                          );
                          printResponse(
                            "new LocationLon: ${_result['lon']}",
                          );
                          printResponse(
                            "new LocationAddress: ${_result['address']}",
                          );

                          Future.delayed(const Duration(milliseconds: 1500))
                              .then(
                                (value) {
                              Navigator.pop(context);
                              Navigator.pop(context, _result);
                            },
                          );
                        } else {
                          showToast(context.selectLocation);
                        }
                      },
                      title: context.select,
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 15.w,
                  height: _padding == 0 ? 9.h : 11.h,
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _padding == 0 ? 9.w : 9.w,
                        height: 9.w,
                        decoration: BoxDecoration(
                          color: AppColors.midGreen,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: _padding == 0
                              ? Image.asset("assets/images/logo.png",
                              width: 4.w)
                              : LoadingAnimationWidget.halfTriangleDot(
                            color: AppColors.white,
                            size: 15,
                          ),
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 3.5.h,
                        decoration: BoxDecoration(
                          color: AppColors.darkGrey.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      _padding == 0
                          ? const SizedBox()
                          : Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: 1.5.w,
                        height: 1.5.w,
                        decoration: BoxDecoration(
                          color: AppColors.midGreen.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
