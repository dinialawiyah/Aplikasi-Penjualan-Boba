import 'package:boba_me/model/boba_cart_model.dart';
import 'package:boba_me/ui/login_screen.dart';
import 'package:boba_me/ui/product_add_screen.dart';
import 'package:boba_me/ui/product_screen.dart';
import 'package:boba_me/ui/progress_screen.dart';
import 'package:boba_me/ui/sign_up_screen.dart';
import 'package:boba_me/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      ChangeNotifierProvider(
          create: (context) => BobaCartModel(),
          child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        buttonColor: Colors.pinkAccent,
        canvasColor: Colors.black,
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.yellow,
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: Colors.yellow,
          ),
          bodyText2: TextStyle(
            color: Colors.yellow,
          ),
        )
      ),
      initialRoute: LoginScreen.id,
//      initial Route: BobaProgressIndicator.id,
      routes: {
        SignupScreen.id : (context) => SignupScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        ProductScreen.id : (context) => ProductScreen(),
        BobaProgressIndicator.id : (context) => BobaProgressIndicator(),
        ProductAddScreen.id : (context) => ProductAddScreen(),
      },
    );
  }
}

