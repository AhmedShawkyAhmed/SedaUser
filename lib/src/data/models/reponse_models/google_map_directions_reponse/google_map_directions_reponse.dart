import 'package:seda/src/data/models/reponse_models/google_map_directions_reponse/google_map_routes.dart';

class GoogleMapDirections {
  List<Routes>? routes;
  String? status;

  GoogleMapDirections({this.routes, this.status});

  GoogleMapDirections.fromJson(Map<String, dynamic> json) {
    if (json['routes'] != null) {
      routes = <Routes>[];
      json['routes'].forEach((v) {
        routes!.add(Routes.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (routes != null) {
      data['routes'] = routes!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}