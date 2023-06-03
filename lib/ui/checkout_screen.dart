import 'package:boba_me/model/boba_cart_model.dart';
import 'package:boba_me/ui/product_add_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'address_screen.dart';

var _bobaCart = BobaCartModel();
Map _bobaOrdersMap;

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  ScrollController _scrollController;
  bool _nextButtonEnabled = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if(_scrollController.offset >= _scrollController.position.maxScrollExtent &&
      !_scrollController.position.outOfRange) {
        setState(() {
          _nextButtonEnabled = true;
        });
      }

      if(!_scrollController.position.haveDimensions){
        setState(() {
          _nextButtonEnabled = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _bobaCart = Provider.of<BobaCartModel>(context);
    _bobaOrdersMap = _bobaCart.bobaOrdersMap;


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.pinkAccent),
        title: Text(
          "CHECKOUT",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 3
          ),
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _bobaOrdersMap.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Column(
              children: <Widget>[
                BobaOrder(
                  bobaCart: _bobaCart,
                  index: index,
                  removeOrder: () => removeOrder(
                      _bobaOrdersMap.keys.elementAt(index)
                  ),
                ),
              ],
            ),
          );
        },
        physics: BouncingScrollPhysics(),
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
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: 40,
              ),
              RaisedButton(
                child: Text(
                  "   NEXT  ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19
                  ),
                ),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: _nextButtonEnabled || (_bobaOrdersMap.length < 3)? () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => AddressScreen(),
                  ));
                } : null,
              )
            ],
          ),
        ),
      ),
    );
  }

  removeOrder(String key) {
    setState(() {
      Map<String, dynamic> removedOrder = Map.from(_bobaOrdersMap)..remove(key);
      _bobaCart.setBobaOrderMap(removedOrder);
    });
  }
}

class BobaOrder extends StatelessWidget {
  const BobaOrder({
    Key key,
    @required this.bobaCart,
    @required this.index, this.removeOrder
  }) : super(key: key);

  final BobaCartModel bobaCart;
  final int index;
  final VoidCallback removeOrder;

  @override
  Widget build(BuildContext context) {
    Map bobaOrdersMap = bobaCart.bobaOrderMap;
    String key = bobaOrdersMap.keys.elementAt(index);
    int totalOrderSize = bobaOrdersMap.keys.length;
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${bobaOrdersMap[key].bobaProductName.toString().trim().toUpperCase()} MILK TEA",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                      wordSpacing: 3,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              "${bobaOrdersMap[key].milkTypeName}",
                              style: TextStyle(
                                  color: Colors.white30,
                                  fontSize: 15
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:4.0),
                            child: Text(
                              "${bobaOrdersMap[key].sweetnessLevelName}",
                              style: TextStyle(
                                  color: Colors.white30,
                                  fontSize: 15
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              "${bobaOrdersMap[key].iceLevelName}",
                              style: TextStyle(
                                  color: Colors.white30,
                                  fontSize: 15
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              bobaOrdersMap[key].toppingsName.toString().isEmpty ? "No Toppings"
                                  : "${bobaOrdersMap[key].toppingsName} -- Add'l. Php 10",
                              style: TextStyle(
                                color: Colors.white30,
                                fontSize: 15
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0, left: 12),
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  child: Text(
                                    "EDIT",
                                    style: TextStyle(
                                      color: Colors.pinkAccent,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => ProductAddScreen(
                                        // TODO: Probably use index and/or keys, passed as parameters to ProductAddScreen, to identify the order to be edited.
                                        bobaProductName: bobaOrdersMap[key].bobaProductName,
                                        bobaProductPrice: bobaOrdersMap[key].price,
                                        editOrder: true,
                                        editMilkType: bobaOrdersMap[key].milkTypeName,
                                        editSweetnessLevel: bobaOrdersMap[key].sweetnessLevelName,
                                        editIceLevel: bobaOrdersMap[key].iceLevelName,
                                        editToppings: bobaOrdersMap[key].toppingsName,
                                        editOrderKey: key,
                                      ),
                                    ));
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  child: Text(
                                      "REMOVE",
                                    style: TextStyle(
                                        color: Colors.pinkAccent,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  onTap: removeOrder,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "QTY",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "-",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pinkAccent,
                                      fontSize: 37
                                  ),
                                ),
                                Container(
                                  width: 60,
                                  height: 60,
                                  alignment: Alignment.center,
                                  child: Text(
                                    bobaOrdersMap[key].orderCount.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 37
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white30
                                  ),
                                ),
                                Text(
                                  "+",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pinkAccent,
                                      fontSize: 37
                                  ),
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            )
                          ],
                        ),
                    )
                  ],
                )
              ],
            ),
            // price details here
            Container(
              child: totalOrderSize-1 == index ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Container(
                      color: Colors.white12,
                      child: SizedBox(
                        height: 2,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "Subtotal ..............................${bobaCart.subTotal.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white30,
                        letterSpacing: 2
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "Taxes ..................................${bobaCart.taxes.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white30,
                          letterSpacing: 2
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "Delivery Fee .........................${bobaCart.deliveryFee.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white30,
                          letterSpacing: 2
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "Order Total ........................... ${bobaCart.orderTotal.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 2
                      ),
                    ),
                  ),
                ],
              ) : Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Container(
                  color: Colors.white12,
                  child: SizedBox(
                    height: 2,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
