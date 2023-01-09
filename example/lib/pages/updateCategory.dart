import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/CRudCategory.dart';
import 'package:http/http.dart' as http;

class updateCategory extends StatefulWidget {
  dynamic category;
  static const String route = 'updateCategory';
  @override
  State<StatefulWidget> createState() {
    return _UpdateCategoryState(category);
  }

  updateCategory(this.category);
}

class _UpdateCategoryState extends State<updateCategory> {

  dynamic category;
  final minimumPadding = 5.0;
  late TextEditingController employeeNumber;
  bool _isEnabled = false;
  late TextEditingController firstController;
  late TextEditingController lastController;
  List<dynamic> employees=[];

  _UpdateCategoryState(this.category) {
    employeeNumber = TextEditingController(text: this.category['id'].toString());
    firstController = TextEditingController(text: this.category['name'].toString());
    lastController = TextEditingController(text: this.category['description'].toString());
  }
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.subtitle2;
    return MaterialApp(
        title: 'Update Category',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
        appBar: AppBar(
        title: const Text('Update Category'),
           ),
            body:
            Container(
                child: Padding(
                    padding: EdgeInsets.all(minimumPadding * 2),
                    child: ListView(children: <Widget>[

                      Padding(
                          padding: EdgeInsets.only(
                              top: minimumPadding, bottom: minimumPadding),
                          child: TextFormField(
                            style: textStyle,
                            controller: firstController,

                            decoration: InputDecoration(
                                labelText: 'First Name',
                                hintText: 'Enter Your First Name',
                                labelStyle: textStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              top: minimumPadding, bottom: minimumPadding),
                          child: TextFormField(
                            style: textStyle,
                            controller: lastController,
                            /*validator: (String value) {
                              if (value.isEmpty) {
                                return 'please enter your name';
                              }
                            },*/
                            decoration: InputDecoration(
                                labelText: 'Last Name',
                                hintText: 'Enter Your First Name',
                                labelStyle: textStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          )),
                      ElevatedButton(
                          child: Text('Update Details'),
                          onPressed: ()  {

                            Category emp = new Category(id: int.parse(category['id'].toString()), name: firstController.text, description:lastController.text);
                             updateEmployees(emp, context);
                            setState(() {
                              category = employees;
                            });
                          })
                    ]))))

        );


    }



  void updateEmployees(
      Category employee, BuildContext context)  {

    var Url = "http://172.17.36.37:8080/Category/Update";
    http.put(Uri.parse(Url),headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(employee))
        .then((resp){
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            var jsonData = json.decode(resp.body);
            var message = jsonData['message'];
            return MyAlertDialog(
                title: 'Backend Response', content: message.toString());
          });




    }).catchError((error){
      print(error);
    });


  }

}

class MyAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  MyAlertDialog({
    required this.title,
    required this.content,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        this.title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: <Widget>[
        ElevatedButton(
            child: Text('OK'),
            onPressed: ()  {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CrudCategory()));
            })

        ],
      content: Text(
        "Update successfully",
        style: Theme.of(context).textTheme.bodyLarge,
      ),

    );
  }
}

