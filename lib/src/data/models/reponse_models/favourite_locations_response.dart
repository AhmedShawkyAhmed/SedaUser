import 'package:seda/src/data/models/location_model.dart';

class FavouriteLocationsResponse {
  Data? data;
  String? message;

  FavouriteLocationsResponse({this.data, this.message});

  factory FavouriteLocationsResponse.fromJson(Map<String, dynamic> json) {
    return FavouriteLocationsResponse(
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
  List<LocationModel>? fav;
  LocationModel? home;
  LocationModel? work;

  Data({this.fav, this.home, this.work});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      fav: json['fav'] != null
          ? (json['fav'] as List)
              .map((i) => LocationModel.fromJson(i))
              .toList()
          : null,
      home: json['home'] != null
          ? LocationModel.fromJson(json['home'])
          : null,
      work: json['work'] != null
          ? LocationModel.fromJson(json['work'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fav != null) {
      data['fav'] = fav?.map((v) => v.toJson()).toList();
    }
    if (home != null) {
      data['home'] = home?.toJson();
    }
    if (work != null) {
      data['work'] = work?.toJson();
    }
    return data;
  }
}
