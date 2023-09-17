// import 'package:seda/src/data/models/order_model.dart';
//
// class OrderResponse {
//   String? event;
//   String? message;
//   String? webviewPay;
//   OrderModel? orderModel;
//
//   OrderResponse({
//     required this.event,
//     required this.message,
//     required this.webviewPay,
//     required this.orderModel,
//   });
//
//   factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
//         event: json["event"] ?? "",
//         message: json["message"] ?? "",
//         orderModel: json["data"]["order"] == null
//             ? null
//             : OrderModel.fromJson(json["data"]["order"]),
//         webviewPay: json["data"]["webviewPay"] ?? "",
//       );
//
//   Map<String, dynamic> toJson() => {
//         "event": event,
//         "message": message,
//         "webviewPay": webviewPay,
//         "data": orderModel,
//       };
// }

import 'package:seda/src/data/models/order_model.dart';

class OrderResponseModel {
  Data? data;
  String? message;

  OrderResponseModel({this.data, this.message});

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {
  OrderModel? order;

  Data({this.order});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      order: json['order'] != null ? OrderModel.fromJson(json['order']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (order != null) {
      data['order'] = order?.toJson();
    }
    return data;
  }
}
