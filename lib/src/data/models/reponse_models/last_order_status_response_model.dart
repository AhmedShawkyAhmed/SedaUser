import 'package:seda/src/data/models/order_model.dart';

class LastOrderStatusResponse {
  String? message;
  Data? data;

  LastOrderStatusResponse({this.message, this.data});

  LastOrderStatusResponse.fromJson(Map<String, dynamic> json) {
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
  bool? active;
  OrderModel? order;

  Data({this.active, this.order});

  Data.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    order = json['order'] != null ? OrderModel.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active'] = active;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}
