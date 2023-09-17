import 'package:seda/src/data/models/user_model.dart';

class Data {
  Data({
    this.user,
  });

  Data.fromJson(dynamic json) :
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;


  UserModel? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (user != null) {
      map['user'] = user!.toJson();
    }
    return map;
  }
}
