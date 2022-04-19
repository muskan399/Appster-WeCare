import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'landing_screen.dart';
import '../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String errorMessage="";

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late String email;
  late String password;
  late String emergencyContactNumber;
  bool showSpinner = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'REGISTER',
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Register',
                style: TextStyle(fontSize: 30.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your e-mail'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  emergencyContactNumber = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter emergency contact number'),
              ),
              SizedBox(
                height: 24.0,
              ),
              FlatButton(
                child: Text('Register'),
                color: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue)),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    User? signedInUser = newUser.user;
                    if (newUser != null) {
                      _firestore
                          .collection('/users')
                          .doc(signedInUser?.uid)
                          .set({
                        'emergencyContactNumber': emergencyContactNumber,
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyStatefulWidget()),
                      );
                    }
                    setState(() {
                      showSpinner = false;
                    
                    });
                  } catch (error) {
                    
                    //print(e);
                    switch (error) {
                      case "ERROR_OPERATION_NOT_ALLOWED":
                        errorMessage = "Anonymous accounts are not enabled";
                        break;
                      case "ERROR_WEAK_PASSWORD":
                        errorMessage = "Your password is too weak";
                        break;
                      case "ERROR_INVALID_EMAIL":
                        errorMessage = "Your email is invalid";
                        break;
                      case "ERROR_EMAIL_ALREADY_IN_USE":
                        errorMessage =
                            "Email is already in use on different account";
                        break;
                      case "ERROR_INVALID_CREDENTIAL":
                        errorMessage = "Your email is invalid";
                        break;
                      default:
                        errorMessage = "An undefined Error happened.";
                    }
                    setState(() {
                      showSpinner = false;
                      FocusScope.of(context).unfocus();
                      _displaySnackBar(context);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('$errorMessage'));
    // _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
