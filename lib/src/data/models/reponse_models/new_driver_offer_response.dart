// ignore_for_file: non_constant_identifier_names

import 'package:seda/src/data/models/user_model.dart';

class NewDriverOfferResponse {
  Data? data;
  String? event;
  String? message;

  NewDriverOfferResponse({this.data, this.event, this.message});

  factory NewDriverOfferResponse.fromJson(Map<String, dynamic> json) {
    return NewDriverOfferResponse(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      event: json['event'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event'] = event;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {
  String? appKey;
  dynamic cancel_reason;
  dynamic card_id;
  String? created_at;
  UserModel? driver;
  int? driver_price;
  int? id;
  int? order_sent_to_driver_id;
  int? payment_status;
  int? payment_type_id;
  dynamic provider_id;
  dynamic shipment_id;
  int? shipment_type_id;
  String? status;
  String? updated_at;
  int? user_id;

  Data(
      {this.appKey,
      this.cancel_reason,
      this.card_id,
      this.created_at,
      this.driver,
      this.driver_price,
      this.id,
      this.order_sent_to_driver_id,
      this.payment_status,
      this.payment_type_id,
      this.provider_id,
      this.shipment_id,
      this.shipment_type_id,
      this.status,
      this.updated_at,
      this.user_id});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      appKey: json['appKey'],
      cancel_reason: json['cancel_reason'],
      card_id: json['card_id'],
      created_at: json['created_at'],
      driver: json['captain'] != null ? UserModel.fromJson(json['captain']) : null,
      driver_price: json['driver_price'],
      id: json['id'],
      order_sent_to_driver_id: json['order_sent_to_driver_id'],
      payment_status: json['payment_status'],
      payment_type_id: json['payment_type_id'],
      provider_id: json['provider_id'],
      shipment_id: json['shipment_id'],
      shipment_type_id: json['shipment_type_id'],
      status: json['status'],
      updated_at: json['updated_at'],
      user_id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appKey'] = appKey;
    data['created_at'] = created_at;
    data['driver_price'] = driver_price;
    data['id'] = id;
    data['order_sent_to_driver_id'] = order_sent_to_driver_id;
    data['payment_status'] = payment_status;
    data['payment_type_id'] = payment_type_id;
    data['shipment_type_id'] = shipment_type_id;
    data['status'] = status;
    data['updated_at'] = updated_at;
    data['user_id'] = user_id;
    if (cancel_reason != null) {
      data['cancel_reason'] = cancel_reason.toJson();
    }
    if (card_id != null) {
      data['card_id'] = card_id.toJson();
    }
    if (driver != null) {
      data['captain'] = driver?.toJson();
    }
    if (provider_id != null) {
      data['provider_id'] = provider_id.toJson();
    }
    if (shipment_id != null) {
      data['shipment_id'] = shipment_id.toJson();
    }
    return data;
  }
}
