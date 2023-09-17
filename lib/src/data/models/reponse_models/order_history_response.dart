import 'package:seda/src/data/models/location_model.dart';

class OrdersHistory {
  String? message;
  Data data = Data();

  OrdersHistory({this.message});

  OrdersHistory.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;

    data['data'] = this.data.toJson();

    return data;
  }
}

class Data {
  List<Orders> orders = [];
  int pages = 0;

  Data();

  Data.fromJson(Map<String, dynamic> json) {
    orders = <Orders>[];
    json['orders'].forEach((v) {
      orders.add(Orders.fromJson(v));
    });
    pages = json['pages'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['orders'] = orders.map((v) => v.toJson()).toList();

    return data;
  }
}

class Orders {
  int? id;
  String? status;
  int? rate;
  double? price;
  LocationModel? fromLocation;
  List<LocationModel>? toLocation = [];

  Orders(
      {this.id,
        this.status,
        this.rate,
        this.price,
        this.fromLocation,
        this.toLocation});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    rate = json['rate'];
    price = json['price']?.toDouble();
    fromLocation = json['fromLocation'] != null
        ? LocationModel.fromJson(json['fromLocation'])
        : null;
    toLocation = (json['toLocation'] as List)
        .map((e) => LocationModel.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['rate'] = rate;
    data['price'] = price;
    if (fromLocation != null) {
      data['fromLocation'] = fromLocation!.toJson();
    }
    if (toLocation != null) {
      data['toLocation'] = toLocation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}