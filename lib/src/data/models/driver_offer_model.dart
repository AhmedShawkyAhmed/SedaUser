// ignore_for_file: non_constant_identifier_names

import 'package:seda/src/data/models/user_model.dart';

class DriverOfferModel {
  UserModel? driver;
  int? driver_price;
  int? order_sent_to_driver_id;

  DriverOfferModel({
    this.driver,
    this.driver_price,
    this.order_sent_to_driver_id,
  });
}
