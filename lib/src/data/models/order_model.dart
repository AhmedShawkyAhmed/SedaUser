import 'package:seda/src/data/models/location_model.dart';
import 'package:seda/src/data/models/user_model.dart';

import 'Vehicle_model.dart';

class OrderModel {
  int? id;
  int? createdAt;
  String? createdAtStr;
  String? status;
  UserModel? user;
  int? paymentTypeId;
  int? hours;
  String? timeTaken;
  String? price;
  String? discount;
  String? distance;
  String? userTax;
  String? userPrice;
  UserModel? captain;
  LocationModel? fromLocation;
  List<LocationModel>? toLocation;
  VehicleModel? vehicle;

  OrderModel(
      {this.id,
      this.createdAt,
      this.createdAtStr,
      this.status,
      this.user,
      this.paymentTypeId,
      this.hours,
      this.timeTaken,
      this.price,
      this.discount,
      this.distance,
      this.userTax,
      this.userPrice,
      this.captain,
      this.fromLocation,
      this.toLocation,
      this.vehicle});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    createdAtStr = json['created_at_str'];
    status = json['status'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    paymentTypeId = json['payment_type_id'];
    hours = json['hours'];
    timeTaken = json['time_taken'];
    price = json['price'];
    discount = json['discount'];
    distance = json['distance'];
    userTax = json['userTax'];
    userPrice = json['userPrice'];
    captain = (json['captain'] != null && json['captain'] is Map)
        ? UserModel.fromJson(json['captain'])
        : null;
    fromLocation = json['fromLocation'] != null
        ? LocationModel.fromJson(json['fromLocation'])
        : null;
    if (json['toLocation'] != null) {
      toLocation = <LocationModel>[];
      json['toLocation'].forEach((v) {
        toLocation!.add(LocationModel.fromJson(v));
      });
    }

    vehicle = (json['Vehicles'] != null && json['Vehicles'] is Map)
        ? VehicleModel.fromJson(json['Vehicles'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['created_at_str'] = createdAtStr;
    data['status'] = status;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['payment_type_id'] = paymentTypeId;
    data['hours'] = hours;
    data['time_taken'] = timeTaken;
    data['price'] = price;
    data['discount'] = discount;
    data['distance'] = distance;
    data['userTax'] = userTax;
    data['userPrice'] = userPrice;
    data['captain'] = captain?.toJson();
    if (fromLocation != null) {
      data['fromLocation'] = fromLocation!.toJson();
    }
    if (toLocation != null) {
      data['toLocation'] = toLocation!.map((v) => v.toJson()).toList();
    }
    data['Vehicles'] = vehicle?.toJson();
    return data;
  }
}
