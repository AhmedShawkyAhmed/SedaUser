class LocationModel {
  int? id;
  int? createdAt;
  String? createdAtStr;
  String? type;
  double? longitude;
  double? latitude;
  String? address;

  LocationModel(
      {this.id,
      this.createdAt,
      this.createdAtStr,
      this.type,
      this.longitude,
      this.latitude,
      this.address});

  LocationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    createdAtStr = json['created_at_str'];
    type = json['type'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['created_at_str'] = createdAtStr;
    data['type'] = type;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['address'] = address;
    return data;
  }
}
