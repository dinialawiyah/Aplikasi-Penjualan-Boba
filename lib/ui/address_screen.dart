import 'package:boba_me/model/boba_cart_model.dart';
import 'package:boba_me/ui/custom_widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:boba_me/model/boba_customer.dart';
import 'package:boba_me/ui/payment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:boba_me/ui/product_screen.dart';


class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController customerNameController;
  TextEditingController deliverToController;
  TextEditingController addressLine1Controller;
  TextEditingController addressLine2Controller;
  TextEditingController cityTownController;
  TextEditingController provinceController;
  TextEditingController phoneNumberController;

  BobaCartModel _bobaCart;
  BobaCustomer bobaCustomer;

  bool addressFieldsCompleted = false;

  @override
  void initState() {
    super.initState();
    customerNameController = TextEditingController();
    deliverToController = TextEditingController();
    addressLine1Controller = TextEditingController();
    addressLine2Controller = TextEditingController();
    cityTownController = TextEditingController();
    cityTownController.value = TextEditingValue(text: "STA. CRUZ");
    provinceController = TextEditingController();
    provinceController.value = TextEditingValue(text: "LAGUNA");
    phoneNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _bobaCart = Provider.of<BobaCartModel>(context);


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.pinkAccent
        ),
        title: Text(
          "ADDRESS",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 3,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: ListView(
            children: <Widget>[
              BobaTextfield(
                textFieldLabel: "CUSTOMER NAME",
                inputController: _getCustomerName(_bobaCart.bobaCustomerInfo),
                enabled: false,
              ),
              BobaTextfield(
                textFieldLabel: "DELIVER TO",
                inputController: deliverToController,
                enabled: true,
                onChanged: (value) {
                  if(deliverToController.text.length > 0
                      && addressLine1Controller.text.length > 0
                      && phoneNumberController.text.length > 0) {
                    setState(() {
                      addressFieldsCompleted = true;
                    });
                  }
                },
              ),
              BobaTextfield(
                textFieldLabel: "ADDRESS LINE 1",
                inputController: addressLine1Controller,
                enabled: true,
                onChanged: (value) {
                  if(deliverToController.text.length > 0
                      && addressLine1Controller.text.length > 0
                      && phoneNumberController.text.length > 0) {
                    setState(() {
                      addressFieldsCompleted = true;
                    });
                  }
                },
              ),
              BobaTextfield(
                textFieldLabel: "ADDRESS LINE 2",
                inputController: addressLine2Controller,
                enabled: true,
              ),
              BobaTextfield(
                textFieldLabel: "CITY/TOWN",
                inputController: cityTownController,
                enabled: false,
              ),
              BobaTextfield(
                textFieldLabel: "PROVINCE",
                inputController: provinceController,
                enabled: false,
              ),
              BobaTextfield(
                textFieldLabel: "PHONE NUMBER",
                inputController: phoneNumberController,
                enabled: true,
                onChanged: (value) {
                  if(deliverToController.text.length > 0
                      && addressLine1Controller.text.length > 0
                      && phoneNumberController.text.length > 0) {
                    setState(() {
                      addressFieldsCompleted = true;
                    });
                  }
                },
              ),
            ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text(
                " CANCEL ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ProductScreen(),
                ),);
              },
            ),
            SizedBox(
              width: 40,
            ),
            addressFieldsCompleted ? RaisedButton(
              child: Text(
                "  NEXT  ",
                style: TextStyle(
                  color: Colors.white,
                    fontSize: 19
                ),
              ),
              onPressed: () {
                setState(() {
                  bobaCustomer = BobaCustomer(
                    customerName: customerNameController.value.text,
                    deliverTo: deliverToController.value.text,
                    addressLine1: addressLine1Controller.value.text,
                    addressLine2: addressLine2Controller.value.text,
                    townCity: cityTownController.value.text,
                    province: provinceController.value.text,
                    phoneNumber: phoneNumberController.value.text,
                    uid: _bobaCart.bobaCustomerInfo.uid,
                    firstName: _bobaCart.bobaCustomerInfo.firstName,
                    lastName: _bobaCart.bobaCustomerInfo.lastName,
                    email: _bobaCart.bobaCustomerInfo.email,
                  );
                  _bobaCart.assignBobaCustomer(bobaCustomer);
                });
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => PaymentScreen(),
                ));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ) : RaisedButton (
              child: Text(
                "  NEXT  ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 19
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ],
        ),
      )
    );
  }

  _getCustomerName(BobaCustomer bobaCustomerInfo) {
    customerNameController.value = TextEditingValue(text: "${bobaCustomerInfo.firstName} ${bobaCustomerInfo.lastName}");
    return customerNameController;
  }
}
