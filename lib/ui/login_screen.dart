import 'package:boba_me/ui/product_screen.dart';
import 'package:boba_me/ui/progress_screen.dart';
import 'package:boba_me/ui/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'custom_widgets/custom_widgets.dart';


class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  TextEditingController emailInputController;
  TextEditingController passwordInputController;
  var obscurePassword = true;
  var eyeIcon = FontAwesomeIcons.eye;
  @override
  void initState() {
    super.initState();
    emailInputController = TextEditingController();
    passwordInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            BobaBannerImage(),
            ButtonSwitchBanner(
              button1Text: "LOGIN",
              button2Text: "SIGNUP",
              button1Highlighted: true,
              button2Highlighted: false,
              button1DestScreenWidget: null,
              button2DestScreenWidget: SignupScreen(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 44),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  BobaTextfield(inputController: emailInputController, textFieldLabel: "EMAIL", enabled: true,),
                  TextField(
                    controller: passwordInputController,
                    decoration: InputDecoration(
                      labelText: "PASSWORD",
                      labelStyle: TextStyle(
                          color: Colors.white30
                      ),
                      suffixIcon: FlatButton(
                        child: Icon(
                          eyeIcon,
                          color: Colors.pinkAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                            if(obscurePassword){
                              eyeIcon = FontAwesomeIcons.eye;
                            }else{
                              eyeIcon = FontAwesomeIcons.eyeSlash;
                            }
                          });

                        },
                      ),
                    ),
                    obscureText: obscurePassword,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // TODO: Enable this SUBMIT button only when the fields have been supplied with values
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  onPressed: () async{
                    try {
                      final loginUser = await _auth.signInWithEmailAndPassword(email: emailInputController.text, password: passwordInputController.text);
                      if(loginUser != null) {
//                        print("${loginUser.user.uid} is logged-in");
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => ProductScreen(),
                        ));
                      }else{
                        print("unable to login");

                      }
                    }catch(e) {
                      showDialog(
                         context: context,
                        barrierDismissible: false,
                        builder: (context) => ErrorAlertDialog(contentText: "Uh-oh! Login error. Are you a BobaMe user already?",),
                      );
                    }
                  },
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19
                    ),
                  ),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}