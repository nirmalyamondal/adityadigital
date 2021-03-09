import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pinput/pin_put/pin_put.dart';

//import 'package:adityadigital/screens/dashboard_screen/dashboard_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  OtpScreen(this.phone);
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode = '';
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.only(left: 30.0),
          icon: new Icon(Icons.arrow_back_ios),
          iconSize: 25,
          color: Colors.white,
          splashColor: Colors.red,
          onPressed: () {
            Navigator.pushNamed(context, '/loginScreen');
          },
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
            ),
          ),
          Container (
            alignment: Alignment.center,
            margin: EdgeInsets.only(top:15.0),
                  child: Text(
                    'OTP Verification for Moble Number',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
          ),
          Container (
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 10),
            child: Text(
              '+91 ${widget.phone}',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
              eachFieldWidth: 50.0,
              eachFieldHeight: 50.0,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              onSubmit: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: _verificationCode, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('loggedInMobile', '${widget.phone}');
                      Navigator.pushNamed(context, '/dashboardScreen', arguments: '${widget.phone}');
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  //_scaffoldkey.currentState
                  //    .showSnackBar(SnackBar(content: Text('invalid OTP' )));
                  _scaffoldkey.currentState.showSnackBar(
                    new SnackBar(
                        backgroundColor: Colors.red,
                        duration: Duration(milliseconds: 5000),
                        content: Container(
                          height: 50.0,
                          child: Center(
                            child: new Text(
                              'Invalid OTP',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                              //style: textStyle.lightText.copyWith(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('loggedInMobile', '${widget.phone}');
              //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardScreen()), (route) => false);
              Navigator.pushNamed(context, '/dashboardScreen', arguments: '${widget.phone}');
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
