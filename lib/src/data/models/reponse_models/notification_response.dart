class NotificationResponse {
  String? message;
  Data? data;

  NotificationResponse({this.message, this.data});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Notification>? notifications;

  Data({this.notifications});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['massages'] != null) {
      notifications = <Notification>[];
      json['massages'].forEach((v) {
        notifications!.add(new Notification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notifications != null) {
      data['massages'] = this.notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notification {
  int? id;
  int? userId;
  String? title;
  String? massage;
  int? isSeen;
  int? notificationId;
  int? createdAt;
  String? createdAtStr;

  Notification(
      {this.id,
        this.userId,
        this.title,
        this.massage,
        this.isSeen,
        this.notificationId,
        this.createdAt,
        this.createdAtStr});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    massage = json['massage'];
    isSeen = json['is_seen'];
    notificationId = json['notification_id'];
    createdAt = json['created_at'];
    createdAtStr = json['created_at_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['massage'] = this.massage;
    data['is_seen'] = this.isSeen;
    data['notification_id'] = this.notificationId;
    data['created_at'] = this.createdAt;
    data['created_at_str'] = this.createdAtStr;
    return data;
  }
}
