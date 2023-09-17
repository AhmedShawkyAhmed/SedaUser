import 'package:seda/src/data/models/media_model.dart';

class MessageModel {
  int? id;
  int? roomId;
  int? fromUserIf;
  int? toUserId;
  String? massage;
  int? createdAt;
  String? createdAtStr;
  MediaModel? medias;

  MessageModel(
      {this.id,
        this.roomId,
        this.fromUserIf,
        this.toUserId,
        this.massage,
        this.createdAt,
        this.createdAtStr,
        this.medias});

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = int.tryParse("${json['room_id']}");
    fromUserIf = json['from_user_if'];
    toUserId = int.tryParse("${json['to_user_id']}");
    massage = json['massage'];
    createdAt = json['created_at'];
    createdAtStr = json['created_at_str'];
    medias = json['medias'] != null ? MediaModel.fromJson(json['medias']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['room_id'] = roomId;
    data['from_user_if'] = fromUserIf;
    data['to_user_id'] = toUserId;
    data['massage'] = massage;
    data['created_at'] = createdAt;
    data['created_at_str'] = createdAtStr;
    if (medias != null) {
      data['medias'] = medias!.toJson();
    }
    return data;
  }
}