import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/CRudCategory.dart';
import 'package:http/http.dart' as http;

class ADDCategory extends StatefulWidget {

  static const String route = 'ADDCategory';
  @override
  State<StatefulWidget> createState() {
    return _ADDCategoryState();
  }


}

class _ADDCategoryState extends State<ADDCategory> {

  dynamic category;
  final minimumPadding = 5.0;

  TextEditingController firstController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  List<dynamic> employees=[];


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.subtitle2;
    return MaterialApp(
        title: 'ADD Category',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('ADD Category'),
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
                                labelText: ' Name',
                                hintText: 'Enter Name of category',
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
                                labelText: 'Description',
                                hintText: 'Enter Description of category',
                                labelStyle: textStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          )),
                      ElevatedButton(
                          child: Text('ADD'),
                          onPressed: ()  {

                            Category emp = new Category( name: firstController.text, description:lastController.text);
                            ADDCate(emp, context);
                            setState(() {
                              category = employees;
                            });
                          })
                    ])))

        )

    );


  }



  void ADDCate(
      Category employee, BuildContext context)  {

    var Url = "http://172.17.36.37:8080/Category/Add";
    http.post(Uri.parse(Url),headers: <String, String>{"Content-Type": "application/json"},
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
        this.content,
        style: Theme.of(context).textTheme.bodyLarge,
      ),

    );
  }
}

