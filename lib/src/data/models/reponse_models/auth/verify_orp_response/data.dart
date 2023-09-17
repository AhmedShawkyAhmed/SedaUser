class Data {
  Data({
    this.token,
    this.user,
  });

  Data.fromJson(dynamic json)
      : token = json['token'],
        user = json['user'];

  String? token;
  bool? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['user'] = user;
    return map;
  }
}
