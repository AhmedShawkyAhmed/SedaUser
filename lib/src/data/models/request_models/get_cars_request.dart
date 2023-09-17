class GetCarsRequest {
  final double fromLat;
  final double fromLng;
  final List<List<double>> toLocations;
  final int shipmentType;

  GetCarsRequest({
    required this.fromLat,
    required this.fromLng,
    required this.toLocations,
    required this.shipmentType,
  });

  Map<String, dynamic> toJson() {
    final body = <String, dynamic>{
      'fromLat': fromLat,
      'fromLng': fromLng,
      'shipmentType': shipmentType,
    };
    body["toLat"] = toLocations.map((e) => e[0]).toList();
    body["toLng"] = toLocations.map((e) => e[1]).toList();
    return body;
  }
}
