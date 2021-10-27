import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventium/screens/addjob.dart';
import 'package:eventium/screens/detailpage.dart';
import 'package:eventium/screens/landingscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  String uid = FirebaseAuth.instance.currentUser.uid;
  String number = FirebaseAuth.instance.currentUser.phoneNumber;
  final ref = FirebaseFirestore.instance.collection('reviews');
  String nickname;
  double ratUs;
  int allrating = 0;
  @override
  void initState() {
    super.initState();
  }

  Future<DocumentSnapshot> getUserData() async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    return await FirebaseFirestore.instance.collection("Users").doc(uid).get();
  }

  updateUserData() {
    String uid = FirebaseAuth.instance.currentUser.uid;
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .update({'rating': ratUs});
  }

  Future<DocumentSnapshot> getUserReview(senderid) async {
    String senderID = senderid;
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(senderID)
        .get();
  }

  Widget build(BuildContext context) {
    GlobalKey<SliderMenuContainerState> _key =
        new GlobalKey<SliderMenuContainerState>();

    return Material(
      child: FutureBuilder(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                  endDrawer: Drawer(
                    child: Container(
                      color: Color(0xFF121212),
                      child: ListView(children: [
                        SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          title: Text('Добавить задание',
                              style: TextStyle(fontSize: 16)),
                          leading: IconButton(
                            icon: Icon(Icons.add,
                                color: Theme.of(context).hintColor),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddJobScreen()));
                            },
                          ),
                        ),
                        ListTile(
                          title:
                              Text('Настройки', style: TextStyle(fontSize: 16)),
                          leading: IconButton(
                            icon: Icon(Icons.settings,
                                color: Theme.of(context).hintColor),
                            onPressed: () {},
                          ),
                        ),
                        ListTile(
                          title: Text('Выйти', style: TextStyle(fontSize: 16)),
                          leading: IconButton(
                            icon: Icon(Icons.logout,
                                color: Theme.of(context).hintColor),
                            onPressed: () {
                              logout();
                            },
                          ),
                        )
                      ]),
                    ),
                  ),
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Color(0xFF121212),
                  body: SafeArea(
                      child: SliderMenuContainer(
                    drawerIconColor: Theme.of(context).hintColor,
                    appBarColor: Theme.of(context).backgroundColor,
                    key: _key,
                    slideDirection: SlideDirection.RIGHT_TO_LEFT,
                    sliderMenuOpenSize: 250,
                    isTitleCenter: false,
                    title: Text(
                      snapshot.data["nickname"].toString(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    sliderMenu: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF121212),
                          border: Border(
                              left: BorderSide(
                                  color: Colors.grey[850], width: 0.5))),
                      child: ListView(children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey[850], width: 0.5))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Text(snapshot.data["nickname"].toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Добавить задание',
                              style: TextStyle(fontSize: 16)),
                          leading: IconButton(
                            icon: Icon(Icons.add,
                                color: Theme.of(context).hintColor),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddJobScreen()));
                            },
                          ),
                        ),
                        ListTile(
                          title:
                              Text('Настройки', style: TextStyle(fontSize: 16)),
                          leading: IconButton(
                            icon: Icon(Icons.settings,
                                color: Theme.of(context).hintColor),
                            onPressed: () {},
                          ),
                        ),
                        ListTile(
                          title: Text('Выйти', style: TextStyle(fontSize: 16)),
                          leading: IconButton(
                            icon: Icon(Icons.logout,
                                color: Theme.of(context).hintColor),
                            onPressed: () {
                              logout();
                            },
                          ),
                        )
                      ]),
                    ),
                    sliderMain: mainWidget(context, snapshot),
                  )));
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  body: Center(child: Text('Ошибка')));
            }
            return Scaffold(
                backgroundColor: Theme.of(context).backgroundColor,
                body: Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).buttonColor),
                  backgroundColor: Theme.of(context).backgroundColor,
                )));
          }),
    );
  }

  mainWidget(BuildContext context, AsyncSnapshot snapshot) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45))),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(45))),
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data["avatar"]),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Заказов:',
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  height: 20,
                  child: VerticalDivider(
                    color: Colors.grey[850],
                  ),
                ),
                Text('Рейтинг:', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(snapshot.data["orders"].toString(),
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Container(
                  height: 20,
                ),
                Text(snapshot.data["rating"].toString(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
              ],
            ),
          ),
          snapshot.data["verifstatus"]
              ? Text('Проверенный пользователь',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold))
              : Text('Непроверенный пользователь',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Divider(
            height: 10,
            thickness: 0.5,
            color: Colors.grey[850],
          ),
          SizedBox(height: 10),
          Text('Ваши заказы:', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          buildBody(uid)
        ],
      ),
    );
  }

  logout() {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LandingScreen()),
        (route) => false);
  }
}

Future<void> updateCountOrders(size) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid;
  FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .update({'orders': size});
  return;
}

Widget buildBody(uid) {
  final ref = FirebaseFirestore.instance
      .collection('jobs')
      .where('userid', isEqualTo: uid);
  String idjob;
  return Flexible(
    child: StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return RefreshIndicator(
            backgroundColor: Theme.of(context).backgroundColor,
            color: Theme.of(context).buttonColor,
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 1));
              ref.snapshots();
            },
            child: Expanded(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  reverse: false,
                  itemCount: snapshot.hasData ? snapshot.data.docs.length : 0,
                  itemBuilder: (context, index) {
                    updateCountOrders(snapshot.data.docs.length);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 150.0,
                          width: MediaQuery.of(context).size.width,
                          child: GestureDetector(
                            onTap: () {
                              idjob = snapshot.data.docs[index].id;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                        docView: snapshot.data.docs[index])),
                              );
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    border: Border.all(
                                        width: 0,
                                        color:
                                            Theme.of(context).highlightColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(13))),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20, left: 20),
                                                  child: Text(
                                                      snapshot.data.docs[index]
                                                          .get('title')
                                                          .toString()
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 15),
                                              child: Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('Дата:',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.grey)),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text('Время:',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.grey)),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text('Метро:',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.grey)),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        snapshot
                                                            .data.docs[index]
                                                            .get('date'),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                          snapshot
                                                              .data.docs[index]
                                                              .get('time'),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          snapshot
                                                              .data.docs[index]
                                                              .get('geo'),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15, left: 15),
                                              child: Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Text('')),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                        child: Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(13),
                                              topRight: Radius.circular(13))),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(13),
                                                    topRight:
                                                        Radius.circular(13))),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 60,
                                            child: Center(
                                                child: Text(
                                              '${snapshot.data.docs[index].get('price')} руб/час',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .backgroundColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                          Container(
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 50, top: 20),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 40,
                                                        color:
                                                            Color(0xFFe1e3e6)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                  ],
                                )),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
        }),
  );
}
