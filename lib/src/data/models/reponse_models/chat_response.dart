import 'package:seda/src/data/models/message_model.dart';
import 'package:seda/src/data/models/user_model.dart';

class ChatResponse {
  String? message;
  ChatRoom? data;

  ChatResponse({this.message, this.data});

  ChatResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? ChatRoom.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ChatRoom {
  List<MessageModel>? massages;
  UserModel? fromUser;
  UserModel? toUser;
  int? roomId;

  ChatRoom({this.massages, this.fromUser, this.toUser, this.roomId});

  ChatRoom.fromJson(Map<String, dynamic> json) {
    if (json['massages'] != null) {
      massages = <MessageModel>[];
      json['massages'].forEach((v) {
        massages!.add(MessageModel.fromJson(v));
      });
    }
    fromUser =
        json['from_user'] != null ? UserModel.fromJson(json['from_user']) : null;
    toUser = json['to_user'] != null ? UserModel.fromJson(json['to_user']) : null;
    roomId = json['room_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (massages != null) {
      data['massages'] = massages!.map((v) => v.toJson()).toList();
    }
    if (fromUser != null) {
      data['from_user'] = fromUser!.toJson();
    }
    if (toUser != null) {
      data['to_user'] = toUser!.toJson();
    }
    data['room_id'] = roomId;
    return data;
  }
}

