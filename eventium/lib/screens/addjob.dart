import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventium/screens/homescreen.dart';
import 'package:eventium/screens/profilescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddJobScreen extends StatefulWidget {
  @override
  _AddJobScreenState createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descrController = TextEditingController();
  TextEditingController metroController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController timestartController = TextEditingController();
  TextEditingController timeendController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController personsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: Text('Добавить задание'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                buildTextEdit(context, 'НАЗВАНИЕ', titleController,
                    TextInputType.name, 12, 1, 50),
                buildTextEdit(context, 'МЕТРО', metroController,
                    TextInputType.name, 20, 1, 50),
                buildTextEdit(context, 'ЦЕНА В ЧАС', priceController,
                    TextInputType.number, 5, 1, 50,
                    shirina: 220),
                buildTextEdit(
                  context,
                  'КОЛИЧЕСТВО ЧЕЛОВЕК',
                  personsController,
                  TextInputType.number,
                  2,
                  1,
                  50,
                ),
                buildTextEdit(
                  context,
                  'ДАТА',
                  dateController,
                  TextInputType.datetime,
                  10,
                  1,
                  50,
                ),
                Row(
                  children: [
                    buildTextEdit(context, '00:00', timestartController,
                        TextInputType.datetime, 5, 1, 50,
                        shirina: 285),
                    Text(' - '),
                    buildTextEdit(context, '00:00', timeendController,
                        TextInputType.datetime, 5, 1, 50,
                        shirina: 285),
                  ],
                ),
                buildTextEdit(context, 'ОПИСАНИЕ', descrController,
                    TextInputType.multiline, 100, null, 200),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: OutlinedButton(
                      onPressed: () {
                        String titleJob = titleController.text;
                        String metroJob = metroController.text;
                        String priceJob = priceController.text;
                        String personsJob = personsController.text;
                        String dateJob = dateController.text;
                        String timeJob =
                            '${timestartController.text} - ${timeendController.text}';
                        String descrJob = descrController.text;
                        int persons = int.parse(personsJob);
                        jobSetup(titleJob, metroJob, priceJob, dateJob, timeJob,
                            descrJob, persons);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      child: Text(
                        'Добавить задание',
                        style: TextStyle(
                            color: Theme.of(context).buttonColor, fontSize: 16),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildTextEdit(BuildContext context, title, controller, type, lenght, lines,
      double height,
      {shirina = 100}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        width: MediaQuery.of(context).size.width - shirina,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).hintColor,
        ),
        child: TextFormField(
          style:
              TextStyle(fontSize: 18, color: Theme.of(context).backgroundColor),
          cursorColor: Theme.of(context).backgroundColor,
          maxLines: lines,
          maxLength: lenght,
          autofocus: false,
          autocorrect: false,
          controller: controller,
          keyboardType: type,
          decoration: InputDecoration(
              hintText: title,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: TextStyle(
                  color: Theme.of(context).backgroundColor, fontSize: 18),
              counterText: '',
              prefixStyle: TextStyle(
                  color: Theme.of(context).backgroundColor, fontSize: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintStyle: TextStyle(color: Colors.grey[700], fontSize: 18),
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.all(13),
              enabledBorder: InputBorder.none),
        ),
      ),
    );
  }
}

Future<void> jobSetup(title, metro, price, date, time, descr, persons) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid;

  Map<String, dynamic> theData = {
    "userid": uid,
    "title": title,
    "geo": metro,
    "price": price,
    "date": date,
    "time": time,
    "descr": descr,
    "newstatus": true,
    "persons": persons
  };

  FirebaseFirestore.instance.collection("jobs").doc().set(theData);
  return;
}
