part of 'api_location_address_response.dart';

class ApiLocationAddress {
  String? houseNumber;
  String? road;
  String? neighbourhood;
  String? suburb;
  String? state;
  String? iSO31662Lvl4;
  String? postcode;
  String? country;
  String? countryCode;

  ApiLocationAddress(
      {this.houseNumber,
        this.road,
        this.neighbourhood,
        this.suburb,
        this.state,
        this.iSO31662Lvl4,
        this.postcode,
        this.country,
        this.countryCode});

  ApiLocationAddress.fromJson(Map<String, dynamic> json) {
    houseNumber = json['house_number'];
    road = json['road'];
    neighbourhood = json['neighbourhood'];
    suburb = json['suburb'];
    state = json['state'];
    iSO31662Lvl4 = json['ISO3166-2-lvl4'];
    postcode = json['postcode'];
    country = json['country'];
    countryCode = json['country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['house_number'] = houseNumber;
    data['road'] = road;
    data['neighbourhood'] = neighbourhood;
    data['suburb'] = suburb;
    data['state'] = state;
    data['ISO3166-2-lvl4'] = iSO31662Lvl4;
    data['postcode'] = postcode;
    data['country'] = country;
    data['country_code'] = countryCode;
    return data;
  }
}