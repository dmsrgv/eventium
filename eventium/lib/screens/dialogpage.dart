import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventium/net/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DialogPage extends StatefulWidget {
  final DocumentSnapshot docView;
  final nickname;
  final avatar;
  final contactid;
  DialogPage({this.nickname, this.avatar, this.docView, this.contactid});

  @override
  _DialogPageState createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  String chatid;
  String nickname;
  String useravatar;
  String currentavatar;
  String avatar;
  String contactid;

  @override
  void initState() {
    chatid = widget.docView.get('chatid');
    nickname = widget.nickname;
    useravatar = widget.avatar;
    contactid = widget.contactid;
    super.initState();
  }

  Future<DocumentSnapshot> getUserData(userid) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(userid)
        .get();
  }

  TextEditingController messageController = TextEditingController();
  String currentid = FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    print(avatar);
    final ref = FirebaseFirestore.instance
        .collection('chat')
        .doc(chatid)
        .collection('messages');
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(nickname),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder(
                stream: ref.orderBy('time', descending: true).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.hasData ? snapshot.data.docs.length : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: currentid ==
                                  snapshot.data.docs[index].get('senderid')
                              ? buildOneCurrentMessage(
                                  context,
                                  'https://trust-import.com/perchatki-medicinskie/img/reviews-user-photo.jpg',
                                  snapshot.data.docs[index].get('message'),
                                  snapshot.data.docs[index].get('time'))
                              : buildOneMessage(
                                  context,
                                  useravatar,
                                  snapshot.data.docs[index].get('message'),
                                  snapshot.data.docs[index].get('time')));
                    },
                  );
                }),
          ),
          buildEditMessage(context)
        ],
      ),
    );
  }

  buildEditMessage(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            cursorColor: Theme.of(context).buttonColor,
            style: TextStyle(fontSize: 18),
            autofocus: false,
            autocorrect: false,
            maxLines: null,
            controller: messageController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              fillColor: Color(0xFF242424),
              filled: true,
              hintText: 'Сообщение.....',
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: TextStyle(fontSize: 18),
              counterText: '',
              prefixStyle: TextStyle(fontSize: 18),
              hintStyle: TextStyle(color: Colors.grey[700], fontSize: 18),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                      width: 2, color: Theme.of(context).buttonColor)),
              contentPadding: EdgeInsets.all(13),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFF242424)),
                  borderRadius: BorderRadius.circular(25)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ),
        OutlinedButton(
            onPressed: () async {
              String message = messageController.text;
              String senderid = FirebaseAuth.instance.currentUser.uid;
              Timestamp time = Timestamp.now();
              print(chatid);
              await FirebaseFirestore.instance
                  .collection('chat')
                  .doc(chatid)
                  .collection('messages')
                  .add(
                      {"senderid": senderid, "message": message, "time": time});
              messageController.clear();
              lastMessageUpdate(chatid, contactid, senderid, message, time);
            },
            child: Text('Отправить'),
            style: OutlinedButton.styleFrom(
                backgroundColor: Theme.of(context).backgroundColor))
      ],
    );
  }

  buildOneMessage(BuildContext context, avatar, message, time) {
    Timestamp timestamp = time;
    DateTime dateTime = timestamp.toDate();
    DateFormat dateFormat = DateFormat("HH:mm");
    String vremya = dateFormat.format(dateTime);

    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(avatar),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
              color: Color(0xFF383838),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(message, style: TextStyle(fontSize: 16)),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Text("$vremya")
      ],
    );
  }

  buildOneCurrentMessage(BuildContext context, avatar, message, time) {
    Timestamp timestamp = time;
    DateTime dateTime = timestamp.toDate();
    DateFormat dateFormat = DateFormat("HH:mm");
    String vremya = dateFormat.format(dateTime);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("$vremya"),
        SizedBox(
          width: 20,
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
              color: Theme.of(context).buttonColor,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(message,
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).backgroundColor)),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        FutureBuilder(
            future: getUserData(currentid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(snapshot.data['avatar']),
                );
              } else if (snapshot.connectionState == ConnectionState.none) {
                return CircularProgressIndicator();
              }

              return CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                    'https://trust-import.com/perchatki-medicinskie/img/reviews-user-photo.jpg'),
              );
            }),
      ],
    );
  }
}
