class LiveLocation {
  String? event;
  String? message;
  Data? data;

  LiveLocation({this.event, this.message, this.data});

  LiveLocation.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  double? lat;
  double? lng;
  double? heading;

  Data({this.lat, this.lng, this.heading});

  Data.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    heading = json['heading'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    data['heading'] = heading;
    return data;
  }
}
