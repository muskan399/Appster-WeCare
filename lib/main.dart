import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wecare_major/screens/landing_screen.dart';
import 'package:wecare_major/screens/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
FirebaseAuth? _auth = FirebaseAuth.instance;
String uid="";

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  bool _loggedIn = false;
  @override
  void initState() {
    super.initState();
    isLoggedIn().then((isLoggedIn) {
      if (isLoggedIn) {
        setLoggedIn();
      }
    });
  }

  void setLoggedIn() {
    setState(() {
      _loggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loggedIn ? MyStatefulWidget() : WelcomeScreen();
  }
}
// getUser() async {
  
//   return await _auth?.currentUser!().then((user) {
//     uid = user.uid;
//     return user;
//   });
// }


Future<bool> isLoggedIn() async {
  var _user =_auth!.currentUser;
  return _user != null;
}
