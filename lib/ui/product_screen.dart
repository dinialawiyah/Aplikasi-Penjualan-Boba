import 'package:boba_me/model/boba_cart_model.dart';
import 'package:boba_me/model/boba_customer.dart';
import 'package:boba_me/ui/checkout_screen.dart';
import 'package:boba_me/ui/product_add_screen.dart';
import 'package:boba_me/ui/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'custom_widgets/custom_widgets.dart';

class ProductScreen extends StatefulWidget {
  static const String id = "product_screen";

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _auth = FirebaseAuth.instance;
  var bobaProductsDb =
      Firestore.instance.collection('BobaProducts').snapshots();
  var customerInfoDb =
      Firestore.instance.collection('CustomerInfo').snapshots();

  var bobaCartModel;
  var bobaCustomer = BobaCustomer();

  @override
  void initState() {
    super.initState();
    isCurrentUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    bobaCartModel = Provider.of<BobaCartModel>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Container(),
        iconTheme: IconThemeData(color: Colors.pinkAccent),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: BobaBannerImage(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bobaProductsDb,
        builder: (context, snapshots) {
          if (!snapshots.hasData) return CircularProgressIndicator();

          return ListView.builder(
            itemCount: snapshots.data.documents.length,
            itemBuilder: (context, int index) {
              return Container(
                child: FutureBuilder(
                  future:
                      _getProducts(context, snapshots.data.documents[index]),
                  //_getFirebaseImage(snapshots.data.documents[index]['imageId']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 1.85,
                        width: MediaQuery.of(context).size.width,
                        child: snapshot.data,
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 1.85,
                        width: MediaQuery.of(context).size.width,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                        ),
                      );
                    }
                  },
                ),
              );
            },
            physics: BouncingScrollPhysics(),
          );
        },
      ),
      bottomNavigationBar: BobaNavigationBar(
          bobaCartModel: bobaCartModel,
        activeScreen: "PRODUCT_SCREEN",
      ),
    );
  }

  void isCurrentUserLoggedIn() async {
    final currentUser = await _auth.currentUser();
    if (currentUser != null) {
      print("${currentUser.uid} is logged in");
      // Use the currentUser.uid to get the CustomerInfo details.
      Firestore.instance
          // Get collection of CustomerInfo from Firebase
          .collection('CustomerInfo')
          .getDocuments()
          // Iterate each document from the collection
          .then((value) => value.documents.forEach((element) {
                // if uid from the firebase authentication is equal to CustomerInfo uid, then this is the user.
                if(currentUser.uid == element.data['uid']) {
                  bobaCustomer.email = element.data['email'];
                  bobaCustomer.uid = element.data['uid'];
                  bobaCustomer.firstName = element.data['first_name'];
                  bobaCustomer.lastName = element.data['last_name'];
                  bobaCartModel.assignBobaCustomer(bobaCustomer);
                }
              }));
    } else {}
  }

  @override
  void dispose() {
    super.dispose();
    _auth.signOut();
    print("user has signed-out");
  }
}

Future<Widget> _getFirebaseImage(url) async {
  Image image;
  await FirebaseStorage.instance
      .ref()
      .child(url)
      .getDownloadURL()
      .then((value) => {image = Image.network(value.toString())});

  return image;
}

Future<Widget> _getProducts(context, firebaseDocument) async {
  Image productImage;
  await FirebaseStorage.instance
      .ref()
      .child(firebaseDocument['imageId'])
      .getDownloadURL()
      .then((value) => {productImage = Image.network(value.toString())});

  // put the image and its name, text and price in a stack
  return Stack(
    alignment: Alignment.center,
    children: <Widget>[
      productImage,
      Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.58,
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 12.5,
              ),
              Text(
                firebaseDocument['name'].toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.ltr,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.height / 6.5,
                child: Text(
                  "${firebaseDocument['description'].toString()}\n\n"
                  "Php ${double.parse(firebaseDocument['price'].toString()).toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 12.5,
              ),
              InkWell(
                child: Text(
                  "ADD",
                  style: TextStyle(
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 29),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: ProductAddScreen(
                        bobaProductName: firebaseDocument['name'].toString(),
                        bobaProductPrice: firebaseDocument['price'] * 1.0,
                        editOrder: false,
                        editMilkType: null,
                        editSweetnessLevel: null,
                        editIceLevel: null,
                        editToppings: null,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ],
      ),
    ],
  );
}
