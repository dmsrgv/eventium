import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventium/net/firebase.dart';
import 'package:eventium/screens/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController nicknameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 10),
                  Text(
                    'ПРИДУМАЙТЕ НИКНЕЙМ',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).buttonColor),
                    child: Center(
                      child: TextFormField(
                        cursorColor: Theme.of(context).backgroundColor,
                        style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                            fontSize: 18),
                        maxLength: 10,
                        autofocus: false,
                        autocorrect: false,
                        controller: nicknameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: 'ivanov98',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelStyle: TextStyle(
                                color: Theme.of(context).backgroundColor,
                                fontSize: 18),
                            counterText: '',
                            prefixStyle: TextStyle(
                                color: Theme.of(context).backgroundColor,
                                fontSize: 18),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey[700], fontSize: 18),
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.all(13),
                            enabledBorder: InputBorder.none),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Center(
                      child: Text(
                        'Никнейм должен содержать только латинские символы и не может начинаться с цифры',
                        style: TextStyle(
                            fontSize: 14, color: Theme.of(context).hintColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 350,
                  ),
                  Container(
                    width: 280,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () async {
                          String nickname = nicknameController.text;
                          QuerySnapshot result = await Future.value(
                              FirebaseFirestore.instance
                                  .collection('Users')
                                  .where('nickname', isEqualTo: nickname)
                                  .limit(1)
                                  .get());
                          final List<DocumentSnapshot> documents = result.docs;

                          if (documents.length == 1) {
                            final snackBar =
                                SnackBar(content: Text('Логин занят'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationTwoScreen(
                                      nickname: nickname)),
                            );
                          }
                        },
                        child: Text('ДАЛЕЕ'),
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).buttonColor,
                          onPrimary: Theme.of(context).backgroundColor,
                          textStyle: TextStyle(fontSize: 18),
                        )),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class RegistrationTwoScreen extends StatefulWidget {
  final nickname;
  RegistrationTwoScreen({this.nickname});
  @override
  _RegistrationTwoScreenState createState() => _RegistrationTwoScreenState();
}

class _RegistrationTwoScreenState extends State<RegistrationTwoScreen> {
  File _image;
  final picker = ImagePicker();
  String url;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  uploadPic(File _image1) async {
    final Reference reference = FirebaseStorage.instance
        .ref()
        .child("image1" + DateTime.now().toString());
    await reference.putFile(_image1);
    var dowurl = await reference.getDownloadURL();
    url = dowurl.toString();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 10),
                    Text(
                      'ЗАГРУЗИТЕ ФОТО ПРОФИЛЯ',
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(height: 70),
                    CircleAvatar(
                      backgroundColor: Colors.grey[400],
                      child: _image == null
                          ? Text('Не выбрано',
                              style: TextStyle(
                                  color: Theme.of(context).backgroundColor))
                          : ClipOval(
                              child: Image.file(
                              _image,
                              fit: BoxFit.cover,
                              width: 200,
                              height: 200,
                            )),
                      radius: 80,
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 280,
                      height: 50,
                      child: OutlinedButton(
                          onPressed: () {
                            getImage();
                            uploadPic(_image);
                          },
                          child: Text('ЗАГРУЗИТЬ ФОТО'),
                          style: OutlinedButton.styleFrom(
                            primary: Theme.of(context).buttonColor,
                            textStyle: TextStyle(fontSize: 18),
                          )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 8,
                    ),
                    Container(
                      width: 280,
                      height: 50,
                      child: url == null
                          ? FutureBuilder(
                              future: uploadPic(_image),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (url != null) {
                                    return ElevatedButton(
                                        onPressed: () {
                                          print('Подождите');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegistrationThirdScreen(
                                                        nickname:
                                                            widget.nickname,
                                                        photourl: url)),
                                          );
                                        },
                                        child: Text('ДАЛЕЕ'),
                                        style: ElevatedButton.styleFrom(
                                          primary:
                                              Theme.of(context).buttonColor,
                                          onPrimary:
                                              Theme.of(context).backgroundColor,
                                          textStyle: TextStyle(fontSize: 18),
                                        ));
                                  }
                                } else if (snapshot.connectionState ==
                                    ConnectionState.none) {
                                  return Text('Ошибка');
                                }
                                return Container();
                              })
                          : ElevatedButton(
                              onPressed: () {
                                print('Подождите');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationThirdScreen(
                                              nickname: widget.nickname,
                                              photourl: url)),
                                );
                              },
                              child: Text('ДАЛЕЕ'),
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).buttonColor,
                                onPrimary: Theme.of(context).backgroundColor,
                                textStyle: TextStyle(fontSize: 18),
                              )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 280,
                      height: 50,
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationThirdScreen(
                                      nickname: widget.nickname,
                                      photourl:
                                          'https://firebasestorage.googleapis.com/v0/b/eventium-d5611.appspot.com/o/avatardefault.jpg?alt=media&token=b4fb2c3d-58e9-4b05-aef7-c2694c7be5f5')),
                            );
                          },
                          child: Text('ПРОПУСТИТЬ'),
                          style: OutlinedButton.styleFrom(
                            primary: Theme.of(context).buttonColor,
                            textStyle: TextStyle(fontSize: 18),
                          )),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class RegistrationThirdScreen extends StatefulWidget {
  final nickname;
  final photourl;
  RegistrationThirdScreen({this.nickname, this.photourl});

  @override
  _RegistrationThirdScreenState createState() =>
      _RegistrationThirdScreenState();
}

class _RegistrationThirdScreenState extends State<RegistrationThirdScreen> {
  bool isCustomer;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 10),
                    Text(
                      'ВЫБЕРИТЕ КЕМ ХОТИТЕ СТАТЬ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: GestureDetector(
                        onTap: () {
                          isCustomer = false;
                          String photourl = widget.photourl;
                          print('ФОТО ВОТ -------------------> $photourl');
                          if (photourl == null) {
                            photourl =
                                'https://firebasestorage.googleapis.com/v0/b/eventium-d5611.appspot.com/o/avatardefault.jpg?alt=media&token=b4fb2c3d-58e9-4b05-aef7-c2694c7be5f5';
                            userSetup(widget.nickname, photourl, isCustomer);
                          } else {
                            userSetup(widget.nickname, photourl, isCustomer);
                          }
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                              (route) => false);
                        },
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(height: 40),
                              Text(
                                'СТАТЬ ИСПОЛНИТЕЛЕМ',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).backgroundColor),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                'НАЙДИТЕ ЗАКАЗЫ',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).backgroundColor),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'И НАЧНИТЕ ЗАРАБАТЫВАТЬ',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).backgroundColor),
                              ),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width / 1,
                          height: MediaQuery.of(context).size.height / 3,
                          decoration: BoxDecoration(
                              color: Theme.of(context).buttonColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: GestureDetector(
                        onTap: () {
                          isCustomer = true;
                          String photourl = widget.photourl;
                          if (photourl == null) {
                            photourl =
                                'https://firebasestorage.googleapis.com/v0/b/eventium-d5611.appspot.com/o/avatardefault.jpg?alt=media&token=b4fb2c3d-58e9-4b05-aef7-c2694c7be5f5';
                            userSetup(widget.nickname, photourl, isCustomer);
                          } else {
                            userSetup(widget.nickname, photourl, isCustomer);
                          }
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                              (route) => false);
                        },
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(height: 40),
                              Text(
                                'СТАТЬ ЗАКАЗЧИКОМ',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                'ЗАКАЖИТЕ УСЛУГУ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'И НАЙДИТЕ СПЕЦИАЛИСТА',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                          width: MediaQuery.of(context).size.width / 1,
                          height: MediaQuery.of(context).size.height / 3,
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
