import 'package:boba_me/model/boba_cart_model.dart';
import 'package:boba_me/model/boba_order_model.dart';
import 'package:boba_me/ui/orders_screen.dart';
import 'package:boba_me/ui/product_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_widgets/custom_widgets.dart';
// TODO: properly style this screen.
class OrderProgressScreen extends StatefulWidget {
  @override
  _OrderProgressScreenState createState() => _OrderProgressScreenState();
}

class _OrderProgressScreenState extends State<OrderProgressScreen> {
  @override
  Widget build(BuildContext context) {
    BobaCartModel bobaCart = Provider.of<BobaCartModel>(context);
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("images/drink.png"),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "We are now processing your Boba.",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                "Thank you for ordering!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              processOrderWidget(context, bobaCart),
            ],
          ),
        ),
      ),
    );
  }

  Widget processOrderWidget (BuildContext context, BobaCartModel bobaCart) {
    var orderProgressCount = 0;
    debugPrint("${bobaCart.bobaOrdersMap.length}");
    try {
      bobaCart.bobaOrdersMap.forEach((key, value) async {
        BobaOrderModel order = value;
        await Firestore.instance.collection('BobaOrders').add(
            {
              'customer_info_id': bobaCart.bobaCustomerInfo.uid,
              'boba_product_name': order.bobaProductName,
              'milk_type': order.milkTypeName,
              'sweetness_level': order.sweetnessLevelName,
              'ice_level': order.iceLevelName,
              'toppings': order.toppingsName,
              'order_count': order.orderCount,
              'customer_name': bobaCart.bobaCustomerInfo.customerName,
              'email': bobaCart.bobaCustomerInfo.email,
              'deliver_to': bobaCart.bobaCustomerInfo.deliverTo,
              'address_line_1': bobaCart.bobaCustomerInfo.addressLine1,
              'address_line_2': bobaCart.bobaCustomerInfo.addressLine2,
              'town_city': bobaCart.bobaCustomerInfo.townCity,
              'province': bobaCart.bobaCustomerInfo.province,
              'phone_number': bobaCart.bobaCustomerInfo.phoneNumber,
              'order_status': 'REQUESTED',
              'order_status_date': DateTime.now().toUtc().toString(),
              'order_total': bobaCart.orderTotal,
              // TODO: the above info might need added information during order saving.
            }
        );
      });
    }catch(e){
      print(e);

    }

    return Column(
      children: <Widget>[
        RaisedButton(
          child: Text(
            "View your Orders!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: (){
            bobaCart.clearOrders();
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => OrdersScreen(),
            ));
          },
        ),
        RaisedButton(
          child: Text(
              "Continue Shopping for Boba!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: (){
            bobaCart.clearOrders();
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ProductScreen(),
            ));
          },
        ),
      ],
    );
  }
}

