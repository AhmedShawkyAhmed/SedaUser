// ignore_for_file: non_constant_identifier_names

import 'package:seda/src/data/models/location_model.dart';
import 'package:seda/src/data/models/user_model.dart';

class GovernResponseModel {
  Data? data;
  String? message;

  GovernResponseModel({this.data, this.message});

  factory GovernResponseModel.fromJson(Map<String, dynamic> json) {
    return GovernResponseModel(
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
  List<Order>? order;

  Data({this.order});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      order: json['order'] != null
          ? (json['order'] as List).map((i) => Order.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (order != null) {
      data['order'] = order?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
  int? created_at;
  String? created_at_str;
  UserModel? driver;
  LocationModel? fromLocation;
  int? id;
  List<dynamic>? passenger;
  int? payment_type_id;
  List<LocationModel>? points;
  String? status;
  LocationModel? toLocation;
  bool? valid;

  Order(
      {this.created_at,
      this.created_at_str,
      this.driver,
      this.fromLocation,
      this.id,
      this.passenger,
      this.payment_type_id,
      this.points,
      this.status,
      this.toLocation,
      this.valid});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      created_at: json['created_at'],
      created_at_str: json['created_at_str'],
      driver: json['captain'] != null ? UserModel.fromJson(json['captain']) : null,
      fromLocation: json['fromLocation'] != null
          ? LocationModel.fromJson(json['fromLocation'])
          : null,
      id: json['id'],
      passenger: json['passenger'] != null
          ? (json['passenger'] as List).map((i) => i).toList()
          : null,
      payment_type_id: json['payment_type_id'],
      points: json['points'] != null
          ? (json['points'] as List).map((i) => LocationModel.fromJson(i)).toList()
          : null,
      status: json['status'],
      toLocation: json['toLocation'] != null
          ? LocationModel.fromJson(json['toLocation'])
          : null,
      valid: json['valid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = created_at;
    data['created_at_str'] = created_at_str;
    data['id'] = id;
    data['payment_type_id'] = payment_type_id;
    data['status'] = status;
    data['valid'] = valid;
    if (driver != null) {
      data['captain'] = driver?.toJson();
    }
    if (fromLocation != null) {
      data['fromLocation'] = fromLocation?.toJson();
    }
    if (passenger != null) {
      data['passenger'] = passenger?.map((v) => v).toList();
    }
    if (points != null) {
      data['points'] = points?.map((v) => v.toJson()).toList();
    }
    if (toLocation != null) {
      data['toLocation'] = toLocation?.toJson();
    }
    return data;
  }
}