import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: SingleChildScrollView(
              child: Column(children: [Text('lol'), buildExecutor()]))),
    );
  }
}

buildExecutor() {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: 30,
    physics: NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(index.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white)),
        ],
      );
    },
  );
}
