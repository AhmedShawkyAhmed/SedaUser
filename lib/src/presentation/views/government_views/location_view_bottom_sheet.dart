import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class LocationViewBottomSheet extends StatefulWidget {
  const LocationViewBottomSheet({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  final double latitude;
  final double longitude;

  @override
  State<LocationViewBottomSheet> createState() =>
      _LocationViewBottomSheetState();
}

class _LocationViewBottomSheetState extends State<LocationViewBottomSheet>
    with TickerProviderStateMixin {
  late AnimationController controller;
  final Set<Marker> markers = {};
  final Completer<GoogleMapController> _controller = Completer();
  CameraPosition? initial;
  double rate = 1.0;

  void addMarker(LatLng position, String id, String image) async {
    final Uint8List markerIcon = await getBytesFromAsset(
      image,
      Platform.isIOS ? 60.sp.toInt() : 40,
    );
    BitmapDescriptor icon = BitmapDescriptor.fromBytes(markerIcon);
    setState(() {
      final marker = Marker(
        markerId: MarkerId(id),
        icon: icon,
        position: position,
      );
      markers.add(marker);
    });
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
    initial = CameraPosition(
      target: LatLng(
        widget.latitude,
        widget.longitude,
      ),
      zoom: 18,
    );
    addMarker(
      LatLng(
        widget.latitude,
        widget.longitude,
      ),
      "toLocation",
      'assets/images/pin.png',
    );
    super.initState();
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await _controller.future;
    controller.dispose();
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
              initialCameraPosition: initial!,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                if (mapTheme.isNotEmpty) {
                  controller.setMapStyle(mapTheme);
                }
                if (!_controller.isCompleted) {
                  _controller.complete(controller);
                }
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
                          onWillPop: () => Future.value(false),
                          child: const LoadingIndicator()),
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
                        Icons.arrow_back_ios_new_outlined,
                        color:
                            isDark ? AppColors.lightGrey : AppColors.darkGrey,
                        size: 15.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 23.h, left: 10),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: 50.w,
                  height: 7.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: isDark ? AppColors.darkGrey : AppColors.midGrey,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 6.w,
                          height: 6.w,
                          child: Image.asset("assets/images/sheald.png"),
                        ),
                        SizedBox(
                          width: 35.w,
                          child: DefaultText(
                            text: context.checkDrId,
                            fontWeight: FontWeight.w600,
                            fontSize: 9.sp,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
