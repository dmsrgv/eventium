import 'package:eventium/screens/test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/landingscreen.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF121212),
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eventium App',
      theme: ThemeData(
        splashColor: const Color(0xFF1f1f1f),
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Color(0xFFe1e3e6)),
            titleTextStyle: TextStyle(color: Color(0xFFe1e3e6)),
            actionsIconTheme: IconThemeData(color: Color(0xFFe1e3e6))),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryTextTheme:
            TextTheme(headline6: TextStyle(color: Color(0xFFe1e3e6))),
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)
            .apply(
                bodyColor: Color(0xFFe1e3e6), displayColor: Color(0xFFe1e3e6)),
        primaryColor: const Color(0xFFeab4b4),
        accentColor: const Color(0xFF99CF9A),
        highlightColor: const Color(0xFF000000),
        backgroundColor: const Color(0xFF121212),
        hintColor: const Color(0xFFe1e3e6),
        cardColor: const Color(0xFF262626),
        buttonColor: const Color(0xFF22B9DC),
      ),
      home: LandingScreen(),
      //home: TestDrawerScreen(),
    );
  }
}
