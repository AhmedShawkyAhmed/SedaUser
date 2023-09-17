import 'package:seda/src/data/models/order_model.dart';

class EndOrderResponse {
  String? event;
  String? message;
  OrderModel? data;

  EndOrderResponse({this.event, this.message, this.data});

  EndOrderResponse.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    message = json['message'];
    data = json['data'] != null ? OrderModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event'] = event;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
