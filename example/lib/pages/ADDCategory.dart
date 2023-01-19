import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/CRudCategory.dart';
import 'package:http/http.dart' as http;

import 'Param.dart';

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
              title: const Center( child: Text('Ajouter catégorie')),
            ),
            body:SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child:
    SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child:
            Center(
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
                            labelText: ' Nom',
                            hintText: 'Saisir le nom du catégorie',
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
                            hintText: 'Saisir la description du catégorie',
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  ElevatedButton(
                      child: Text('Ajouter'),
                      onPressed: ()  {

                        Category emp = new Category( name: firstController.text, description:lastController.text);
                        ADDCate(emp, context);
                        setState(() {
                          category = employees;
                        });
                      })
                ])))))

        )

    );


  }



  void ADDCate(
      Category employee, BuildContext context)  {



    http.post(Uri.parse(Param.UrlAddCat),headers: <String, String>{"Content-Type": "application/json"},
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

