import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventium/screens/detailpage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ref = FirebaseFirestore.instance.collection('jobs');
  String idjob;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            buildSearchBar(),
            buildBody(),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.filter,
                  color: Color(0xFFe1e3e6),
                ),
                onPressed: () {}),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 1.7,
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'Поиск по заданиям...',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Theme.of(context).buttonColor),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(7),
                    )),
              ),
            ),
            IconButton(
                icon: FaIcon(FontAwesomeIcons.map, color: Color(0xFFe1e3e6)),
                onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Future<DocumentSnapshot> getUserData(userid) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(userid)
        .get();
  }

  Widget buildBody() {
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
                setState(() {});
              },
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  reverse: false,
                  itemCount: snapshot.hasData ? snapshot.data.docs.length : 0,
                  itemBuilder: (context, index) {
                    String userid = snapshot.data.docs[index].get('userid');
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 220.0,
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
                                                snapshot.data.docs[index]
                                                        .get('newstatus')
                                                    ? newStatus(context)
                                                    : oldStatus(context),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0, left: 20),
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
                                                      SizedBox(
                                                        height: 5,
                                                      ),
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
                                                      SizedBox(
                                                        height: 5,
                                                      ),
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
                                                  child: buildUser(userid)),
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
                                          Expanded(
                                            child: Container(
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5, top: 30),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 20,
                                                                bottom: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              snapshot.data
                                                                  .docs[index]
                                                                  .get(
                                                                      'persons')
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Icon(
                                                              Icons.person,
                                                              size: 30,
                                                              color: Color(
                                                                  0xffe1e3e6),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons
                                                                  .favorite_outline,
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor,
                                                            ),
                                                            onPressed: () {},
                                                            iconSize: 40,
                                                          ),
                                                          Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              size: 40,
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
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
            );
          }),
    );
  }

  buildUser(String userid) {
    return FutureBuilder(
        future: getUserData(userid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: () {
                showMaterialModalBottomSheet(
                  backgroundColor: Color(0xFF262626),
                  duration: Duration(milliseconds: 200),
                  elevation: 4,
                  expand: false,
                  context: context,
                  builder: (context) => Container(
                      height: 250,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Column(
                          children: [
                            IconButton(
                                icon: Icon(Icons.arrow_downward_outlined,
                                    size: 30,
                                    color: Theme.of(context).buttonColor),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                            //Icon(Icons.arrow_downward_outlined, size: 30),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                              snapshot.data['avatar']),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                            snapshot.data["nickname"]
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16))
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          'Заказов:',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Container(
                                          height: 20,
                                          child: VerticalDivider(
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text('Рейтинг:',
                                            style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(snapshot.data["orders"].toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Container(
                                          height: 20,
                                        ),
                                        Text(snapshot.data["rating"].toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                  snapshot.data["verifstatus"]
                                      ? Text('Проверенный заказчик',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold))
                                      : Text('Непроверенный заказчик',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                );
              },
              child: Container(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(snapshot.data['avatar']),
                    ),
                    SizedBox(width: 10),
                    Text(snapshot.data["nickname"].toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ],
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                      'https://trust-import.com/perchatki-medicinskie/img/reviews-user-photo.jpg'),
                ),
                Text('Ошибка', style: TextStyle(fontWeight: FontWeight.bold))
              ],
            );
          }
          return CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).buttonColor),
            backgroundColor: Theme.of(context).backgroundColor,
            strokeWidth: 1,
          );
        });
  }
}

Widget newStatus(context) {
  return Container(
    width: 70,
    height: 60,
    child: Center(
        child: Text(
      'NEW',
      style: TextStyle(
          color: Theme.of(context).backgroundColor,
          fontWeight: FontWeight.bold),
    )),
    decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(13), bottomRight: Radius.circular(13))),
  );
}

Widget oldStatus(context) {
  return Container(
    width: 70,
    height: 60,
    child: Center(
        child: Text(
      '',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    )),
    decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(13), bottomRight: Radius.circular(13))),
  );
}
