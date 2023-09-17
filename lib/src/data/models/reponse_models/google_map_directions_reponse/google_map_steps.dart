import 'package:seda/src/data/models/reponse_models/google_map_directions_reponse/google_map_distance.dart';
import 'package:seda/src/data/models/reponse_models/google_map_directions_reponse/google_map_northest.dart';
import 'package:seda/src/data/models/reponse_models/google_map_directions_reponse/google_map_polyline.dart';

class Steps {
  Distance? distance;
  Distance? duration;
  Northeast? endLocation;
  String? htmlInstructions;
  Polyline? polyline;
  Northeast? startLocation;
  String? travelMode;
  String? maneuver;

  Steps(
      {this.distance,
      this.duration,
      this.endLocation,
      this.htmlInstructions,
      this.polyline,
      this.startLocation,
      this.travelMode,
      this.maneuver});

  Steps.fromJson(Map<String, dynamic> json) {
    distance =
        json['distance'] != null ? Distance.fromJson(json['distance']) : null;
    duration =
        json['duration'] != null ? Distance.fromJson(json['duration']) : null;
    endLocation = json['end_location'] != null
        ? Northeast.fromJson(json['end_location'])
        : null;
    htmlInstructions = json['html_instructions'];
    polyline =
        json['polyline'] != null ? Polyline.fromJson(json['polyline']) : null;
    startLocation = json['start_location'] != null
        ? Northeast.fromJson(json['start_location'])
        : null;
    travelMode = json['travel_mode'];
    maneuver = json['maneuver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (distance != null) {
      data['distance'] = distance!.toJson();
    }
    if (duration != null) {
      data['duration'] = duration!.toJson();
    }
    if (endLocation != null) {
      data['end_location'] = endLocation!.toJson();
    }
    data['html_instructions'] = htmlInstructions;
    if (polyline != null) {
      data['polyline'] = polyline!.toJson();
    }
    if (startLocation != null) {
      data['start_location'] = startLocation!.toJson();
    }
    data['travel_mode'] = travelMode;
    data['maneuver'] = maneuver;
    return data;
  }
}
