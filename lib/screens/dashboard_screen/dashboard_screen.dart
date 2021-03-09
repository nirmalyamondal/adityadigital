import 'dart:convert';
//import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:json_table/json_table.dart';
import 'package:marquee/marquee.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
    @override
    _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _jsonProducts = '[{"uid":0,"product":"No Product Found!","amc":"0 Day(s)","invoice":"http://www.africau.edu/images/default/sample.pdf"}]';
  String _jsonTasks = '[{"uid":0, "id":"0","product":"Noi Task Found!","technician":"7585872225","dlink":"https://google.com/"}]';

  bool toggle = true;
  //Create your column list
  var columnsProducts = [
    JsonTableColumn('uid', label: 'Prod Id'),
    JsonTableColumn('product', label: 'Product'),
    JsonTableColumn('amc', label: 'AMC Expiry'),
    JsonTableColumn('invoice', label: 'Invoice', valueBuilder: generateProductInvoice),
  ];
  //Create your column list
  var columnsTasks = [
    JsonTableColumn('uid', label: 'Task Id'),
    JsonTableColumn('product', label: 'Product'),
    JsonTableColumn('technician', label: 'Technician'),
    JsonTableColumn('dlink', label: 'Detail', valueBuilder: generateTaskDetail),
  ];

    @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    final jsonProductsDecode = jsonDecode(_jsonProducts);
    final jsonTasksDecode = jsonDecode(_jsonTasks);

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
            Navigator.pushReplacementNamed(context, '/profileScreen', arguments: '${args}');
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
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 0.0, bottom: 0.0, right:15.0, left:15.0),
        child: Container(
          child: toggle
              ? Column(
            children:  [
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
                //width: itemWidth-30,
                //padding: EdgeInsets.only(top:15.0,bottom:5.0,right:15.0),
                height: 45,
                child: Marquee(
                  text: 'There once was a boy who told this story about a boy: "',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF151026)),
                  blankSpace: 20.0,
                  velocity: 25.0,
                  pauseAfterRound: Duration(seconds: 1),
                  startPadding: 10.0,
                ),
              ),
              Container(
                padding: new EdgeInsets.only(top:0.0,bottom:5.0,left:15.0),
                margin: const EdgeInsets.only(top:0.0,bottom:10.0),
                //color: Colors.grey, // Yellow
                color: const Color(0xFF151026),
                alignment: Alignment.centerLeft,
                child: Text('Your Tickets', textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, height: 1.75, fontSize: 16, color: Colors.white), softWrap: true),
              ),
              Container(
                color: Colors.white, // Yellow
                alignment: Alignment.centerLeft,
                child: JsonTable(
                  jsonTasksDecode,
                  columns: columnsTasks,
                  showColumnToggle: false,
                  allowRowHighlight: true,
                  rowHighlightColor: Colors.yellow[500].withOpacity(0.7),
                  //paginationRowCount: 10,
                  onRowSelect: (index, map) {
                    var _taskId = map['uid'];
                    Navigator.pushReplacementNamed(
                        context,
                        '/detailScreen',
                        arguments: {'_contact':'${args}' , '_taskId': _taskId}
                    );
                  },
                  tableCellBuilder: (value) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                      decoration: BoxDecoration(border:Border.all(width: 0.5, color: Colors.grey.withOpacity(0.5))),
                      child: Text(value),
                    );
                  },
                ),
              ),
              Container(
                padding: new EdgeInsets.only(top:0.0,bottom:5.0,left:15.0),
                margin: const EdgeInsets.only(top:10.0,bottom:10.0),
                //color: Colors.grey, // Yellow
                color: const Color(0xFF151026),
                alignment: Alignment.centerLeft,
                child: Text('Your Products', textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, height: 1.75, fontSize: 16, color: Colors.white), softWrap: true),
              ),
              new Container(
                color: Colors.white, // Yellow
                alignment: Alignment.centerLeft,
                child: JsonTable(
                  jsonProductsDecode,
                  columns: columnsProducts,
                  showColumnToggle: false,
                  allowRowHighlight: true,
                  rowHighlightColor: Colors.yellow[500].withOpacity(0.7),
                  //paginationRowCount: 10,
                  onRowSelect: (index, map) {
                    final String invoiceUrl = map['invoice'];
                    launch(invoiceUrl);
                  },
                  tableCellBuilder: (value) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                      decoration: BoxDecoration(border:Border.all(width: 0.5, color: Colors.grey.withOpacity(0.5))),
                      child: Text(value),
                    );
                  },
                ),
              ),
            ],
          )
          : Center(
            //child: Text(getPrettyJSONString(jsonSample)),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/taskScreen', arguments: '${args}');
        },
        splashColor: Colors.red,
        child: Icon(Icons.add_circle, size: 30, color: Color(0xFF151026) ),
        backgroundColor: Colors.white,
      ),
    );
  }

  void logoutUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loggedInMobile', '');
    Navigator.pushNamed(context, '/loginScreen');
  }

  //Invoice valueBuilder
  static String generateProductInvoice(value) {
     //return htmlEscape.convert(value);
   return 'Click';
  }
  //Invoice valueBuilder
  static String generateTaskDetail(value) {
    //return htmlEscape.convert(value);
    return 'Click';
  }

  //Basic alert dialogue for alert errors and confirmations
  void showAlertDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
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

   @override
   void initState() {
     super.initState();
     _getProducts();
     _getTasks();
   }

  _getTasks() async {
     //var dataUrl = 'https://cc.ashokatree.net/index.php?id=23&auth=nirmalya14312345&username=7585872225&data=dashboardTasks';
     var dataUrl = Uri.https('https://cc.ashokatree.net', '/index.php?id=23&auth=nirmalya14312345&username=7585872225&data=dashboardTasks', {'q': '{http}'});
     http.Response response = await http.get(dataUrl);
     String data = response.body;
     setState(() {
       _jsonTasks = data;
     });
   }
   _getProducts() async {
     //var dataUrl = 'https://cc.ashokatree.net/index.php?id=23&auth=nirmalya14312345&username=7585872225&data=dashboardProducts';
     var dataUrl = Uri.https('https://cc.ashokatree.net', '/index.php?id=23&auth=nirmalya14312345&username=7585872225&data=dashboardProducts', {'q': '{http}'});

     http.Response response = await http.get(dataUrl);
     String data = response.body;
     setState(() {
       _jsonProducts = data;
     });
   }

}
