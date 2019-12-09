import 'package:chatty/screens/onboarding/onboarding_screen.dart';
import 'package:chatty/screens/mainscreen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OnBoarding Demo',
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        )
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Onboarding(),
    );
  }
}
