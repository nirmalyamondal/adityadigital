import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Map<String, dynamic> formData = {
    "phone": null,
    "name": null,
    "email": null,
    "address": null,
    "product": null,
    "issue": null,
  };
  //formData["phone"] = '${args}';
  //List<String> _colors = <String>['', 'black', 'red', 'green', 'blue', 'orange'];
  //String _color = '';
  List<String> _products = ['Select Product', 'Mobile iPhone-XABC1234iU#', 'Television Sony-ZBBC123#iUi', 'Mobile Samsung-ZZBC1#234iU', 'Air Condition-DD#C1299U'];
  String _selectedProduct = '';
  List<String> _issues = ['Power Failure', 'Display Not Coming', 'Damage Product', 'TV Channel Missing', 'Internet Offline','Other'];
  String _selectedIssue = '';
  int submit = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width;
    final args = ModalRoute.of(context).settings.arguments;
    //final Map<String, dynamic> _argsMap = ModalRoute.of(context).settings.arguments;
    //var _contact = _argsMap["_contact"];
    var _contact = args;
    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: new Icon(Icons.home),
          iconSize: 35,
          color: Colors.white,
          splashColor: Colors.purple,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/dashboardScreen', arguments: '${args}');
          },
        ),
        title: Text('Aditya Customer Services'),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.power_settings_new),
            iconSize: 30,
            color: Colors.red,
            splashColor: Colors.red,
            padding: EdgeInsets.only(right:5.0),
            onPressed: () {
              logoutUser();
            },
          ),
        ],
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              //autovalidate: true,
              autovalidateMode: AutovalidateMode.always,
              child: new ListView(
                padding: EdgeInsets.only(top: 0.0, bottom: 0.0, right:15.0, left:15.0),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 35.0,
                          width: 35.0,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/logo-small.png'),
                              fit: BoxFit.contain,
                            ),
                            //shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          width: (itemWidth - 65.0),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left:15.0),
                          //color: Colors.green,
                          child: Text('Welcome, Abcdefghijkl {${args}}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF151026)), softWrap: true),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: new EdgeInsets.only(top:0.0,bottom:5.0,left:15.0),
                    margin: const EdgeInsets.only(top:10.0,bottom:10.0),
                    color: Colors.grey, // Yellow
                    alignment: Alignment.centerLeft,
                    child: Text('Profile Screen', textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold, height: 1.75, fontSize: 16, color: Colors.black), softWrap: true),
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.phone),
                      hintText: 'Enter a phone number',
                      labelText: 'Phone',
                    ),
                    keyboardType: TextInputType.phone,
                    readOnly: true,
                    initialValue: '${args}',
                    /*onChanged: (String newValue) {
                      formData["phone"] = newValue;
                    },
                    onSaved: (String newValue) {
                      formData["phone"] = newValue;
                    },*/
                    inputFormatters: [
                      //WhitelistingTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Enter your name',
                      labelText: 'Name',
                    ),
                    keyboardType: TextInputType.name,
                    onChanged: (String newValue) {
                      formData["name"] = newValue;
                    },
                    onSaved: (String newValue) {
                      formData["name"] = newValue;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.email),
                      hintText: 'Enter a email address',
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (String newValue) {
                      formData["email"] = newValue;
                    },
                    onSaved: (String newValue) {
                      formData["email"] = newValue;
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.subject),
                      hintText: 'Enter your address',
                      labelText: 'Address',
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (String newValue) {
                      formData["address"] = newValue;
                    },
                    onSaved: (String newValue) {
                      formData["address"] = newValue;
                    },
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 0.0, top: 15.0),
                      child: new RaisedButton(
                        child: const Text('Submit'),
                        color: submit == 0 ? Colors.grey : Colors.grey,
                        //onPressed: _submittable() ? _submit : null,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            // Process data.
                            formData["phone"] = '${args}';
                            print(formData);
                            //return;
                          }
                          Navigator.pushReplacementNamed(context, '/dashboardScreen', arguments: '${args}');
                        },
                      )
                  ),
                ],
              ),
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/dashboardScreen', arguments: '${args}');
        },
        splashColor: Colors.red,
        child: Icon(Icons.home, size: 30, color: Color(0xFF151026) ),
        backgroundColor: Colors.white,
      ),
    );
  }

  void logoutUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loggedInMobile', '');
    Navigator.pushReplacementNamed(context, '/loginScreen');
  }

  /*bool _submittable() {
    return _agreedToTOS;
  }

  void _submit() {
    _formKey.currentState.validate();
    print('Form submitted');
  }*/

}
