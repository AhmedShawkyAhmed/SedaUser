import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Polyline {
  List<PointLatLng>? points;

  Polyline({this.points});

  Polyline.fromJson(Map<String, dynamic> json) {
    points = PolylinePoints().decodePolyline(json['points']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['points'] = points;
    return data;
  }
}
