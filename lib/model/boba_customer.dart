import 'package:flutter/material.dart';

import 'boba_cart_model.dart';

class BobaCustomer {
  String customerName;
  String deliverTo;
  String addressLine1;
  String addressLine2;
  String townCity;
  String province;
  String phoneNumber;
  String uid;
  String email;
  String firstName;
  String lastName;

  BobaCustomer({this.customerName, this.deliverTo, this.addressLine1,
    this.addressLine2, this.townCity, this.province, this.phoneNumber,
    this.uid, this.email, this.firstName, this.lastName
  });
}