import 'package:boba_me/model/boba_cart_model.dart';
import 'package:boba_me/ui/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'custom_widgets/custom_widgets.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _auth = FirebaseAuth.instance;

  var bobaOrdersDb =
  Firestore.instance.collection('BobaOrders')
      .where("customer_info_id", isEqualTo: "i36YHr8WeqZW3llfqG7fsQ2NlS92")
      .where("order_status", whereIn: ["REQUESTED", "PROCESSING", "DELIVERY"])
      .orderBy("order_status_date", descending: true).snapshots();

  @override
  Widget build(BuildContext context) {
    BobaCartModel bobaCartModel = Provider.of<BobaCartModel>(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          ButtonSwitchBanner(
            button1Text: "PROFILE",
            button2Text: "ORDERS",
            button1Highlighted: false,
            button2Highlighted: true,
            button1DestScreenWidget: ProfileScreen(),
            button2DestScreenWidget: null,
          ),
          Text(
            "MOST RECENT",
            style: TextStyle(
              color: Colors.white30,
              letterSpacing: 2,
            ),
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: bobaOrdersDb,
              builder: (context, snapshots) {
                if (!snapshots.hasData) return CircularProgressIndicator();
//                  debugPrint("snapshots.data.documents.length : ${snapshots.data.documents.length}");
                return ListView.builder(
                  itemCount: snapshots.data.documents.length,
                  itemBuilder: (context, int index) {
//                      debugPrint("index $index");
                    return Container(
                      child: Column(
                        children: <Widget>[
                          FutureBuilder(
                            future: getRequestedCustomerOrders(context, snapshots.data.documents[index]),
                            builder: (context, snapshot) {
                              if(snapshot.connectionState == ConnectionState.done) {
                                return Container(
                                  child: snapshot.data,
                                );
                              }

                              if(snapshot.connectionState == ConnectionState.waiting) {
                                return Container(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ],
                      )
                    );
                  }
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BobaNavigationBar(
        bobaCartModel: bobaCartModel,
      ),
    );
  }

  Future<Widget> getRequestedCustomerOrders(BuildContext context, DocumentSnapshot document) async {
    Image productImage;
    await FirebaseStorage.instance
    .ref()
    .child("${document['boba_product_name'].toString().toLowerCase()}.png")
    .getDownloadURL()
    .then((value) => {productImage = Image.network(value.toString())});

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 70.0,
          backgroundImage: productImage.image,
        ),
        Text(
          "${document['boba_product_name']} Boba",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 29.0,
          ),
        ),
        Text(
          "${document['milk_type']} | ${document['sweetness_level']} | ${document['ice_level']}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.0,
          ),
        ),
        Text(
          "Toppings: ${document['toppings'].toString().isEmpty ? "No toppings" : document['toppings']}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.0,
          ),
        ),
        Text(
          "QTY: ${document['order_count']}",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Text(
          "${DateFormat('MM/dd/yyyy').format(DateTime.parse(document['order_status_date']))}",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
        Text(
          "Order: ${document['order_status']}",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        Text(
          "Deliver to: ${document['deliver_to']}",
          style: TextStyle(
            color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
        Text(
          "Order Total: Php ${double.parse(document['order_total'].toString()).toStringAsFixed(2)}",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SizedBox(
            width: 250,
            child: Divider(
              color: Colors.white54,
            ),
          ),
        ),
      ],
    );
  }
}




