import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/CRudCategory.dart';
import 'package:http/http.dart' as http;

import 'Param.dart';

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
        title: const Center( child: Text('Modier catégorie')),
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
                                labelText: 'Nom',
                                hintText: 'Saisir le nom',
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
                                hintText: 'Saisir decription',
                                labelStyle: textStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          )),
                      ElevatedButton(
                          child: Text('Modifier catégorie'),
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

    http.put(Uri.parse(Param.UrlUpdateCat),headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(employee))
        .then((resp){
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            var jsonData = json.decode(resp.body);
            var message = jsonData['message'];
            return MyAlertDialogSHOW(
                title: 'Backend Response', content: message.toString());
          });




    }).catchError((error){
      print(error);
    });


  }

}



