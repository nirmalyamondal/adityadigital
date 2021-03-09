import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final clickOnLogin;

  // ignore: sort_constructors_first
  const CustomButton(this.clickOnLogin);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        clickOnLogin(context);
      },
      child: Container(
        margin: const EdgeInsets.only(top:15.0, right:30.0, left:30.0),
        //padding: EdgeInsets.only(top: 0.0, bottom: 0.0, right:15.0, left:15.0),
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          //color: const Color.fromARGB(255, 253, 188, 51),
          color: const Color(0xFF151026),
          borderRadius: BorderRadius.circular(36),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Send OTP',
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
    );
  }
}
