class CreateOrUpdateLocationRequest {
  final double lat;
  final double lon;
  final String address;
  final String type;
  int? locationId;

  CreateOrUpdateLocationRequest({
    required this.lat,
    required this.lon,
    required this.address,
    required this.type,
    this.locationId,
  });

  Map<String, dynamic> toJson() => {
        'longitude': lon,
        'latitude': lat,
        'address': address,
        'type': type,
        if (locationId != null) 'id': locationId,
      };
}
