class Cars {
  String? message;
  Data? data;

  Cars({this.message, this.data});

  Cars.fromJson(Map<String, dynamic> json) {
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
  List<Car>? serial;
  dynamic offer;
  List<Car>? hours;

  Data({this.serial, this.offer, this.hours});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['serial'] != null) {
      serial = <Car>[];
      json['serial'].forEach((v) {
        serial!.add(Car.fromJson(v));
      });
    }
    offer = json['offer'];
    if (json['hours'] != null) {
      hours = <Car>[];
      json['hours'].forEach((v) {
        hours!.add(Car.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (serial != null) {
      data['serial'] = serial!.map((v) => v.toJson()).toList();
    }
    data['offer'] = offer;
    if (hours != null) {
      data['hours'] = hours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Car {
  int? id;
  String? name;
  String? price;
  String? discount;
  String? discountValue;
  String? userPrice;
  String? distance;
  String? time;
  dynamic image;
  int? shipmentTypeId;
  int? moveMinutePrice;

  Car(
      {this.id,
      this.name,
      this.price,
      this.discount,
      this.discountValue,
      this.userPrice,
      this.distance,
      this.time,
      this.shipmentTypeId,
      this.moveMinutePrice,
      this.image});

  Car.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    discount = json['discount'];
    discountValue = json['discountValue'];
    userPrice = json['userPrice'];
    distance = json['distance'];
    time = json['time'];
    image = json['image'];
    shipmentTypeId = json['shipment_type_id'];
    moveMinutePrice = json['move_minute_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['discount'] = discount;
    data['discountValue'] = discountValue;
    data['userPrice'] = userPrice;
    data['distance'] = distance;
    data['time'] = time;
    data['move_minute_price'] = moveMinutePrice;
    data['image'] = image;
    data['shipment_type_id'] = shipmentTypeId;
    return data;
  }
}
