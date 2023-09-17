import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/scooter_views/select_scooter_view.dart';
import 'package:sizer/sizer.dart';

class ScooterMapScreen extends StatefulWidget {
  const ScooterMapScreen({Key? key}) : super(key: key);

  @override
  State<ScooterMapScreen> createState() => _ScooterMapScreenState();
}

class _ScooterMapScreenState extends State<ScooterMapScreen> {
  final Map<String, Marker> _markers = {};
  final Completer<GoogleMapController> _controller = Completer();
  CameraPosition initial = const CameraPosition(
    target: LatLng(30.054740517818406, 31.3741537684258),
    zoom: 16,
  );

  void addMarker(LatLng position) async {
    BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 3.0),
        'assets/images/pinScooter.png');
    setState(() {
      _markers.clear();
      final marker = Marker(
          markerId: const MarkerId("location"),
          icon: icon,
          position: position,
          onTap: () {});
      _markers["location"] = marker;
    });
  }

  @override
  initState() {
    addMarker(const LatLng(30.054740517818406, 31.3741537684258));
    super.initState();
  }

  @override
  void dispose() {
    _disposeMap();
    super.dispose();
  }

  Future<void> _disposeMap() async {
    final c = await _controller.future;
    c.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              key: const ValueKey(1),
              initialCameraPosition: initial,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              onTap: addMarker,
              mapType: MapType.normal,
              markers: _markers.values.toSet(),
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(mapTheme);
                _controller.complete(controller);
              },
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
                        onWillPop: () => Future.value(true),
                        child: const LoadingIndicator(),
                      ),
                    );
                    Future.delayed(const Duration(seconds: 1)).then(
                      (value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    );
                  },
                  child: Container(
                    height: 13.w,
                    width: 13.w,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkGrey : AppColors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: isDark ? AppColors.white : AppColors.darkGrey,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 31.h,
                left: 20,
                right: 20,
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    // getMyLocation();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkGrey : AppColors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey.withOpacity(0.7),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                        child: Icon(
                      Icons.my_location,
                      color: isDark ? AppColors.lightGreen : AppColors.darkGrey,
                      size: 23,
                    )),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 27.h,
                  width: 100.w,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, position) {
                        return const SelectScooter();
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
