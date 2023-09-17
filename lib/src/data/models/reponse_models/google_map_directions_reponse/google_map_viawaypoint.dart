import 'package:seda/src/data/models/reponse_models/google_map_directions_reponse/google_map_northest.dart';

class ViaWaypoint {
  Northeast? location;
  int? stepIndex;
  double? stepInterpolation;

  ViaWaypoint({this.location, this.stepIndex, this.stepInterpolation});

  ViaWaypoint.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Northeast.fromJson(json['location']) : null;
    stepIndex = json['step_index'];
    stepInterpolation = json['step_interpolation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['step_index'] = stepIndex;
    data['step_interpolation'] = stepInterpolation;
    return data;
  }
}
