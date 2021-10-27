import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventium/screens/loadingscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'authscreen.dart';
import 'homescreen.dart';
import 'registrationscreen.dart';

class LandingScreen extends StatefulWidget {
  LandingScreen({Key key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User user) async {
      if (user != null) {
        FirebaseAuth auth = FirebaseAuth.instance;
        String uid = auth.currentUser.uid;
        QuerySnapshot result = await Future.value(FirebaseFirestore.instance
            .collection('Users')
            .where('UID', isEqualTo: uid)
            .limit(1)
            .get());
        final List<DocumentSnapshot> documents = result.docs;
        if (documents.length == 1) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false);
          });
        } else {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => RegistrationScreen()),
                (route) => false);
          });
        }
      } else {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => AuthScreen()),
              (route) => false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen();
  }
}
