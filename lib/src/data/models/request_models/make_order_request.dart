class MakeOrderRequest {
  final double fromLocationLat;
  final double fromLocationLon;
  final String fromLocationAddress;
  final int? hours;
  final List<List<dynamic>> toLocations;

  MakeOrderRequest({
    required this.fromLocationLat,
    required this.fromLocationLon,
    required this.fromLocationAddress,
    required this.toLocations,
    this.hours,
  });
}

class AddNewDropOff {
  final int orderId;
  final double toLocationLat;
  final double toLocationLon;
  final String toLocationAddress;

  AddNewDropOff({
    required this.orderId,
    required this.toLocationLat,
    required this.toLocationLon,
    required this.toLocationAddress,
  });
}
