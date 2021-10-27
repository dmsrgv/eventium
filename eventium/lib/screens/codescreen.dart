import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventium/net/firebase.dart';
import 'package:eventium/screens/registrationscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

import 'homescreen.dart';
import 'loadingscreen.dart';

class CodeScreen extends StatefulWidget {
  final String phone;
  CodeScreen(this.phone);
  @override
  _CodeScreenState createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationCode;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingScreen()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Theme.of(context).backgroundColor,
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
                child: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 10),
                    Text(
                      'ВВЕДИТЕ КОД ПОДТВЕРЖДЕНИЯ',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Мы отправили код на номер +7${widget.phone}',
                        style: TextStyle(fontSize: 16)),
                    Text('Вы можете запросить код повторно через'),
                    TweenAnimationBuilder(
                        tween: Tween(begin: 60.0, end: 0),
                        duration: Duration(seconds: 60),
                        builder: (context, value, child) => Text(
                            "00:${value.toInt()}",
                            style: TextStyle(
                                color: Theme.of(context).buttonColor))),
                    SizedBox(height: 20),
                    Container(
                        child: PinEntryTextField(
                            fields: 6,
                            onSubmit: (String returnedPin) async {
                              try {
                                setState(() {
                                  loading = true;
                                });
                                await _auth
                                    .signInWithCredential(
                                        PhoneAuthProvider.credential(
                                            verificationId: verificationCode,
                                            smsCode: returnedPin))
                                    .then((value) async {
                                  if (value.user != null) {
                                    FirebaseAuth auth = FirebaseAuth.instance;
                                    String uid = auth.currentUser.uid;
                                    QuerySnapshot result = await Future.value(
                                        FirebaseFirestore.instance
                                            .collection('Users')
                                            .where('UID', isEqualTo: uid)
                                            .limit(1)
                                            .get());
                                    final List<DocumentSnapshot> documents =
                                        result.docs;
                                    if (documents.length == 1) {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen()),
                                          (route) => false);
                                    } else {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegistrationScreen()),
                                          (route) => false);
                                    }
                                  }
                                });
                              } catch (e) {
                                setState(() {
                                  loading = false;
                                });
                                FocusScope.of(context).unfocus();
                                Fluttertoast.showToast(
                                    msg: "Неправильный код. Попробуйте ещё раз",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black45,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            })),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            )),
          );
  }

  @override
  void initState() {
    _verifyPhone();
    super.initState();
  }

  _verifyPhone() async {
    dynamic phonedob;
    phonedob = '+7${widget.phone}';
    _auth.verifyPhoneNumber(
        phoneNumber: '+7${widget.phone}',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential).then((value) async {
            if (value.user != null) {
              FirebaseAuth auth = FirebaseAuth.instance;
              String uid = auth.currentUser.uid;
              QuerySnapshot result = await Future.value(FirebaseFirestore
                  .instance
                  .collection('Users')
                  .where('uid', isEqualTo: uid)
                  .limit(1)
                  .get());
              final List<DocumentSnapshot> documents = result.docs;
              if (documents.length == 1) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false);
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationScreen()),
                    (route) => false);
              }
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int resendToken) async {
          setState(() {
            verificationCode = verificationId;
          });
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: verificationCode);
          await _auth.signInWithCredential(phoneAuthCredential);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            verificationCode = verificationId;
          });
        });
  }
}
