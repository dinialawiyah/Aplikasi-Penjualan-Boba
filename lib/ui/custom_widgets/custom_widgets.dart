import 'package:boba_me/model/boba_cart_model.dart';
import 'package:boba_me/ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../checkout_screen.dart';
import '../product_screen.dart';
import '../profile_screen.dart';
import '../sign_up_screen.dart';


class BobaBannerImage extends StatelessWidget {
  const BobaBannerImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(
          "images/bobame_black_white_on_bbg.png"
      ),
    );
  }
}


class ButtonSwitchBanner extends StatelessWidget {
  final String button1Text;
  final String button2Text;
  final bool button1Highlighted;
  final bool button2Highlighted;
  final Widget button1DestScreenWidget;
  final Widget button2DestScreenWidget;


  const ButtonSwitchBanner({
    Key key,
    @required this.button1Text, @required this.button2Text,
    this.button1Highlighted, this.button2Highlighted,
    this.button1DestScreenWidget, this.button2DestScreenWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              InkWell(
                child: Text(
                  button1Text,
                  style: TextStyle(
                    fontSize: 21,
                    color: button1Highlighted ? Colors.white : Colors.white30,
                  ),
                ),
                onTap: () {
                  if(button1DestScreenWidget != null) {
                    Navigator.push(context, PageTransition(
                      type: PageTransitionType.leftToRight,
                      duration: Duration(microseconds: 100),
                      child: button1DestScreenWidget,
                    ));
                  }
                },
              ),
              Hero(
                tag: "pinkLine",
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 6),
                  child: Container(
                    height: 10,
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: button1Highlighted ? Colors.pinkAccent : Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              InkWell(
                child: Text(
                  button2Text,
                  style: TextStyle(
                    fontSize: 21,
                    color: button2Highlighted ? Colors.white : Colors.white30,
                  ),
                ),
                onTap: () {
                  if(button2DestScreenWidget != null) {
                    Navigator.push(context, PageTransition(
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(microseconds: 100),
                      child: button2DestScreenWidget,
                    ));
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 6),
                child: Container(
                  height: 10,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: button2Highlighted ? Colors.pinkAccent : Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class BobaTextfield extends StatelessWidget {

  final TextEditingController inputController;
  final String textFieldLabel;
  final bool enabled;
  final double fontSize;
  final Function onChanged;

  const BobaTextfield({
    Key key,
    @required this.inputController, @required this.textFieldLabel, this.enabled, this.fontSize, this.onChanged,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: inputController,
      keyboardType: (textFieldLabel=="EMAIL") ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
          labelText: textFieldLabel,
          labelStyle: TextStyle(
            color: Colors.white30,
          ),
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
      ),
      enabled: enabled,
      onChanged: onChanged,
    );
  }
}

class ErrorAlertDialog extends StatelessWidget {
  final String contentText;

  const ErrorAlertDialog({Key key, this.contentText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "BobaMe - Error"
      ),
      content: Text(
        "$contentText"
      ),
      actions: <Widget>[
        RaisedButton(
          child: Text(
            "OK"
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}


// TODO: Tweak the transition between ProfileScreen, ProductScreen and CheckoutScreen.
class BobaNavigationBar extends StatelessWidget {
  const BobaNavigationBar({
    Key key,
    @required this.bobaCartModel, this.activeScreen,
  }) : super(key: key);

  final BobaCartModel bobaCartModel;
  final String activeScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              child: Image.asset("images/boba_profile_icon.png"),
              onTap: () {
                if(activeScreen != "PROFILE_SCREEN") {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ));
                }
              },
            ),
            InkWell(
              child: Image.asset("images/boba_drink_icon.png"),
              onTap: () {
                if(activeScreen != "PRODUCT_SCREEN") {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ProductScreen(),
                  ));
                }
              },
            ),
            InkWell(
              child: bobaCartModel.orderCount > 0
                  ? ShoppingCartWithCount(count: bobaCartModel.orderCount)
                  : Image.asset("images/shopping_cart_icon.png"),
              onTap: () {
                if (bobaCartModel.orderCount > 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(),
                      ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ShoppingCartWithCount extends StatelessWidget {
  final int count;

  const ShoppingCartWithCount({
    Key key,
    this.count,
  }) : super(key: key);

  refresh() {
    setState() {}
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        Image.asset("images/shopping_cart_icon.png"),
        Container(
          height: 21,
          width: 21,
          decoration:
          BoxDecoration(shape: BoxShape.circle, color: Colors.pinkAccent),
          child: Text(
            count.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
