class PromoModel {
  String? message;
  Data? data;

  PromoModel({this.message, this.data});

  PromoModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  List<PromoCodes> promoCodes = [];

  Data();

  Data.fromJson(Map<String, dynamic> json) {
    if (json['promoCodes'] != null) {
      promoCodes = <PromoCodes>[];
      json['promoCodes'].forEach((v) {
        promoCodes.add(PromoCodes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promoCodes'] = promoCodes.map((v) => v.toJson()).toList();
    return data;
  }
}

class PromoCodes {
  int? userId;
  int? promoType;
  String? title;
  String? code;
  int? type;
  int? discount;
  int? numOfUse;
  int? numOfApply;
  int? minAmount;
  int? maxAmount;
  String? startAt;
  String? expireAt;
  String? appKey;

  PromoCodes(
      {this.userId,
      this.promoType,
      this.title,
      this.code,
      this.type,
      this.discount,
      this.numOfUse,
      this.numOfApply,
      this.minAmount,
      this.maxAmount,
      this.startAt,
      this.expireAt,
      this.appKey});

  PromoCodes.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    promoType = json['promo_type'];
    title = json['title'];
    code = json['code'];
    type = json['type'];
    discount = json['discount'];
    numOfUse = json['num_of_use'];
    numOfApply = json['num_of_apply'];
    minAmount = json['min_amount'];
    maxAmount = json['max_amount'];
    startAt = json['start_at'];
    expireAt = json['expire_at'];
    appKey = json['appKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['promo_type'] = promoType;
    data['title'] = title;
    data['code'] = code;
    data['type'] = type;
    data['discount'] = discount;
    data['num_of_use'] = numOfUse;
    data['num_of_apply'] = numOfApply;
    data['min_amount'] = minAmount;
    data['max_amount'] = maxAmount;
    data['start_at'] = startAt;
    data['expire_at'] = expireAt;
    data['appKey'] = appKey;
    return data;
  }
}
