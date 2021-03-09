import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../../model/message/message_model.dart';

class DetailScreen extends StatefulWidget {

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final String jsonTaskDetail = '{"uid":1,"taskid":"TV000131","product":"My Purchased product 1","crdate":"27-11-2020","technician":"John Doe","tphone":"7585872224","code":"2356"}';
  final String jsonMessages = '[{"uid":1,"name":"Technician","datetime":"27-11-2019 [11.10 AM]","comment":"Comment 1 Problem discussion goes here"}, {"uid":2,"name":"Technician","datetime":"28-11-2019 [11.10 AM]","comment":"Comment 2 Problem discussion goes here"},{"uid":3,"name":"Customer","datetime":"29-11-2019 [11.10 AM]","comment":"Comment 3 Problem discussion goes here"},{"uid":4,"name":"Customer","datetime":"30-11-2019 [11.10 AM]","comment":"Comment 4 Problem discussion goes here"},{"uid":5,"name":"Technician","datetime":"31-11-2019 [11.10 AM]","comment":"Comment 5 Problem discussion goes here"},{"uid":6,"name":"Technician","datetime":"31-11-2019 [11.10 AM]","comment":"Comment 6 Problem discussion goes here"}]';
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Map<String, dynamic> formData = {
    "message": null,
  };

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    var _contact = args["_contact"];
    var _taskId = args["_taskId"];
    final Map<String, dynamic> jsonTaskDetailDecode = jsonDecode(jsonTaskDetail);
    final List<Color> colors = <Color>[Colors.red, Colors.grey, Colors.amber];
    final jsonMessagesDecode = jsonDecode(jsonMessages);
    MessagesList messagesList = MessagesList.fromJson(jsonMessagesDecode);
    //print("messagesList " + messagesList.messages[1].comment);

    var size = MediaQuery.of(context).size;
    //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: new Icon(Icons.account_circle),
          iconSize: 35,
          color: Colors.white,
          splashColor: Colors.red,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/profileScreen', arguments: '${_contact}');
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
      body: new SafeArea (
              top: false,
              bottom: false,
              child: new Form(
                  key: _formKey,
                  //autovalidate: true,
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
                              child: Text('Welcome, Abcdefghijkl {${_contact}}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF151026)), softWrap: true),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: new EdgeInsets.only(top:0.0,bottom:5.0,left:15.0),
                        margin: const EdgeInsets.only(top:10.0,bottom:10.0),
                        color: Colors.grey, // Yellow
                        alignment: Alignment.centerLeft,
                        child: Text('Ticket Detail', textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold, height: 1.75, fontSize: 16, color: Colors.black), softWrap: true),
                      ),
                      Container(
                        color: Colors.white,
                        padding: new EdgeInsets.only(left:15.0),
                        //margin: const EdgeInsets.only(top:10.0,bottom:10.0),
                        child: Table(
                          //border: TableBorder.all(color: Colors.black),
                          children: [
                            TableRow(children: [
                              Text('Ticket Id', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(jsonTaskDetailDecode['taskid']),
                            ]),
                            TableRow(children: [
                              Text('Product', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(jsonTaskDetailDecode['product']),
                            ]),
                            TableRow(children: [
                              Text('Created On', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(jsonTaskDetailDecode['crdate']),
                            ]),
                            TableRow(children: [
                              Text('Technician Phone', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(jsonTaskDetailDecode['tphone']),//jsonTaskDetailDecode['technician']),
                            ]),
                            TableRow(children: [
                              Text('Passcode', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(jsonTaskDetailDecode['code'],
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.withOpacity(1.0)),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      Container(
                        padding: new EdgeInsets.only(top:0.0,bottom:5.0,left:15.0),
                        margin: const EdgeInsets.only(top:10.0,bottom:5.0),
                        color: Colors.grey, // Yellow
                        alignment: Alignment.centerLeft,
                        child: Text('Discussion', textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold, height: 1.75, fontSize: 16, color: Colors.black), softWrap: true),
                      ),
                      Container(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: messagesList.messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            //print(messagesList.messages[index].name);

                            return Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(5.0),
                              width: 100.0,
                              child: Table(
                                //border: TableBorder.all(color: Colors.black),
                                children: [
                                  TableRow(children: [
                                    Container(
                                      width: 100.0,
                                      child: Text(messagesList.messages[index].name + ':  ' + messagesList.messages[index].datetime),
                                      //Text(messagesList.messages[index].datetime), //, textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold, color: colors[colorIndex])
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Container(
                                      width: 100.0,
                                      //Text(messagesList.messages[index].uid, textAlign: TextAlign.left, overflow: TextOverflow.ellipsis),
                                      child: Text(messagesList.messages[index].comment, textAlign: TextAlign.left, overflow: TextOverflow.ellipsis),
                                    ),
                                  ]),
                                ],
                              ),
                            );
                          },
                        ),
                      ),


                      new TextFormField(
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Write message',
                          labelText: 'Enter New Message',
                        ),
                        keyboardType: TextInputType.name,
                        onChanged: (String newValue) {
                          formData["message"] = newValue;
                        },
                        onSaved: (String newValue) {
                          formData["message"] = newValue;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter message!';
                          }
                          return null;
                        },
                      ),
                      new Container(
                          padding: const EdgeInsets.only(left: 0.0, top: 5.0),
                          child: new RaisedButton(
                            child: const Text('Submit'),
                            color: Colors.grey,
                            //onPressed: _submittable() ? _submit : null,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                // Process data.
                                formData["phone"] = _contact;
                                print(formData);
                                //return;
                              }
                              //Navigator.pushReplacementNamed(context, '/dashboardScreen', arguments: '${args}');
                            },
                          )
                      ),
                    ],
                  ),
              ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboardScreen', arguments: '${_contact}');
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

}
