import 'package:seda/src/data/models/order_model.dart';

class AcceptOrder {
  AcceptOrder({
    this.event,
    this.message,
    this.data,
  });

  AcceptOrder.fromJson(dynamic json) {
    event = json['event'];
    message = json['message'];
    data = json['data'] != null ? OrderModel.fromJson(json['data']) : null;
  }

  String? event;
  String? message;

  OrderModel? data;

  AcceptOrder copyWith({
    String? event,
    String? message,
    OrderModel? data,
  }) =>
      AcceptOrder(
        event: event ?? this.event,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['event'] = event;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}