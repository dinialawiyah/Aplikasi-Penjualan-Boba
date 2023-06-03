import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAdapter {
  var bobaProductsDb =
  Firestore.instance.collection('BobaProducts').snapshots();
  var customerInfoDb =
  Firestore.instance.collection('CustomerInfo').snapshots();

}