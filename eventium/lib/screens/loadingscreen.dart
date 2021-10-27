import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'EVENTIUM',
            style: TextStyle(fontSize: 50),
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 8,
              ),
              Text(
                'площадка подработки',
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).buttonColor),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 7,
          ),
          Container(
            child: SpinKitDualRing(
              color: Theme.of(context).buttonColor,
              size: 60,
            ),
          ),
        ],
      ),
    );
  }
}
