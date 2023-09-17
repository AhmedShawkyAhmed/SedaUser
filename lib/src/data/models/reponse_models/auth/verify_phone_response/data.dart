class Data {
  String? token;
  String? otp;

  Data({
    required this.token,
    required this.otp,
  });

  Data.fromJson(dynamic json)
      : token = json['token'],
        otp = "${json['otp']}";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['otp'] = otp;
    return map;
  }
}
