import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/ADDCategory.dart';
import 'package:flutter_map_example/pages/updateCategory.dart';
import 'package:http/http.dart' as http;




class Category {

  int? id;
  String? name;
  String? description;

  Category({this.id, this.name, this.description});

  Map<String, dynamic> toJson() => {
    "description": description,
    "name": name,
    'id': id,
  };
  factory Category.fromJson( dynamic json) => Category(
      id: int.parse(json['id'].toString()),name: json["name"].toString(), description: json["description"].toString());
}



class CrudCategory extends StatefulWidget {
  static const String route = 'CrudCategory';
  const CrudCategory({super.key});

  @override
  State<CrudCategory> createState() => _CrudCategoryState();
}

class _CrudCategoryState extends State<CrudCategory> {
    late List<dynamic> categories;

  @override
  void initState() {
    getCate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fetch Category',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
        appBar: AppBar(
        title: const Text('Fetch Category'),
    ),
body:
Column(
    children: <Widget>[
ElevatedButton(
    child: Text('ADD New Category'),
    onPressed: ()  {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ADDCategory()));
    }),


    DataTable(
  onSelectAll: (b) {},
  sortColumnIndex: 0,
  sortAscending: true,
  columns: <DataColumn>[
    DataColumn(label: Text("Name"), tooltip: "To Display name"),
    DataColumn(label: Text("Description"), tooltip: "To Display description"),
    DataColumn(label: Text("Update"), tooltip: "Update data"),
    DataColumn(label: Text("Delete"), tooltip: "Delete data"),
  ],
  rows: this.categories // accessing list from Getx controller
      .map(
        (user) => DataRow(
      cells: [
        DataCell(
          Text(user['name'].toString()),
        ),
        DataCell(
          Text(user['description'].toString()),
        ),
        DataCell(
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => updateCategory(user)));
            },
            icon: Icon(
              Icons.edit,
              color: Colors.black,
            ),
          ),
        ),
       DataCell(
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext dialogContext) {

                    return MyAlertDialog(
                        title: 'Delete Alert', content: "Are you sure you want to delete this category",cate:int.parse(user['id'].toString()),context: context);
                  });

            },
            icon: Icon(
              Icons.delete,
              color: Colors.black,
            ),
          ),
        )
      ],
    ),
  )
      .toList(),
)
]
),
        )  );

    }
  void getCate()  {
    String url="http://192.168.2.103:8080/Category/getAll";
    http.get(Uri.parse(url))
        .then((resp){

      setState((){
        var jsonData = json.decode(resp.body);
        categories = jsonData['categorieList'] as List;
        print(categories);


      });
    }).catchError((error){
      print(error);
    });

  }




}

class MyAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final int cate;
  final BuildContext context;
  final List<Widget> actions;


  MyAlertDialog({
    required this.title,
    required this.content,
    required this.cate,
    required this.context,
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
             delete(cate);
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
  void delete(user) {
    String url = "http://192.168.2.103:8080/Category/Delete/" +
        user.toString();
    http.delete(Uri.parse(url))
        .then((resp) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            var jsonData = json.decode(resp.body);
            var message = jsonData['message'];
            return MyAlertDialogSHOW(
                title: 'Delete Alert',
                content: message.toString());
          });
    }).catchError((error) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return MyAlertDialogSHOW(
                title: 'Delete Alert',
                content: "Failed to delete this category  ");
          });
      print(error);
    });
  }
}


class MyAlertDialogSHOW extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  MyAlertDialogSHOW({
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
