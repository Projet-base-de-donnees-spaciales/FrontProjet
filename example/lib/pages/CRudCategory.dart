import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/ADDCategory.dart';
import 'package:flutter_map_example/pages/CrudEvent.dart';
import 'package:flutter_map_example/pages/updateCategory.dart';
import 'package:flutter_map_example/pages/users/Users.dart';
import 'package:http/http.dart' as http;

import '../widgets/drawer.dart';
import 'LoginScreen.dart';
import 'Param.dart';




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
    return Scaffold(

        appBar: AppBar(title: const Center(child: Text('Events.com')),
             actions: <Widget>[
            //   Padding(
            //       padding: EdgeInsets.only(right: 45.0,top: 10),
            //       child: GestureDetector(
            //         onTap: () { Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => CrudEvent()));},
            //         child: const Text("Evénement",style: TextStyle(
            //           fontSize: 16.0,
            //           color: Colors.white,
            //           decorationColor: Colors.redAccent,
            //           fontStyle: FontStyle.italic,
            //           fontWeight: FontWeight.bold,
            //         )),
            //       )
            //   ),
            //   Padding(
            //       padding: EdgeInsets.only(right: 20.0,top: 11),
            //       child: GestureDetector(
            //         onTap: () { Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => Users()));},
            //
            //         child: const Text("Users",style: TextStyle(
            //           fontSize: 16.0,
            //           color: Colors.white,
            //           decorationColor: Colors.redAccent,
            //           fontStyle: FontStyle.italic,
            //           fontWeight: FontWeight.bold,
            //         )),
            //       )
            //   )
              Padding(
                  padding: EdgeInsets.only(right: 20.0,top: 11),
                  child: GestureDetector(
                    onTap: () { Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen()));},
                    child: const Icon(
                      Icons.logout,
                      size: 26.0,
                    ),
                  )
              )
             ]
        ),
      drawer: buildDrawer(context, CrudCategory.route),
body:
    Center(
    child: Column(
    children: <Widget>[
      const ListTile(
          title:  Center(child:  Text("Gestion des catégories \n",
            style:  TextStyle(
                 fontSize: 45 , color: Colors.black),
          )),
      ),
      SizedBox(
            width: 250, // <-- Your width
            height: 50, // <-- Your height
            child:  ElevatedButton.icon(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30.0,
              ),
              label: const Text('Ajouter nouvelle catégorie'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ADDCategory()));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                //onPrimary: Colors.black,
              ),
            )

        ),
      const ListTile(
        title:  Center(child:  Text("\n")),
        ),
      DataTable(
          onSelectAll: (b) {},
          sortColumnIndex: 0,
          sortAscending: true,
          headingRowColor:
          MaterialStateColor.resolveWith((states) => Colors.blue),
          columns: <DataColumn>[
            DataColumn(label: Text("Name" , style:  TextStyle(color: Colors.white)), tooltip: "Nom"),
            DataColumn(label: Text("Description" , style:  TextStyle(color: Colors.white)), tooltip: "Description"),
            DataColumn(label: Text("Modifier", style:  TextStyle(color: Colors.white)), tooltip: "Modifier"),
            DataColumn(label: Text("Supprimer", style:  TextStyle(color: Colors.white)), tooltip: "Supprimer"),
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
                      color: Colors.blue,
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
                                title: 'Suppression du catégorie', content: "Vous voulez vraiment supprimer cette catégorie ?",cate:int.parse(user['id'].toString()),context: context);
                          });

                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
          )
              .toList(),
        )
]
))
    );

    }
  void getCate()  {


    http.get(Uri.parse(Param.UrlAllCat))
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
    http.delete(Uri.parse(Param.UrlDeleteCat+ user.toString()))
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
                title: 'Suppression du catégorie',
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
