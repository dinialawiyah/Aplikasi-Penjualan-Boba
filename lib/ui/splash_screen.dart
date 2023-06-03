import 'package:flutter/material.dart';

class Splash extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image(
          image: AssetImage(
              "images/drink.png"
          ),
        ),
        SizedBox(height: 20,),
        Image(
          image: AssetImage(
              "images/bobame_black_white_on_bbg.png"
          ),
        )
      ],
    );
  }
}
