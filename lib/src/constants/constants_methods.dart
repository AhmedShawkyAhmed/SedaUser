// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as toolkit;
import 'package:permission_handler/permission_handler.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/constants/shared_preference_keys.dart';
import 'package:seda/src/data/data_provider/local/cache_helper.dart';
import 'package:seda/src/data/models/api_location_adress_model/api_location_address_response.dart';
import 'package:seda/src/notifications/notification_service.dart';

void printResponse(String text) => debugPrint('\x1B[33m$text\x1B[0m');

void printError(String msg) => debugPrint('\x1B[31m$msg\x1B[0m');

void printSuccess(String msg) => debugPrint('\x1B[32m$msg\x1B[0m');

void printWarning(String msg) => debugPrint('\x1B[33m$msg\x1B[0m');

void resetToLocations() {
  toLocations.clear();
  toLocations.add(1);
  toLocationLon = 0;
  toLocationLon1 = 0;
  toLocationLon2 = 0;
  toLocationLat = 0;
  toLocationLat1 = 0;
  toLocationLat2 = 0;
  toLocationAddressController.clear();
  toLocationAddressController1.clear();
  toLocationAddressController2.clear();
}

void resetOrder() {
  CacheHelper.removeData(key: SharedPreferenceKeys.orderId);
}

Future<Uint8List> getCarMarkerBytesFromAsset(String path, int width) async {
  if (carMarker == null) {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    carMarker = (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!
        .buffer
        .asUint8List();
  }
  return carMarker!;
}

Future multipartConvertImage({
  required XFile image,
}) async {
  return MultipartFile.fromFileSync(image.path,
      filename: image.path.split('/').last);
}

Future pickImage(
  ImageSource source,
  Function(String path) onSelect,
) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(
    source: source,
  );
  if (pickedFile != null) {
    onSelect(pickedFile.path);
  }
}

Future getLatLngDetails({
  required double lat,
  required double lon,
  required Function(ApiLocationAddress geoLocationData)? afterSuccess,
}) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
  final loc = placemarks.first;
  ApiLocationAddress locationAddress = ApiLocationAddress(
      houseNumber: loc.name,
      road: loc.street,
      neighbourhood: loc.locality,
      suburb: loc.subAdministrativeArea,
      state: loc.administrativeArea,
      iSO31662Lvl4: loc.isoCountryCode,
      postcode: loc.postalCode,
      country: loc.country,
      countryCode: '+20');
  if (afterSuccess != null) {
    await afterSuccess(locationAddress);
  } else {
    return locationAddress;
  }
}

Future getMyLocation(
    Function(Position location, String address) afterSuccess) async {
  if ((await Permission.locationWhenInUse.status) != PermissionStatus.granted ||
      (await Permission.locationAlways.status) != PermissionStatus.granted) {
    await Permission.locationAlways.request();
    await Permission.locationWhenInUse.request();
  }
  final myLocation = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  final lat = myLocation.latitude;
  final lon = myLocation.longitude;
  await getLatLngDetails(
    lat: lat,
    lon: lon,
    afterSuccess: (data) {
      final add =
          "${data.houseNumber ?? ''} ${data.road ?? ''}${data.neighbourhood ?? ''} ${data.state ?? ''} ${data.country ?? ''}";
      afterSuccess(myLocation, add);
    },
  );
}

Future<void> onFirebaseBackgroundMessage(RemoteMessage remoteMessage) async {
  WidgetsFlutterBinding.ensureInitialized();
  printSuccess("New Notification Received");
  await NotificationService.initialize();
  NotificationService.showNotification(
    id: Random().nextInt(9999999),
    title: "${remoteMessage.notification?.title}",
    body: "${remoteMessage.notification?.body}",
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future initialize() async {
  if (Platform.isIOS) {}
  printResponse('Firebase Messaging init');
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    printSuccess('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    printSuccess('User granted provisional permission');
  } else {
    printError('User declined or has not accepted permission');
  }
  //onMessage
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    printSuccess('when app is open ----  ${message.notification!.body}');
    NotificationService.showNotification(id: 1, title: 'title', body: 'body');
  });

  //onResume
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    printSuccess('when app is open after tap----  $message');
  });
  FirebaseMessaging.onBackgroundMessage(_handeler);

  //onLaunch
  final RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    printSuccess('when app is open from terminated ----  $initialMessage');
  }
}

Future<void> _handeler(message) async {
  printSuccess('when app in backGround ----  $message');
}

Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset({
  required BuildContext context,
  required String assetName,
  double? height,
  double? width,
}) async {
  // Read SVG file as String
  String svgString = await DefaultAssetBundle.of(context).loadString(assetName);
  // Create DrawableRoot from SVG String
  DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, 'null');

  // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
  MediaQueryData queryData = MediaQuery.of(context);
  double devicePixelRatio = queryData.devicePixelRatio;
  double iconWidth =
      (width ?? 10) * devicePixelRatio; // where 32 is your SVG's original width
  double iconHeight = (height ?? 10) *
      devicePixelRatio; // where 32 is your SVG's original width

  // Convert to ui.Picture
  ui.Picture picture =
      svgDrawableRoot.toPicture(size: Size(iconWidth, iconHeight));

  // Convert to ui.Image. toImage() takes width and height as parameters
  // you need to find the best size to suit your needs and take into account the
  // screen DPI
  ui.Image image = await picture.toImage(iconWidth.toInt(), iconHeight.toInt());
  ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
}

/// calculate distance between point and line segment
double pointToLineDistance(
  toolkit.LatLng point,
  toolkit.LatLng start,
  toolkit.LatLng end,
) {
  double distance = 0.0;
  double slope =
      (end.longitude - start.longitude) / (end.latitude - start.latitude);
  double intercept = start.longitude - (slope * start.latitude);
  double perpendicularSlope = -1 / slope;

  double perpIntercept =
      point.longitude - (perpendicularSlope * point.latitude);

  double intersectionLat =
      (intercept - perpIntercept) / (perpendicularSlope - slope);
  double intersectionLng = (slope * intersectionLat) + intercept;

  if (intersectionLat < start.latitude ||
      intersectionLat > end.latitude ||
      intersectionLng < start.longitude ||
      intersectionLng > end.longitude) {
    // closest point is not on the line segment, so calculate distance to start and end points
    double startDistance =
        toolkit.SphericalUtil.computeDistanceBetween(point, start).toDouble();
    double endDistance =
        toolkit.SphericalUtil.computeDistanceBetween(point, end).toDouble();
    distance = startDistance > endDistance ? endDistance : startDistance;
  } else {
    // closest point is on the line segment, so calculate distance to that point
    toolkit.LatLng closestPoint =
        toolkit.LatLng(intersectionLat, intersectionLng);
    distance = toolkit.SphericalUtil.computeDistanceBetween(
      point,
      closestPoint,
    ).toDouble();
  }

  return distance;
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}
