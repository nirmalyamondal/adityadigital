import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adityadigital/screens/otp_screen/otp_screen.dart';
import 'package:adityadigital/widget/custom_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    _getLoggedInStatus();
  }
  TextEditingController _contactEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: Colors.transparent,
        ),
        title: Text('Aditya Digital Services'),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.power_settings_new),
            iconSize: 30,
            color: Colors.red,
            splashColor: Colors.red,
            padding: EdgeInsets.only(right:30.0),
            onPressed: ()=> exit(0),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: 50.0, bottom: 30.0),
              //height: screenHeight * 0.25,
              //width: screenWidth * 0.5,
              width: 200.0,
              height: 62.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.contain,
                ),
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.blueAccent),
                //borderRadius: BorderRadius.circular(80.0),
              ),
            ),
            Container(
              //margin: EdgeInsets.only(top: 15),
              child: Center(
                child: Text(
                  'Enter Your Mobile Number',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 30.0, left: 30.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Mobile Number',
                  prefix: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text('+91'),
                  ),
                  icon: Icon(Icons.phone_iphone)
                ),
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: _contactEditingController,
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
              ),
            ),
          CustomButton(clickOnLogin),
        ],
      ),
    );
  }

  //Login click with contact number validation
  Future<void> clickOnLogin(BuildContext context) async {
    if (_contactEditingController.text.isEmpty) {
      showErrorDialog(context, 'Mobile Number can\'t be empty!');
    } else if(_contactEditingController.text.length != 10) {
      showErrorDialog(context, 'Mobile Number must be of 10 digit!');
    } else {
      final responseMessage =
          //await Navigator.pushNamed(context, '/OtpScreen', arguments: '+91${_contactEditingController.text}');
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtpScreen(_contactEditingController.text)));
      if (responseMessage != null) {
        showErrorDialog(context, responseMessage as String);
      }
    }
  }

  //Alert dialogue to show error and response
  void showErrorDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Gets the logged in status
  void _getLoggedInStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final loggedInMobile = (pref.getString('loggedInMobile') == '') ? false : pref.getString('loggedInMobile');
    if ((loggedInMobile != false) && (loggedInMobile != null)){
      //print('loggedInMobile ${loggedInMobile}');
      Navigator.pushNamed(context, '/dashboardScreen', arguments: '${loggedInMobile}');
    }
  }

}
