import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventium/net/firebase.dart';
import 'package:eventium/screens/dialogpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final uid = FirebaseAuth.instance.currentUser.uid;
  final ref = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('contacts');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: Center(child: Text('Диалоги')),
      ),
      body: StreamBuilder(
          stream: ref.orderBy('time', descending: true).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return ListView.builder(
                itemCount: snapshot.hasData ? snapshot.data.docs.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder(
                    future:
                        getUserData(snapshot.data.docs[index].get('contactid')),
                    builder: (context, query) {
                      if (query.connectionState == ConnectionState.done) {
                        return GestureDetector(
                            onTap: () {
                              String chatid =
                                  snapshot.data.docs[index].get('chatid');
                              isReadUpdate(chatid, query.data['UID']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DialogPage(
                                        contactid: query.data['UID'],
                                        nickname: query.data['nickname'],
                                        avatar: query.data['avatar'],
                                        docView: snapshot.data.docs[index])),
                              );
                            },
                            child: buildOneDialog(
                                context,
                                query.data['nickname'],
                                snapshot.data.docs[index].get('lastmessage'),
                                query.data['avatar'],
                                snapshot.data.docs[index].get('time'),
                                snapshot.data.docs[index].get('senderid'),
                                snapshot.data.docs[index].get('isRead')));
                      } else if (query.connectionState ==
                          ConnectionState.none) {
                        return Center(
                          child: Container(),
                        );
                      }
                      return Center(
                        child: Container(),
                      );
                    },
                  );
                });
          }),
    );
  }

  Future<DocumentSnapshot> getUserData(iduser) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(iduser)
        .get();
  }

  buildOneDialog(
      BuildContext context, nickname, message, avatar, time, senderid, isRead) {
    if (isRead == null) {
      isRead = false;
    }
    Timestamp timestamp = time;
    DateTime dateTime = timestamp.toDate();
    DateFormat dateFormat = DateFormat("HH:mm");
    String vremya = dateFormat.format(dateTime).toString();
    return Container(
      height: 100,
      color: isRead == false ? Color(0xFF242424) : Color(0xFF121212),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(avatar),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nickname,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: senderid == uid
                              ? Text(
                                  'Вы: $message',
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                )
                              : Text(
                                  message,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ))
                    ],
                  ),
                ),
              ],
            ),
            Text(vremya)
          ],
        ),
      ),
    );
  }
}
