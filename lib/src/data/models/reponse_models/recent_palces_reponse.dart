import 'package:seda/src/data/models/location_model.dart';

class RecentPlacesResponse {
  String? message;
  Data? data;

  RecentPlacesResponse({this.message, this.data});

  RecentPlacesResponse.fromJson(Map<String, dynamic> json) {
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
  List<LocationModel> lastLocations = [];

  Data();

  Data.fromJson(Map<String, dynamic> json) {
    if (json['lastLocations'] != null) {
      lastLocations = <LocationModel>[];
      json['lastLocations'].forEach((v) {
        lastLocations.add(LocationModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['lastLocations'] = lastLocations.map((v) => v.toJson()).toList();

    return data;
  }
}
