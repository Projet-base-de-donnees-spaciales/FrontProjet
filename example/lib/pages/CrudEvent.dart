
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/tap_to_add.dart';
import 'package:flutter_map_example/pages/updateEvent.dart';
import 'package:flutter_map_example/pages/users/Users.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import '../widgets/drawer.dart';
import 'CRudCategory.dart';
import 'LoginScreen.dart';
import 'Param.dart';
import 'package:flutter_map_example/pages/CRudCategory.dart';

bool _isLoading = false;
const spinkit = SpinKitRotatingCircle(
  color: Colors.white,
  size: 50.0,
);
final spinkit2 = SpinKitFadingCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.grey : Colors.blue,
      ),
    );
  },
);
class CrudEvent extends StatefulWidget {

  static const String route = 'CrudEvent';


  const CrudEvent({super.key});

  @override
  State<CrudEvent> createState() => _CrudEventState();
}

class _CrudEventState extends State<CrudEvent> {
  late List<dynamic> eventes;

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
            //       padding: EdgeInsets.only(right: 20.0,top: 11),
            //       child: GestureDetector(
            //         onTap: () { Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => CrudCategory()));},
            //         child: const Text("Catégorie",style: TextStyle(
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
            //               //Page
            //                 builder: (context) => Users()));},
            //
            //         child: const Text("Users",style: TextStyle(
            //           fontSize: 16.0,
            //           color: Colors.white,
            //           decorationColor: Colors.redAccent,
            //           fontStyle: FontStyle.italic,
            //           fontWeight: FontWeight.bold,
            //           )),
            //
            //       )
            //   )
            //   ,
            Padding(
                  padding: const EdgeInsets.only(right: 40.0,top: 11),
                  child: GestureDetector(
                    onTap: () { Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen()));},
                    child: const Icon(
                      Icons.logout_rounded,
                      size: 26.0,
                    ),
                  )
              )]
        ),
        drawer: buildDrawer(context, CrudEvent.route),
        body:SingleChildScrollView(
    child:
        Center(
          child:
          Column(
              children:<Widget> [
              if(!_isLoading)...[
        spinkit2
        ]else...[

              const ListTile(
                title:  Center(child:  Text("Gestion des événements \n",
                  style:  TextStyle(
                      fontSize: 25 , color: Colors.black),
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
                    label: const Text('Ajouter événémént'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TapToAddPage(this.eventes.first['evenementDTO']['userDTO']['id'])));
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
    SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child:
    SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child:
              DataTable(
                onSelectAll: (b) {},
                sortColumnIndex: 0,
                sortAscending: true,
                headingRowColor:
                MaterialStateColor.resolveWith((states) => Colors.blue),
                columns: <DataColumn>[
                  DataColumn(label: Text("Name"), tooltip: "Nom"),
                  DataColumn(label: Text("Description"),
                      tooltip: "description"),
                  DataColumn(label: Text("Date de creation"),
                      tooltip: "Date de creation"),
                  DataColumn(label: Text("Date de Expiration"),
                      tooltip: "Date de Expiration"),
                  DataColumn(label: Text("Categorie"),
                      tooltip: "Categorie"),
                  DataColumn(label: Text("Position"),
                      tooltip: "Position"),
                  DataColumn(label: Text("Modifier"), tooltip: "Modifier"),
                  DataColumn(label: Text("Supprimer"), tooltip: "Supprimer"),
                ],
                rows: this.eventes // accessing list from Getx controller
                    .map(
                      (user) =>
                      DataRow(
                        cells: [
                          DataCell(
                            Text(user['evenementDTO']['name'].toString()),
                          ),
                          DataCell(
                            Text(
                                user['evenementDTO']['description'].toString()),
                          ),
                          DataCell(
                            Text(user['evenementDTO']['date_creation']
                                .toString()),
                          ),
                          DataCell(
                            Text(user['evenementDTO']['date_expiration']
                                .toString()),
                          ),
                          DataCell(
                            Text(user['evenementDTO']['categoryDTO']['name']
                                .toString()),
                          ),
                          DataCell(
                            Text(user['point'].toString()),
                          ),
                          DataCell(
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            updateEvent(user)));
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
                                      return MyAlertDialogg(
                                          title: "Suppresion d'événement",
                                          content: "Vous voulez vraiment supprimer cet événement",
                                          cate: int.parse(
                                              user['evenementDTO']['id'].toString()),
                                          context: context);
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
    ))]]
        ))));
  }
  void getCate() {
   _isLoading = false;
    http.get(Uri.parse(Param.UrlAllEvent))
        .then((resp) {
      setState(() {
        var jsonData = json.decode(resp.body);
        eventes = jsonData['positionDTOSList'] as List;
        print(eventes);
        _isLoading = true;
      });
    }).catchError((error) {
      print(error);
    });
  }
}
    class MyAlertDialogg extends StatelessWidget {
    final String title;
    final String content;
    final int cate;
    final BuildContext context;
    final List<Widget> actions;


    MyAlertDialogg({
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
      print(cate);
      deleteEvent(cate);

    })

    ],
    content: Text(
    this.content,
    style: Theme.of(context).textTheme.bodyLarge,
    ),

    );
    }
    void deleteEvent(user) {
    http.delete(Uri.parse(Param.UrlDeleteEvent+user.toString()))
        .then((resp) {
    showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
    var jsonData = json.decode(resp.body);
    var message = jsonData['message'];
    return MyAlertDialogSHOWWW(
    title: 'Delete Alert',
    content: message.toString());
    });
    }).catchError((error) {
    showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
    return MyAlertDialogSHOWWW(
    title: 'Delete Alert',
    content: "Failed to delete this Event  ");
    });
    print(error);
    });
    }
    }



class MyAlertDialogSHOWWW extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  MyAlertDialogSHOWWW({
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
                      builder: (context) => CrudEvent()));
            })

      ],
      content: Text(
        this.content,
        style: Theme.of(context).textTheme.bodyLarge,
      ),

    );
  }
}
