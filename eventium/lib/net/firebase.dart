import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> userSetup(nickname, photourl, isCustomer) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid;

  Map<String, dynamic> theData = {
    "UID": uid,
    "nickname": nickname,
    "orders": 0,
    "rating": 0.0,
    "verifstatus": false,
    "iscustomer": isCustomer,
    "info": 'Нет информации',
    "avatar": photourl,
  };

  FirebaseFirestore.instance.collection("Users").doc(uid).set(theData);
  return;
}

Future<void> jobSetup(idjob) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid;
  Map<String, dynamic> theData = {
    "userid": uid,
    "jobid": idjob,
    "status": false,
  };
  String iduserjob = uid + idjob;
  FirebaseFirestore.instance
      .collection("users-jobs")
      .doc(iduserjob)
      .set(theData);
  return;
}

Future<void> jobRewriteAccept(idjob, iduser) async {
  Map<String, dynamic> theData = {
    "userid": iduser,
    "jobid": idjob,
    "status": true,
  };
  String iduserjob = iduser + idjob;
  FirebaseFirestore.instance
      .collection("users-jobs")
      .doc(iduserjob)
      .update(theData);
  return;
}

Future<void> jobRewriteReject(idjob, iduser) async {
  Map<String, dynamic> theData = {
    "userid": iduser,
    "status": false,
    "jobid": idjob,
  };
  String iduserjob = iduser + idjob;

  FirebaseFirestore.instance
      .collection("users-jobs")
      .doc(iduserjob)
      .update(theData);
  return;
}

Future<void> jobDeleteExecutor(idjob, iduser) async {
  String iduserjob = iduser + idjob;
  FirebaseFirestore.instance.collection("users-jobs").doc(iduserjob).delete();
  return;
}

Future<void> createChat(userid) async {
  Map<String, dynamic> theData = {
    "senderid": "init",
    "message": "",
  };

  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid;
  String idchat = uid + '-' + userid;
  final checkchat =
      await FirebaseFirestore.instance.collection('chat').doc("idchat").get();
  final chatcheck = await FirebaseFirestore.instance
      .collection('chat')
      .doc("checkchat")
      .get();
  if (checkchat.exists) {
    return;
  } else if (chatcheck.exists) {
    return;
  } else {
    FirebaseFirestore.instance
        .collection('chat')
        .doc(idchat)
        .collection('messages')
        .doc()
        .set(theData);
  }
  return;
}

checkNickname(nickname) async {
  final ref = await FirebaseFirestore.instance
      .collection("Users")
      .where('nickname', isEqualTo: nickname)
      .get();

  int len = ref.docs.length;
  return len;
}

Future<void> lastMessageUpdate(chatid, userid, senderid, message, time) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid;
  FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('contacts')
      .doc(chatid)
      .update({
    'senderid': senderid,
    'lastmessage': message,
    'time': time,
    'isRead': false
  });
  FirebaseFirestore.instance
      .collection('Users')
      .doc(userid)
      .collection('contacts')
      .doc(chatid)
      .update({
    'senderid': senderid,
    'lastmessage': message,
    'time': time,
    'isRead': false
  });
  return;
}

Future<void> isReadUpdate(chatid, userid) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid;
  FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('contacts')
      .doc(chatid)
      .update({'isRead': true});
  FirebaseFirestore.instance
      .collection('Users')
      .doc(userid)
      .collection('contacts')
      .doc(chatid)
      .update({'isRead': true});
  return;
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
