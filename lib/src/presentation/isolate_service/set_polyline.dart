// ignore_for_file: use_build_context_synchronously

import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../business_logic/global_cubit/global_cubit.dart';
import '../../business_logic/order_cubit/order_cubit.dart';
import '../../constants/constants_methods.dart';
import '../../data/data_provider/remote/dio_helper.dart';
import '../../data/models/reponse_models/google_map_directions_reponse/google_map_directions_reponse.dart';
import '../styles/app_colors.dart';

Future<void> setPolyLine({
  required BuildContext context,
  GoogleMapDirections? directions,
  required ValueNotifier<Set<Polyline>> polylineValueNotifier,
  required PointLatLng origin,
  required List<PointLatLng> destination,
}) async {
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
    directions = response[1];
    polylineValueNotifier.value =
        Set<Polyline>.from(polylineValueNotifier.value)
          ..clear()
          ..add(response[2]);
  }
}

Future<void> _isolateSetPolyline(List<dynamic> args) async {
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
      width: 5,
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
