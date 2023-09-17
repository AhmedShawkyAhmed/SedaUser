import 'package:seda/src/data/models/reponse_models/google_map_directions_reponse/google_map_distance.dart';
import 'package:seda/src/data/models/reponse_models/google_map_directions_reponse/google_map_northest.dart';
import 'package:seda/src/data/models/reponse_models/google_map_directions_reponse/google_map_steps.dart';
import 'package:seda/src/data/models/reponse_models/google_map_directions_reponse/google_map_viawaypoint.dart';

class Legs {
  Distance? distance;
  Distance? duration;
  String? endAddress;
  Northeast? endLocation;
  String? startAddress;
  Northeast? startLocation;
  List<Steps>? steps;
  List<dynamic>? trafficSpeedEntry;
  List<ViaWaypoint>? viaWaypoint;

  Legs(
      {this.distance,
        this.duration,
        this.endAddress,
        this.endLocation,
        this.startAddress,
        this.startLocation,
        this.steps,
        this.trafficSpeedEntry,
        this.viaWaypoint});

  Legs.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] != null
        ? Distance.fromJson(json['distance'])
        : null;
    duration = json['duration'] != null
        ? Distance.fromJson(json['duration'])
        : null;
    endAddress = json['end_address'];
    endLocation = json['end_location'] != null
        ? Northeast.fromJson(json['end_location'])
        : null;
    startAddress = json['start_address'];
    startLocation = json['start_location'] != null
        ? Northeast.fromJson(json['start_location'])
        : null;
    if (json['steps'] != null) {
      steps = <Steps>[];
      json['steps'].forEach((v) {
        steps!.add(Steps.fromJson(v));
      });
    }
    if (json['traffic_speed_entry'] != null) {
      trafficSpeedEntry = <Null>[];
      json['traffic_speed_entry'].forEach((v) {
        trafficSpeedEntry!.add(v);
      });
    }
    if (json['via_waypoint'] != null) {
      viaWaypoint = <ViaWaypoint>[];
      json['via_waypoint'].forEach((v) {
        viaWaypoint!.add(ViaWaypoint.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (distance != null) {
      data['distance'] = distance!.toJson();
    }
    if (duration != null) {
      data['duration'] = duration!.toJson();
    }
    data['end_address'] = endAddress;
    if (endLocation != null) {
      data['end_location'] = endLocation!.toJson();
    }
    data['start_address'] = startAddress;
    if (startLocation != null) {
      data['start_location'] = startLocation!.toJson();
    }
    if (steps != null) {
      data['steps'] = steps!.map((v) => v.toJson()).toList();
    }
    if (trafficSpeedEntry != null) {
      data['traffic_speed_entry'] =
          trafficSpeedEntry!.map((v) => v.toJson()).toList();
    }
    if (viaWaypoint != null) {
      data['via_waypoint'] = viaWaypoint!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}