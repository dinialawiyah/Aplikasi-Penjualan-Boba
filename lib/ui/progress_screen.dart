import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BobaProgressIndicator extends StatelessWidget {
  static const id = "ProgressIndicator";
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Image.asset(
              "images/drink.png",
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          child: Image.asset(
            "images/bobame_black_white_on_bbg.png",
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
          ),
        )
      ],
    );
  }
}
