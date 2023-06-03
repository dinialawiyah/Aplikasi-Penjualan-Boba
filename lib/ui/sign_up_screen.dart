import 'package:boba_me/ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'custom_widgets/custom_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  static const String id = "Signup_screen";
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController passwordInputController;
  var obscurePassword = true;
  var eyeIcon = FontAwesomeIcons.eye;

  @override
  void initState() {
    super.initState();
    firstNameInputController = TextEditingController();
    lastNameInputController = TextEditingController();
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
          scrollDirection: Axis.vertical,
          children: <Widget>[
            BobaBannerImage(),
            ButtonSwitchBanner(
              button1Text: "LOGIN",
              button2Text: "SIGNUP",
              button1Highlighted: false,
              button2Highlighted: true,
              button1DestScreenWidget: LoginScreen(),
              button2DestScreenWidget: null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 44),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  BobaTextfield(inputController: firstNameInputController, textFieldLabel: "FIRST NAME",enabled: true,),
                  BobaTextfield(inputController: lastNameInputController, textFieldLabel: "LAST NAME",enabled: true,),
                  BobaTextfield(inputController: emailInputController, textFieldLabel: "EMAIL",enabled: true,),
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
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  onPressed: () async {
                    try {
                      final newUser = await _auth
                          .createUserWithEmailAndPassword(
                          email: emailInputController.text,
                          password: passwordInputController.text);
                      if(newUser != null) {
                        print("${newUser.user.email} is now registered to BobaMe");
                        final newCustomerInfo = await Firestore.instance.collection('CustomerInfo').add({
                          'uid': newUser.user.uid,
                          'email' : newUser.user.email,
                          'first_name' : firstNameInputController.text,
                          'last_name' : lastNameInputController.text,
                          'sign_up_date': DateTime.now().toUtc().toString(),
                        });

                        if(newCustomerInfo != null) {
                          print("new customerinfo saved with docid = ${newCustomerInfo.documentID}");
                          setState(() {
                            firstNameInputController.clear();
                            lastNameInputController.clear();
                            emailInputController.clear();
                            passwordInputController.clear();
                          });
                        }
                      }
                    }catch(e) {
                      print(e);
                      // TODO: show this error in Login Screen or Alert Dialog
                    }
                  },

                  // TODO: Enable SUBMIT button only when mandatory fields are provided by user
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19
                    ),
                  ),
                  color: Colors.pinkAccent,
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