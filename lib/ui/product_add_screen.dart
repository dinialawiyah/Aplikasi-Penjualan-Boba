import 'package:boba_me/model/boba_cart_model.dart';
import 'package:boba_me/model/boba_order_model.dart';
import 'package:boba_me/ui/checkout_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'custom_widgets/custom_widgets.dart';

class ProductAddScreen extends StatefulWidget {
  static const id = "ProductAddScreen";
  final String bobaProductName;
  final double bobaProductPrice;
  final bool editOrder;
  final String editMilkType;
  final String editSweetnessLevel;
  final String editIceLevel;
  final String editToppings;
  final String editOrderKey;

  // TODO: Is constructor necessary here? Maybe we can use BobaCart to edit the order.
  const ProductAddScreen({Key key, this.bobaProductName, this.bobaProductPrice, this.editMilkType, this.editSweetnessLevel, this.editIceLevel, this.editToppings, this.editOrder, this.editOrderKey}) : super(key: key);

  @override
  _ProductAddScreenState createState() => _ProductAddScreenState(
      bobaName: bobaProductName,
      bobaPrice: bobaProductPrice,
      editOrder: editOrder,
      editMilkType: editMilkType,
      editSweetnessLevel: editSweetnessLevel,
      editIceLevel: editIceLevel,
      editToppings: editToppings,
      editOrderKey: editOrderKey,
  );
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final String bobaName;
  final double bobaPrice;
  final bool editOrder;
  final String editMilkType;
  final String editSweetnessLevel;
  final String editIceLevel;
  final String editToppings;
  final String editOrderKey;

  _ProductAddScreenState({this.editOrder, this.editSweetnessLevel, this.editIceLevel, this.editToppings, this.bobaName, this.bobaPrice,this.editMilkType,this.editOrderKey,});
  FirebaseAuth _auth = FirebaseAuth.instance;
  var iceLevelDb = Firestore.instance.collection('IceLevel').snapshots();
  var milkTypeDb = Firestore.instance.collection('MilkType').snapshots();
  var sweetnessDb = Firestore.instance.collection('SweetnessLevel').snapshots();
  var toppingsDb = Firestore.instance.collection('Toppings').snapshots();
  int _totalPrice;
  String _milkType;
  String _sweetness;
  String _iceLevel;
  String _topping;
  double toppingsPrice = 0.0;
  bool orderComplete = false;

  List<RadioModel> toppingsRadioList = List<RadioModel>();

  @override
  void initState() {
    super.initState();
    // Hardcoded the Toppings list. Unable to implement coming from Firebase Database.
    toppingsRadioList.add(RadioModel(false, "Small Tapioca", "Small Tapioca"));
    toppingsRadioList.add(RadioModel(false, "Large Tapioca", "Large Tapioca"));
    toppingsRadioList.add(RadioModel(false, "Lychee Jelly", "Lychee Jelly"));

    if(editMilkType != null) {
      _milkType = editMilkType;
    }

    if(editSweetnessLevel != null) {
      _sweetness = editSweetnessLevel;
    }

    if(editIceLevel != null) {
      _iceLevel = editIceLevel;
    }
  }

  @override
  Widget build(BuildContext context) {
    var bobaCart = Provider.of<BobaCartModel>(context);

    print("editOrderKey = $editOrderKey");
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.pinkAccent),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: BobaBannerImage(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "How would you like your ${bobaName.trim()} Boba?",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                ),
              ),

              // Milk type drop-down
              StreamBuilder<QuerySnapshot>(
                  stream: milkTypeDb,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(!snapshot.hasData) return Text("Loading...");
                    return new DropdownButton<String>(
                      iconSize: 40,
                      iconEnabledColor: Colors.pinkAccent,
                      focusColor: Colors.white,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      value: _milkType,
                      items: snapshot.data.documents.map((map) {
                        return DropdownMenuItem<String>(
                          value: map['name'].toString(),
                          child: Text(
                            map['name'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                          ),
                        );
                      }).toList(),
                      hint: Text(
                        "Milk",
                        style: TextStyle(
                          color: Colors.white30,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _milkType = value;
                          if(_iceLevel != null && _sweetness != null) {
                            orderComplete = true;
                          }
                        });
                      },
                    );
                  }
                ),

              // Sweetness drop-down
              StreamBuilder<QuerySnapshot>(
                  stream: sweetnessDb,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(!snapshot.hasData) return Text("Loading...");
                    return new DropdownButton<String>(
                      iconSize: 40,
                      iconEnabledColor: Colors.pinkAccent,
                      focusColor: Colors.white,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      value: _sweetness,
                      items: snapshot.data.documents.map((map) {
                        return DropdownMenuItem<String>(
                          value: map['name'].toString(),
                          child: Text(
                            map['name'].toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                      hint: Text(
                        "Sweetness",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white30,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _sweetness = value;
                          if(_iceLevel != null && _milkType != null) {
                            orderComplete = true;
                          }
                        });
                      },
                    );
                  }
              ),

              // Ice Level drop-down
              StreamBuilder<QuerySnapshot>(
                    stream: iceLevelDb,
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(!snapshot.hasData) return Text("Loading...");
                      return new DropdownButton<String>(
                        iconSize: 40,
                        iconEnabledColor: Colors.pinkAccent,
                        focusColor: Colors.white,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        value: _iceLevel,
                        items: snapshot.data.documents.map((map) {
                          return DropdownMenuItem<String>(
                            value: map['name'].toString(),
                            child: Text(
                              map['name'].toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                            ),
                          );
                        }).toList(),
                        hint: Text(
                            "Ice",
                              style: TextStyle(
                                color: Colors.white30,
                              ),
                          ),
                        onChanged: (value) {
                          setState(() {
                            _iceLevel = value;
                            if(_sweetness != null && _milkType != null) {
                              orderComplete = true;
                            }
                          });
                        },
                      );
                    }
                ),

              Padding(
                padding: const EdgeInsets.only(top: 38.0),
                child: Text(
                  "Tap to select toppings. Php10 per topping",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            // Toppings radio buttons here
              Padding(
                padding: const EdgeInsets.only(right: 50.0, left: 50.0, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      child: CustomRadioItem(toppingsRadioList[0]),
                      borderRadius: BorderRadius.circular(100),
                      highlightColor: Colors.pinkAccent,
                      onTap: () {
                          setState(() {
                            if(toppingsRadioList[0].isSelected) {
                              toppingsRadioList[0].isSelected = false;
                              toppingsPrice -= 10;
                            }else {
                              toppingsPrice = 0;
                              toppingsRadioList.forEach((element) =>
                              element.isSelected = false);
                              toppingsRadioList[0].isSelected = true;
                              toppingsPrice += 10;
                            }
                            _topping = toppingsRadioList[0].value;
                          });
                        },
                    ),
                    InkWell(
                      child: CustomRadioItem(toppingsRadioList[1]),
                      borderRadius: BorderRadius.circular(100),
                      highlightColor: Colors.pinkAccent,
                      onTap: () {
                        setState(() {
                          if(toppingsRadioList[1].isSelected) {
                            toppingsRadioList[1].isSelected = false;
                            toppingsPrice -= 10;
                          }else {
                            toppingsPrice = 0;
                            toppingsRadioList.forEach((element) =>
                            element.isSelected = false);
                            toppingsRadioList[1].isSelected = true;
                            toppingsPrice += 10;
                          }
                          _topping = toppingsRadioList[1].value;
                        });
                      },
                    ),
                    InkWell(
                      child: CustomRadioItem(toppingsRadioList[2]),
                      borderRadius: BorderRadius.circular(100),
                      highlightColor: Colors.pinkAccent,
                      onTap: () {
                        setState(() {
                          if(toppingsRadioList[2].isSelected) {
                            toppingsRadioList[2].isSelected = false;
                            toppingsPrice -= 10;
                          }else {
                            toppingsPrice = 0;
                            toppingsRadioList.forEach((element) =>
                            element.isSelected = false);
                            toppingsRadioList[2].isSelected = true;
                            toppingsPrice += 10;
                          }
                          _topping = toppingsRadioList[2].value;
                        });
                      },
                    )
                  ],
                ),
              ),

              // Total Price
              Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "TOTAL:",
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.white30,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "Php ${(toppingsPrice + bobaPrice).toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: editOrder ?  (
                  RaisedButton(
                    child: Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19
                      ),
                    ),
                    onPressed: (){
                      BobaOrderModel editOrder = BobaOrderModel();
                      editOrder.bobaProductName = bobaName;
                      editOrder.milkTypeName = _milkType;
                      editOrder.sweetnessLevelName = _sweetness;
                      editOrder.iceLevelName = _iceLevel;
                      editOrder.toppingsName = _topping == null ? "" : _topping;
                      editOrder.orderCount = 1;
                      editOrder.price = bobaPrice + toppingsPrice;

                      bobaCart.updateOrder(editOrder, editOrderKey);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => CheckoutScreen(),
                      ));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  )
                ):
                  (orderComplete ? RaisedButton(
                  onPressed: () {
                    var bobaOrder = BobaOrderModel();
                    bobaOrder.bobaProductName = bobaName;
                    bobaOrder.milkTypeName = _milkType;
                    bobaOrder.sweetnessLevelName = _sweetness;
                    bobaOrder.iceLevelName = _iceLevel;
                    bobaOrder.toppingsName = _topping == null ? "" : _topping;
                    bobaOrder.orderCount = 1;
                    bobaOrder.price = bobaPrice + toppingsPrice;

                    bobaCart.addOrderToMap(bobaOrder);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "     ADD     ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19
                    ),
                  ),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ) : RaisedButton(
                  child: Text(
                    "     ADD     ",
                    style: TextStyle(
                        color: Colors.white30,
                        fontSize: 19
                    ),
                  ),
                  textColor: Colors.white30,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Future<Widget> getRadioButtonToppingWidget(context, radioModelList, index) async {
    return InkWell(
      child: CustomRadioItem(radioModelList[index]),
      borderRadius: BorderRadius.circular(100),
      highlightColor: Colors.pinkAccent,
      onTap: () {
        setState(() {
          print(index);
          if(radioModelList[index].isSelected) {
            radioModelList[index].isSelected = false;
          }

          radioModelList.forEach((element) => element.isSelected = false);
          radioModelList[index].isSelected = true;

        });
      },
    );
  }

}



class CustomRadioItem extends StatelessWidget {
  final RadioModel _radioModel;

  const CustomRadioItem(this._radioModel);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Stack(
          alignment: AlignmentDirectional.center,
//          fit: StackFit.expand,  // this will cause an error during run
          children: <Widget>[
            Container(
              height: 70,
              width: 70,
              child: Center(
                child: Text(
                  "${_radioModel.buttonLabel.split(" ").elementAt(0)}\n${_radioModel.buttonLabel.split(" ").elementAt(1)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: _radioModel.isSelected ? Colors.pinkAccent : Colors.black,
                  border: Border.all(
                    color: Colors.pinkAccent,
                    width: 2,
                    style: BorderStyle.solid,
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonLabel;
  final String value;

  RadioModel(this.isSelected, this.buttonLabel, this. value);
}