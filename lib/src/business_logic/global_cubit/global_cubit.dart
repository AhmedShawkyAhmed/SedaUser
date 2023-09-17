import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seda/src/business_logic/app_cubit/app_cubit.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/constants/shared_preference_keys.dart';
import 'package:seda/src/constants/tools/log_util.dart';
import 'package:seda/src/data/data_provider/local/cache_helper.dart';
import 'package:seda/src/data/data_provider/remote/dio_helper.dart';
import 'package:seda/src/data/models/accept_order.dart';
import 'package:seda/src/data/models/car.dart';
import 'package:seda/src/data/models/driver_offer_model.dart';
import 'package:seda/src/data/models/live_location.dart';
import 'package:seda/src/data/models/message_model.dart';
import 'package:seda/src/data/models/order_model.dart';
import 'package:seda/src/data/models/reponse_models/end_order_response.dart';
import 'package:seda/src/data/models/reponse_models/google_map_directions_reponse/google_map_directions_reponse.dart';
import 'package:seda/src/data/models/reponse_models/new_driver_offer_response.dart';
import 'package:seda/src/data/models/reponse_models/new_message_event_response.dart';
import 'package:seda/src/data/models/reponse_models/order_response.dart';
import 'package:seda/src/data/models/user_model.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/notifications/notification_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';

import '../../constants/tools/toast.dart';

part 'global_state.dart';

class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial());

  static GlobalCubit get(context) => BlocProvider.of(context);

  void resetState() {
    emit(GlobalInitial());
  }

  void emitState(GlobalState state) {
    emit(state);
  }

  Future checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
        CacheHelper.saveDataSharedPreference(
            key: SharedPreferenceKeys.isConnected, value: true);
      }
    } on SocketException catch (_) {
      CacheHelper.saveDataSharedPreference(
          key: SharedPreferenceKeys.isConnected, value: false);
      debugPrint('not connected');
    }
  }

  Future<void> getDistanceMatrix({
    required double fromLat,
    required double fromLon,
    required double toLat,
    required double toLon,
    required BuildContext context,
    required Function(String time) afterSuccess,
  }) async {
    try {
      final response = await Dio().get(
          'https://maps.googleapis.com/maps/api/distancematrix/json?language=${context.isAr ? 'ar' : 'en'}&destinations=$toLat,$toLon&origins=$fromLat,$fromLon&key=${EndPoints.googleMapKey}');
      printSuccess('get distance response: $response');
      afterSuccess(
        json.decode(response.toString())["rows"][0]["elements"][0]["duration"]
            ["text"],
      );
    } catch (e) {
      printError(e.toString());
    }
  }

  static Future<GoogleMapDirections?> getDirections(
    LatLng origin,
    List<LatLng> wayPoint,
  ) async {
    try {
      printError(
          "destination: ${wayPoint.last.latitude},${wayPoint.last.longitude}");
      printError("origin: ${origin.latitude},${origin.longitude}");
      final uri = Uri.https(
        "maps.googleapis.com",
        "/maps/api/directions/json",
        {
          "destination": "${wayPoint.last.latitude},${wayPoint.last.longitude}",
          "origin": "${origin.latitude},${origin.longitude}",
          if (wayPoint.length > 1)
            "waypoints": wayPoint
                .sublist(0, wayPoint.length - 1)
                .map(
                  (e) => "${e.latitude},${e.longitude}",
                )
                .join(
                  "|",
                ),
          "key": EndPoints.googleMapKey,
          "mode": "driving"
        },
      );
      final response = await DioHelper.dio?.getUri(uri);
      log(response.toString());
      if (response?.statusCode == 200) {
        final model = GoogleMapDirections.fromJson(response!.data);
        if (model.status == "OK") {
          return model;
        }
      }
    } catch (e) {
      printError('============$e');
    }
    return null;
  }

  Future navigate({required VoidCallback afterSuccess}) async {
    await Future.delayed(
      const Duration(
        seconds: 5,
      ),
      () {},
    );
    afterSuccess();
  }

  bool rebuild = false;
  bool driverArrived = false;
  Car? driverCar;
  LiveLocation? liveLocation;
  late io.Socket socket;
  List<DriverOfferModel> diversOffers = [];

  void connectSocket(id) {
    var url = "wss://socket.magdsofteg.xyz";
    socket = io.io(url, <String, dynamic>{
      "transports": ["websocket"],
    });
    printResponse("try to connect to $url");

    socket.onConnect((data) {
      printResponse("Socket Connection Successfully");
    });
    socket.on("${EndPoints.appKey}.users.$id", (data) async {
      printError('///////////////////////////////////////////');
      log("New Event Acquired: $data");
      log("============================");
      var map = json.decode(data);
      if (map['event'].toString() == "acceptOrder") {
        printResponse('the accept driver is ${(data.toString())}');
        printResponse('the accept driver is ${(data.toString())}');
        AcceptOrder acceptOrder = AcceptOrder.fromJson(map);
        emit(SocketAcceptOrder(orderModel: acceptOrder.data));
      } else if (map['event'].toString() == "CapitanArrived") {
        if (state is! SocketEndOrder) {
          driverArrived = true;
          AcceptOrder acceptOrder = AcceptOrder.fromJson(map);
          emit(SocketDriverArrived(orderDModel: acceptOrder.data));
        }
      } else if (map['event'].toString() == "startOrder") {
        if (state is! SocketEndOrder) {
          driverArrived = false;
          emit(SocketStartOrder());
        }
      } else if (map['event'].toString() == "endOrder") {
        log("endOrder Event Response: $map");
        printSuccess("endOrder Event Response: ${map.toString()}");
        printError('endeeeeeed');
        EndOrderResponse endOrderResponse = EndOrderResponse.fromJson(map);
        emit(SocketEndOrder(orderModel: endOrderResponse.data));
      } else if (map['event'].toString() == "NoDriverAcceptedOrFounded") {
        showToast('All Drivers busy please try later', ToastState.warning);
        emit(NoDriverAcceptedOrFoundedState());
      } else if (map['event'].toString() == "CancelAfterArrived") {
        showToast('Driver Cancelled the order', ToastState.warning);
        emit(CancelAfterArrived());
      } else if (map['event'].toString() == "userLiveTracking") {
        emit(UserLiveTracking());
      } else if (map['event'].toString() == "driverLocation") {
        printSuccess('driver location accept');
        printResponse('ggggg$data');
        rebuild = true;
        liveLocation = LiveLocation.fromJson(map);
        printResponse('//${liveLocation!.data!.lat}');
        emit(SocketAcceptOrder());
      } else if (map['event'].toString() == "driverLocationStart") {
        printSuccess('driver location start');
        printResponse('ggggg$data');
        if (state is! SocketEndOrder) {
          rebuild = true;
          liveLocation = LiveLocation.fromJson(map);
          emit(SocketStartOrder());
        }
      } else if (map['event'].toString() == "you have new message") {
        log('New Message: $map');
        printSuccess('New Message: $map');
        NewMessageEventResponse newMessage = NewMessageEventResponse.fromJson(
          Map<String, dynamic>.from(map),
        );
        if (newMessage.data != null) {
          await NotificationService.showNotification(
            id: 2,
            title: map['event'].toString(),
            body: newMessage.data?.massage ?? 'you have media message',
          );
          emit(SocketNewMessage(newMessage.data!));
        }
      } else if (map['event'].toString() == 'driverOffer') {
        final newDriverOfferResponse = NewDriverOfferResponse.fromJson(map);
        final offer = DriverOfferModel(
          driver: newDriverOfferResponse.data?.driver,
          order_sent_to_driver_id:
              newDriverOfferResponse.data?.order_sent_to_driver_id,
          driver_price: newDriverOfferResponse.data?.driver_price,
        );
        var exists = diversOffers.any(
          (element) =>
              element.driver?.id == newDriverOfferResponse.data?.driver?.id,
        );
        if (!exists) {
          diversOffers.add(offer);
        }
        emit(SocketNewDriverOffer());
      } else {
        OrderResponseModel orderResponse = OrderResponseModel.fromJson(map);
        emit(SocketSuccess(orderModel: orderResponse.data?.order));
      }
      if (!(map['event'].toString() == "driverLocation" ||
          map['event'].toString() == "driverLocationStart" ||
          map['event'].toString() == "userLiveTracking" ||
          map['event'].toString() == "NoDriverAcceptedOrFounded" ||
          map['event'].toString() == "you have new message")) {
        await NotificationService.showNotification(
          id: 0,
          title: map['event'].toString(),
          body: map['message'].toString(),
        );
      }
    });

    socket.onConnectError((data) {
      printError(" socket.onConnectError ${data.toString()}");
      emit(SocketFailure());
    });

    socket.onDisconnect((data) {
      printError(" socket.onDisconnect");
      socket.connect();
      emit(SocketFailure());
    });

    socket.onError((data) {
      printError(" socket.onError");
      emit(SocketFailure());
    });

    socket.on("message", (data) {
      printResponse("message");
    });
  }

  Future<void> sendRecordToDriver(data, BuildContext context) async {
    try {
      await Dio(BaseOptions(
              headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Accept-Language': AppCubit.get(context).locale,
          },
              baseUrl: "https://socket.magdsofteg.xyz/",
              receiveDataWhenStatusError: true))
          .post("emit", data: data);
      logWarning('goooood');
    } on DioError catch (e) {
      logError('+++++++++++++++++$e');
      logError('__________${e.response!.data}');
      logError('__________${e.response}');
      showToast(e.message, ToastState.error);
    } catch (e) {
      logError('=============$e');
      showToast('Error when send location to user', ToastState.error);
    }
  }

  void onAcceptDriverOffer(DriverOfferModel offerModel) {
    final data = OrderModel(
      captain: UserModel(
        image: offerModel.driver?.image,
        name: offerModel.driver?.name,
        rate: offerModel.driver?.rate,
      ),
    );
    AcceptOrder acceptOrder = AcceptOrder(
      data: data,
    );
    diversOffers.clear();
    emit(SocketAcceptOrder(orderModel: acceptOrder.data));
  }

  void disconnectSocket() {
    socket = socket.disconnect();
    emit(SocketDisconnected());
  }
}
