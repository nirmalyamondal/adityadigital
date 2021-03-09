import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:adityadigital/screens/dashboard_screen/dashboard_screen.dart';
import 'package:adityadigital/screens/detail_screen/detail_screen.dart';
import 'package:adityadigital/screens/login_screen/login_screen.dart';
import 'package:adityadigital/screens/otp_screen/otp_screen.dart';
import 'package:adityadigital/screens/profile_screen/profile_screen.dart';
import 'package:adityadigital/screens/task_screen/task_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //const PrimaryColor = const Color(0xFF151026);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aditya Digital OTP Authentication',
      theme: ThemeData(
        //primaryColor: const Color.fromARGB(255, 253, 188, 51),
        primaryColor: Color(0xFF151026)
      ),
      home: LoginScreen(),
      routes: <String, WidgetBuilder>{
      '/loginScreen': (BuildContext ctx) => LoginScreen(),
      '/otpScreen': (BuildContext ctx) => OtpScreen(''),
      '/dashboardScreen': (BuildContext ctx) => DashboardScreen(),
      '/taskScreen': (BuildContext ctx) => TaskScreen(),
      '/detailScreen': (BuildContext ctx) => DetailScreen(),
      '/profileScreen': (BuildContext ctx) => ProfileScreen(),
      },
    );
  }

}
