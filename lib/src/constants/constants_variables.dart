import 'dart:async';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seda/src/data/models/switch_model.dart';

bool isDark = false;

int defaultStatusCode = 100;
int successStatusCode = 200;
int defaultId = 0;

String mapTheme = '';
String userLocation = '';

final List<int> toLocations = [1];

double fromLocationLat = 0.0;
double fromLocationLon = 0.0;
double toLocationLat = 0.0;
double toLocationLon = 0.0;
double toLocationLat1 = 0.0;
double toLocationLon1 = 0.0;
double toLocationLat2 = 0.0;
double toLocationLon2 = 0.0;
int rideTypeId = 0;
int shipmentTypeId = 2;

/// 1 block, 2 serial, 3 offer, 4 govern, 5 scooter, 6 hour

int paymentTypeId = 3;

/// 1 system wallet, 2 online, 3 cash

TextEditingController fromLocationAddressController = TextEditingController();
TextEditingController toLocationAddressController = TextEditingController();
TextEditingController toLocationAddressController1 = TextEditingController();
TextEditingController toLocationAddressController2 = TextEditingController();

final ValueNotifier<bool> waitingDriverToggleView = ValueNotifier(false);

AudioPlayer currentPlayer = AudioPlayer();
final Completer<GoogleMapController> mapController = Completer();
CameraPosition initial = const CameraPosition(
  target: LatLng(30.054740517818406, 31.3741537684258),
  zoom: 12,
);

List<SwitchModel> popularLocations = [
  SwitchModel("Brisbane", true),
  SwitchModel("Melbourne", false),
  SwitchModel("Brisbane", true),
  SwitchModel("Melbourne", false),
  SwitchModel("Brisbane", true),
  SwitchModel("Melbourne", false),
];

Uint8List? carMarker;

bool alreadyRecording = false;
