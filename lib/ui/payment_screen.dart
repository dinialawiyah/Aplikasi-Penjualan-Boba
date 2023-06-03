import 'package:boba_me/model/boba_customer.dart';
import 'package:boba_me/model/boba_cart_model.dart';
import 'package:boba_me/ui/order_progress.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:boba_me/ui/product_screen.dart';
import 'custom_widgets/custom_widgets.dart';

BobaCustomer _bobaCustomer;
BobaCartModel _bobaCart;

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController nameOnCardController;
  TextEditingController cardNumberController;
  TextEditingController expirationDateController;
  TextEditingController cvvController;
  bool orderInProgress = false;

  @override
  void initState() {
    super.initState();
    nameOnCardController = TextEditingController();
    cardNumberController = TextEditingController();
    expirationDateController = TextEditingController();
    cvvController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _bobaCart = Provider.of<BobaCartModel>(context);
    _bobaCustomer = _bobaCart.bobaCustomerInfo;
//    debugPrint("Address 2 = ${_bobaCustomer.addressLine2}");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.pinkAccent),
        title: Text(
          "PAYMENT",
            style: TextStyle(
              color: Colors.white,
              //fontSize: 19,
              fontWeight: FontWeight.bold,
              letterSpacing: 3
            ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: ListView(
          children: <Widget>[
            Text(
              "DELIVER TO:",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
                (_bobaCustomer.deliverTo == null) ? "" :
              _bobaCustomer.deliverTo.toString(),
              style: TextStyle(
                color: Colors.white30,
                fontSize: 15,
              ),
            ),
           Text(
             (_bobaCustomer.addressLine1 == null) ? "" :
              _bobaCustomer.addressLine1,
              style: TextStyle(
                color: Colors.white30,
                fontSize: 15,
              ),
            ),
            (_bobaCustomer.addressLine2 != null && _bobaCustomer.addressLine2.isNotEmpty) ?  Text(
              _bobaCustomer.addressLine2,
              style: TextStyle(
                color: Colors.white30,
                fontSize: 15,
              ),
            ) : Container(),
            Text(
              (_bobaCustomer.townCity == null && _bobaCustomer.province == null)
                  ? "" : _bobaCustomer.townCity + " " + _bobaCustomer.province,
              style: TextStyle(
                color: Colors.white30,
                fontSize: 15,
              ),
            ),
            Text(
              _bobaCustomer.phoneNumber == null ? "" : _bobaCustomer.phoneNumber,
              style: TextStyle(
                color: Colors.white30,
                fontSize: 15,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 15),
              child: Container(
                color: Colors.white12,
                child: SizedBox(
                  height: 2,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            BobaTextfield(
              textFieldLabel: "NAME ON CARD",
              inputController: nameOnCardController,
              enabled: true,
              fontSize: 19,
            ),
            BobaTextfield(
              textFieldLabel: "CARD NUMBER",
              inputController: cardNumberController,
              enabled: true,
              fontSize: 19,
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: BobaTextfield(
                    textFieldLabel: "EXPIRATION DATE",
                    inputController: expirationDateController,
                    enabled: true,
                    fontSize: 19,
                  ),
                  flex: 3,
                ),
                Flexible(
                  child: BobaTextfield(
                    textFieldLabel: "CVV",
                    inputController: cvvController,
                    enabled: true,
                    fontSize: 19,
                  ),
                  flex: 1,
                ),
              ],
            ),
            SizedBox(
              height: 90,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "ORDER TOTAL:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "PHP ${double.parse(_bobaCart.orderTotal.toString()).toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
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
                textColor: Colors.white,
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
              RaisedButton(
                child: Text(
                  "   PAY   ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19
                  ),
                ),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed:
                ()  {
                  orderInProgress = true;
//                  try {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(
                          "Place Order?"
                        ),
                       actions: <Widget>[
                         RaisedButton(
                           child: Text(
                             "CANCEL"
                           ),
                           onPressed: () {
                             Navigator.pop(context);
                           },
                         ),
                         SizedBox(
                           width: 10.0,
                         ),
                         RaisedButton(
                           child: Text(
                             "YES"
                           ),
                           onPressed: () {
                             Navigator.push(context, MaterialPageRoute(
                               builder: (context) => OrderProgressScreen(),
                             ));
                           },
                         )
                       ],
                      ),
                    );
//                  }catch(e) {
//                    debugPrint(e);
//                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
