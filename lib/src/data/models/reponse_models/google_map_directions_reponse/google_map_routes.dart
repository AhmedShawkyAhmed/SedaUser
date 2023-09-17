
import 'package:seda/src/data/models/reponse_models/google_map_directions_reponse/google_map_bounds.dart';
import 'package:seda/src/data/models/reponse_models/google_map_directions_reponse/google_map_legs.dart';
import 'package:seda/src/data/models/reponse_models/google_map_directions_reponse/google_map_polyline.dart';

class Routes {
  Bounds? bounds;
  List<Legs>? legs;
  Polyline? overviewPolyline;
  String? summary;

  Routes({this.bounds, this.legs, this.overviewPolyline, this.summary});

  Routes.fromJson(Map<String, dynamic> json) {
    bounds =
    json['bounds'] != null ? Bounds.fromJson(json['bounds']) : null;
    if (json['legs'] != null) {
      legs = <Legs>[];
      json['legs'].forEach((v) {
        legs!.add(Legs.fromJson(v));
      });
    }
    overviewPolyline = json['overview_polyline'] != null
        ? Polyline.fromJson(json['overview_polyline'])
        : null;
    summary = json['summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bounds != null) {
      data['bounds'] = bounds!.toJson();
    }
    if (legs != null) {
      data['legs'] = legs!.map((v) => v.toJson()).toList();
    }
    if (overviewPolyline != null) {
      data['overview_polyline'] = overviewPolyline!.toJson();
    }
    data['summary'] = summary;
    return data;
  }
}