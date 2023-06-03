import 'package:boba_me/model/boba_cart_model.dart';
import 'package:boba_me/ui/login_screen.dart';
import 'package:boba_me/ui/orders_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_widgets/custom_widgets.dart';

class ProfileScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    BobaCartModel bobaCartModel = Provider.of<BobaCartModel>(context);
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          ButtonSwitchBanner(
            button1Text: "PROFILE",
            button2Text: "ORDERS",
            button1Highlighted: true,
            button2Highlighted: false,
            button1DestScreenWidget: null,
            button2DestScreenWidget: OrdersScreen(),
          ),
          Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 150,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    height: 500.0,
                    color: Colors.blueGrey.shade900,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 100,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              bobaCartModel.bobaCustomerInfo.firstName,
                              style: TextStyle(
                                  color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                                bobaCartModel.bobaCustomerInfo.lastName,
                                style: TextStyle(
                                    color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                                bobaCartModel.bobaCustomerInfo.email,
                                style: TextStyle(
                                    color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  child: Icon(
                                    Icons.mode_edit,
                                    color: Colors.pinkAccent,
                                  ),
                                  onTap: () {
                                    // TODO: Implement Edit Profile
                                    debugPrint("Edit Profile clicked");
                                  },
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "EDIT",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 90,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                                _auth.signOut();
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ));
                              },
                              child: Text(
                                "LOGOUT",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 3,
                                    color: Colors.pinkAccent
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: 103.0,
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: 100.0,
                    backgroundImage: AssetImage(
                      "images/default_profile.png",
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: BobaNavigationBar(
        bobaCartModel: bobaCartModel,
        activeScreen: "PROFILE_SCREEN",
      ),
    );
  }
}
