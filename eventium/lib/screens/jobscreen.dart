import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'detailpage.dart';

class JobScreen extends StatefulWidget {
  @override
  _JobScreenState createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  final controller = PageController();
  TabController _controller;
  static List<Widget> _widgetOptions = <Widget>[
    buildBody(),
    buildJobs(false),
    buildJobs(true),
    buildBody(),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Работа",
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            bottom: TabBar(
              labelStyle: TextStyle(fontWeight: FontWeight.w700),
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Theme.of(context).buttonColor,
              unselectedLabelColor: Theme.of(context).hintColor,
              isScrollable: true,
              controller: _controller,
              indicator: MD2Indicator(
                indicatorSize: MD2IndicatorSize.normal,
                indicatorHeight: 3,
                indicatorColor: Theme.of(context).buttonColor,
              ),
              tabs: <Widget>[
                Tab(
                  text: "Избранное",
                ),
                Tab(
                  text: "Отклики",
                ),
                Tab(
                  text: "В исполнении",
                ),
                Tab(
                  text: "Ваши заказы",
                )
              ],
            ),
          ),
          body: TabBarView(
            children: _widgetOptions,
            controller: _controller,
          )),
    );
  }
}

Future<DocumentSnapshot> getJobs(jobid) async {
  return await FirebaseFirestore.instance.collection("jobs").doc(jobid).get();
}

buildJobs(status) {
  String uid = FirebaseAuth.instance.currentUser.uid;
  final ref = FirebaseFirestore.instance
      .collection('users-jobs')
      .where('userid', isEqualTo: uid)
      .where('status', isEqualTo: status);
  return Flexible(
    child: StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView.builder(
              itemCount: snapshot.hasData ? snapshot.data.docs.length : 0,
              itemBuilder: (context, index) {
                String idjobs = snapshot.data.docs[index].get('jobid');
                return FutureBuilder(
                    future: getJobs(idjobs),
                    builder: (context, query) {
                      if (query.connectionState == ConnectionState.done) {
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPage(docView: query.data)),
                                  );
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        border: Border.all(
                                            width: 0,
                                            color: Theme.of(context)
                                                .highlightColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13))),
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
                                                              top: 20,
                                                              left: 20),
                                                      child: Text(
                                                          query.data['title']
                                                              .toString()
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                                  color: Colors
                                                                      .grey)),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text('Время:',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .grey)),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text('Метро:',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .grey)),
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
                                                            query.data['date'],
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
                                                              query
                                                                  .data['time'],
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Text(
                                                              query.data['geo'],
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                              color:
                                                  Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(13),
                                                  topRight:
                                                      Radius.circular(13))),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(13),
                                                            topRight:
                                                                Radius.circular(
                                                                    13))),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 60,
                                                child: Center(
                                                    child: Text(
                                                  '${query.data['price']} руб/час',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .backgroundColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                              ),
                                              Container(
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 50, top: 20),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            size: 40,
                                                            color: Color(
                                                                0xFFe1e3e6)),
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
                      } else if (query.connectionState ==
                          ConnectionState.none) {
                        return Container();
                      }
                      return (Container());
                    });
              });
        }),
  );
}

Widget buildBody() {
  String uid = FirebaseAuth.instance.currentUser.uid;
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
