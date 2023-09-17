class VehicleModel {
  String? vehicleTypesCompany;
  String? vehicleTypesType;
  String? vehicleTypesModel;
  String? vehicleColorName;
  String? vehicleColorCode;
  String? purchaseYear;
  String? carNumber;
  int? rideTypesId;

  VehicleModel(
      {this.vehicleTypesCompany,
      this.vehicleTypesType,
      this.vehicleTypesModel,
      this.vehicleColorName,
      this.vehicleColorCode,
      this.purchaseYear,
      this.carNumber,
      this.rideTypesId});

  VehicleModel.fromJson(Map<String, dynamic> json) {
    vehicleTypesCompany = json['vehicle_types_company'];
    vehicleTypesType = json['vehicle_types_type'];
    vehicleTypesModel = json['vehicle_types_model'];
    vehicleColorName = json['Vehicle_color_name'];
    vehicleColorCode = json['Vehicle_color_code'];
    purchaseYear = json['purchase_year'];
    carNumber = json['car_number'];
    rideTypesId = json['ride_types_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vehicle_types_company'] = vehicleTypesCompany;
    data['vehicle_types_type'] = vehicleTypesType;
    data['vehicle_types_model'] = vehicleTypesModel;
    data['Vehicle_color_name'] = vehicleColorName;
    data['Vehicle_color_code'] = vehicleColorCode;
    data['purchase_year'] = purchaseYear;
    data['car_number'] = carNumber;
    data['ride_types_id'] = rideTypesId;
    return data;
  }
}
