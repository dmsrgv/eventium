import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'codescreen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController numberController = TextEditingController();
  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 10),
                  Text(
                    'ВАШ НОМЕР ТЕЛЕФОНА',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).buttonColor),
                    child: Center(
                      child: TextFormField(
                        inputFormatters: [
                          TextInputMask(
                            mask: '(999)999-99-99',
                            reverse: false,
                            placeholder: "_",
                            maxPlaceHolders: 11,
                          )
                        ],
                        cursorColor: Theme.of(context).backgroundColor,
                        style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                            fontSize: 18),
                        autofocus: false,
                        autocorrect: false,
                        controller: numberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: '+7',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelStyle: TextStyle(
                                color: Theme.of(context).backgroundColor,
                                fontSize: 18),
                            counterText: '',
                            prefixText: '+7',
                            prefixStyle: TextStyle(
                                color: Theme.of(context).backgroundColor,
                                fontSize: 18),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintStyle: TextStyle(
                                color: Theme.of(context).backgroundColor,
                                fontSize: 18),
                            helperStyle: TextStyle(
                                color: Theme.of(context).backgroundColor),
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.all(13),
                            enabledBorder: InputBorder.none),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'отправим на этот номер код подтверждения',
                    style: TextStyle(
                        fontSize: 14, color: Theme.of(context).hintColor),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 350,
                  ),
                  Container(
                    width: 280,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: onPress,
                        child: Text('ОТПРАВИТЬ КОД',
                            style: TextStyle(
                                color: Theme.of(context).backgroundColor)),
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).buttonColor,
                          onPrimary: Theme.of(context).backgroundColor,
                          textStyle: TextStyle(fontSize: 18),
                        )),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void onPress() {
    RegExp exp = RegExp(r"[^\w\s]+");
    String number = numberController.text.replaceAll(exp, '');
    if (number != null && number.length == 10) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CodeScreen(number)),
      );
    } else {
      Fluttertoast.showToast(
          msg: "Неправильный номер",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
