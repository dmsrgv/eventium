import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventium/net/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DetailPage extends StatefulWidget {
  final DocumentSnapshot docView;
  DetailPage({this.docView});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String titledoc = "";
  String price = "";
  String geo = "";
  String descr = "";
  String date = "";
  String time = "";
  String userid = "";
  String currentid = FirebaseAuth.instance.currentUser.uid;
  String jobid;
  int persons = 0;
  int countActive = 0;
  String chatid;

  @override
  void initState() {
    titledoc = widget.docView.get('title');
    price = widget.docView.get('price');
    geo = widget.docView.get('geo');
    descr = widget.docView.get('descr');
    date = widget.docView.get('date');
    time = widget.docView.get('time');
    userid = widget.docView.get('userid');
    persons = widget.docView.get('persons');
    jobid = widget.docView.id;
    super.initState();
  }

  Future<DocumentSnapshot> getUserData(userid) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(userid)
        .get();
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
                                icon: Icon(
                                  Icons.arrow_downward_outlined,
                                  size: 30,
                                  color: Theme.of(context).buttonColor,
                                ),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(snapshot.data['avatar']),
                    ),
                    SizedBox(width: 10),
                    Text(snapshot.data["nickname"].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ))
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
            strokeWidth: 1,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(Icons.favorite_border_outlined),
                onPressed: () {},
              ),
            )
          ],
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          title: Center(
            child: Text(titledoc.toUpperCase(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          )),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      text: TextSpan(
                    text: 'Открыто до ',
                    style: TextStyle(),
                    children: [
                      TextSpan(
                          text: '1 МАЯ 9:00',
                          style:
                              TextStyle(color: Theme.of(context).accentColor))
                    ],
                  )),
                  Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: buildUser(userid)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xffd203f4),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      geo,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(9))),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          date,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text(time,
                            style: TextStyle(
                                color: Theme.of(context).backgroundColor,
                                fontSize: 16))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    width: 150,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(9))),
                    child: Center(
                      child: Text(
                        '$price руб/час',
                        style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                'Описание',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              )),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                    child: Text(
                  descr,
                  style: TextStyle(fontSize: 18),
                )),
              ),
              SizedBox(height: 30),
              Center(
                child:
                    (currentid == userid) ? Container() : buildButton(context),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Divider(thickness: 1, color: Colors.black),
              ),
              (currentid == userid)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      child: Text('Выбранные исполнители:',
                          style: TextStyle(fontSize: 16)),
                    )
                  : Container(),
              (currentid == userid)
                  ? buildExecutorFromCustomer()
                  : buildActiveExecutor(),
              (currentid == userid)
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 10, bottom: 10),
                      child:
                          Text('Откликнулись:', style: TextStyle(fontSize: 16)),
                    )
                  : Container(),
              (currentid == userid)
                  ? buildReplyExecutorFromCustomer()
                  : Container(),
            ],
          ),
        ),
      )),
    );
  }

  buildButton(BuildContext context) {
    jobid = widget.docView.id;
    final ref = FirebaseFirestore.instance
        .collection('users-jobs')
        .where('userid', isEqualTo: currentid)
        .where('jobid', isEqualTo: jobid);
    return StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length == 1) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Theme.of(context).hintColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                onPressed: () {},
                child: Text(
                  'ВЫ УЖЕ ОТКЛИКНУЛИСЬ',
                  style: TextStyle(
                      color: Theme.of(context).backgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              );
            } else {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Color(0xFF22B9DC),
                    padding:
                        EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                onPressed: () {
                  jobid = widget.docView.id;
                  jobSetup(jobid);
                  final snackBar = SnackBar(
                    content: Text(
                        'Вы откликнулись на предложение. Ожидайте подтверждения!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  createChat(userid, currentid);
                  if (chatid == null) {
                    chatid = "$userid - $currentid";
                  }
                  createNewUserChat(currentid, userid, chatid);
                },
                child: Text(
                  'СТАТЬ ИСПОЛНИТЕЛЕМ',
                  style: TextStyle(
                      color: Theme.of(context).backgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              );
            }
          } else {
            return Container();
          }
        });
  }

  buildActiveExecutor() {
    final ref = FirebaseFirestore.instance
        .collection('users-jobs')
        .where('jobid', isEqualTo: jobid)
        .where('status', isEqualTo: true);
    return StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          var length = snapshot.hasData ? snapshot.data.docs.length + 1 : 0;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount:
                persons, //snapshot.hasData ? snapshot.data.docs.length : 0,
            itemBuilder: (BuildContext context, int index) {
              length = length - 1;
              return Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(
                            'https://trust-import.com/perchatki-medicinskie/img/reviews-user-photo.jpg'),
                      ),
                      SizedBox(width: 10),
                      length > 0
                          ? Text('Занято',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor))
                          : Text('Свободно',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ))
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  buildExecutorFromCustomer() {
    final ref = FirebaseFirestore.instance
        .collection('users-jobs')
        .where('jobid', isEqualTo: jobid)
        .where('status', isEqualTo: true);
    return StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          String idexecutor;
          var length = snapshot.hasData ? snapshot.data.docs.length + 1 : 0;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount:
                persons, //snapshot.hasData ? snapshot.data.docs.length : 0,
            itemBuilder: (BuildContext context, int index) {
              length = length - 1;
              length > 0
                  ? idexecutor = snapshot.data.docs[index].get('userid')
                  : idexecutor = "";
              return Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Container(
                  width: double.infinity,
                  child: length > 0
                      ? Row(children: [
                          buildUser(idexecutor),
                          IconButton(
                              icon: Icon(Icons.close,
                                  color: Theme.of(context).primaryColor,
                                  size: 30),
                              onPressed: () {
                                String idusera =
                                    snapshot.data.docs[index].get('userid');
                                buildDialogReject(userid, idusera);
                              }),
                        ])
                      : Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                  'https://trust-import.com/perchatki-medicinskie/img/reviews-user-photo.jpg'),
                            ),
                            SizedBox(width: 10),
                            Text('Свободно',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ))
                          ],
                        ),
                ),
              );
            },
          );
        });
  }

  buildReplyExecutorFromCustomer() {
    final ref = FirebaseFirestore.instance
        .collection('users-jobs')
        .where('jobid', isEqualTo: jobid)
        .where('status', isEqualTo: false);
    final refaccept = FirebaseFirestore.instance
        .collection('users-jobs')
        .where('jobid', isEqualTo: jobid)
        .where('status', isEqualTo: true);
    return StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          String idexecutor;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.hasData ? snapshot.data.docs.length : 0,
            itemBuilder: (BuildContext context, int index) {
              idexecutor = snapshot.data.docs[index].get('userid');
              return Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Container(
                    width: double.infinity,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildUser(idexecutor),
                          SizedBox(
                            width: 10,
                          ),
                          StreamBuilder(
                              stream: ref.snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                var lengthaccept = snapshot.hasData
                                    ? snapshot.data.docs.length
                                    : 0;
                                return lengthaccept != persons
                                    ? IconButton(
                                        icon: Icon(Icons.check,
                                            color:
                                                Theme.of(context).accentColor,
                                            size: 30),
                                        onPressed: () {
                                          String iduseraccept = snapshot
                                              .data.docs[index]
                                              .get('userid');
                                          print(iduseraccept);
                                          buildDialogAccept(iduseraccept);
                                        })
                                    : Container();
                              }),
                          IconButton(
                              icon: Icon(Icons.close,
                                  color: Theme.of(context).primaryColor,
                                  size: 30),
                              onPressed: () {
                                String idusera =
                                    snapshot.data.docs[index].get('userid');
                                buildDialogDelete(idusera);
                              }),
                        ])),
              );
            },
          );
        });
  }

  buildDialogAccept(String userid) {
    showMaterialModalBottomSheet(
      backgroundColor: Color(0xFF262626),
      duration: Duration(milliseconds: 200),
      elevation: 4,
      expand: false,
      context: context,
      builder: (context) => Container(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: FutureBuilder(
                future: getUserData(userid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.arrow_downward_outlined,
                              size: 30,
                              color: Theme.of(context).buttonColor,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Text(
                                    'Вы уверены, что хотите назначить данного пользователя исполнителем?',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          NetworkImage(snapshot.data['avatar']),
                                    ),
                                    SizedBox(width: 10),
                                    Text(snapshot.data["nickname"].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16))
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).accentColor),
                                  onPressed: () {
                                    jobRewriteAccept(jobid, userid);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('ДА',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Theme.of(context).backgroundColor,
                                      )),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('НЕТ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Theme.of(context).backgroundColor,
                                      )),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    );
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    ),
                  );
                }),
          )),
    );
  }

  buildDialogDelete(String userid) {
    showMaterialModalBottomSheet(
      backgroundColor: Color(0xFF262626),
      duration: Duration(milliseconds: 200),
      elevation: 4,
      expand: false,
      context: context,
      builder: (context) => Container(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: FutureBuilder(
                future: getUserData(userid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.arrow_downward_outlined,
                              size: 30,
                              color: Theme.of(context).buttonColor,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Text(
                                    'Вы уверены, что хотите удалить отклик данного пользователя?',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          NetworkImage(snapshot.data['avatar']),
                                    ),
                                    SizedBox(width: 10),
                                    Text(snapshot.data["nickname"].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16))
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).accentColor),
                                  onPressed: () {
                                    jobDeleteExecutor(jobid, userid);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('ДА',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Theme.of(context).backgroundColor,
                                      )),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('НЕТ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Theme.of(context).backgroundColor,
                                      )),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    );
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    ),
                  );
                }),
          )),
    );
  }

  buildDialogReject(String userid, idusera) {
    showMaterialModalBottomSheet(
      backgroundColor: Color(0xFF262626),
      duration: Duration(milliseconds: 200),
      elevation: 4,
      expand: false,
      context: context,
      builder: (context) => Container(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: FutureBuilder(
                future: getUserData(idusera),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.arrow_downward_outlined,
                              size: 30,
                              color: Theme.of(context).buttonColor,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Text(
                                    'Вы уверены, что хотите отменить назначение данного пользователя исполнителем?',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Container(
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Container(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                            snapshot.data['avatar']),
                                      ),
                                      SizedBox(width: 10),
                                      Text(snapshot.data["nickname"].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16))
                                    ],
                                  ))),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).accentColor),
                                  onPressed: () {
                                    jobRewriteReject(jobid, idusera);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('ДА',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Theme.of(context).backgroundColor,
                                      )),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('НЕТ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Theme.of(context).backgroundColor,
                                      )),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    );
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    ),
                  );
                }),
          )),
    );
  }

  createChat(id1, id2) async {
    QuerySnapshot result = await Future.value(FirebaseFirestore.instance
        .collection('chat')
        .where('contact1', isEqualTo: id1)
        .where('contact2', isEqualTo: id2)
        .get());
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      QuerySnapshot result = await Future.value(FirebaseFirestore.instance
          .collection('chat')
          .where('contact2', isEqualTo: id1)
          .where('contact1', isEqualTo: id2)
          .get());
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        await FirebaseFirestore.instance
            .collection('chat')
            .doc('$id1-$id2')
            .set({
          "contact1": id1,
          "contact2": id2,
        });
        setState(() {
          chatid = '$id1 - $id2';
        });
        chatid = '$id1 - $id2';
        return chatid;
      } else
        print('the chat exists');
    } else
      print('the chat exists');
  }
}

createNewUserChat(currentid, id2, idchat) async {
  Timestamp time = Timestamp.now();
  QuerySnapshot result = await Future.value(FirebaseFirestore.instance
      .collection('Users')
      .doc(currentid)
      .collection('contacts')
      .where('contactid', isEqualTo: id2)
      .get());
  final List<DocumentSnapshot> documents = result.docs;
  if (documents.length == 0) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentid)
        .collection('contacts')
        .doc(idchat)
        .set({
      'contactid': id2,
      'lastmessage': '',
      'time': time,
      'senderid': '',
      'chatid': idchat,
      'isRead': false
    });
  } else
    print('Contact exists');

  QuerySnapshot result2 = await Future.value(FirebaseFirestore.instance
      .collection('Users')
      .doc(id2)
      .collection('contacts')
      .where('contactid', isEqualTo: currentid)
      .get());
  final List<DocumentSnapshot> documents2 = result2.docs;
  if (documents2.length == 0) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(id2)
        .collection('contacts')
        .doc(idchat)
        .set({
      'contactid': currentid,
      'lastmessage': '',
      'time': time,
      'senderid': '',
      'chatid': idchat,
      'isRead': false
    });
  } else
    print('Contact exists');
}
