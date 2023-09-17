import 'package:seda/src/data/models/message_model.dart';

class NewMessageEventResponse {
  String? event;
  String? message;
  MessageModel? data;

  NewMessageEventResponse({this.event, this.message, this.data});

  NewMessageEventResponse.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    message = json['message'];
    data = json['data'] != null ? MessageModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event'] = event;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
