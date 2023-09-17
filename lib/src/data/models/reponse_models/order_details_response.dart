import 'package:seda/src/data/models/order_model.dart';

class OrderDetails {
  String? message;
  Data? data;

  OrderDetails({this.message, this.data});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  OrderModel? orders;

  Data({this.orders});

  Data.fromJson(Map<String, dynamic> json) {
    orders = json['orders'] != null ? OrderModel.fromJson(json['orders']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orders != null) {
      data['orders'] = orders!.toJson();
    }
    return data;
  }
}