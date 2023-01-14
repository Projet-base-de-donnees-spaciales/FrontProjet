import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/tap_to_add.dart';
import 'package:flutter_map_example/pages/updateEvent.dart';
import 'package:http/http.dart' as http;
import '../widgets/CreateurDrawer.dart';
import '../widgets/drawer.dart';
import 'CrudEvent.dart';
import 'LoginScreen.dart';
import 'Param.dart';
import 'TapToAddPageCreateur.dart';
import 'UpdateCreateur.dart';

class CreateurEvent extends StatefulWidget {
  dynamic idUser;
  static const String route = 'CreateurEvent';
  @override
  State<StatefulWidget> createState() {
    return _CreateurState(idUser);
  }

  CreateurEvent(this.idUser);
}

class _CreateurState extends State<CreateurEvent> {
  late List<dynamic> eventes;
  dynamic idUser;
 late String idUserr;
  _CreateurState(this.idUser) {
   idUserr=idUser.toString();


  }
  @override
  void initState() {
    getCate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Fetch Events'),
            leading: GestureDetector(
              onTap: () { /* Write listener code here */ },
              child: Icon(
                Icons.menu,  // add custom icons also
              ),
            ),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () { Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen()));},
                    child: Icon(
                      Icons.logout,
                      size: 26.0,
                    ),
                  )
              )]
        ),

        body:
        Column(
            children: <Widget>[
              ElevatedButton(
                  child: Text('ADD New Event'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TapToAddPageCreateur(idUserr)));
                  }),


              DataTable(
                onSelectAll: (b) {},
                sortColumnIndex: 0,
                sortAscending: true,
                columns: <DataColumn>[
                  DataColumn(label: Text("Name"), tooltip: "To Display name"),
                  DataColumn(label: Text("Description"),
                      tooltip: "To Display description"),
                  DataColumn(label: Text("Date de creation"),
                      tooltip: "To Display description"),
                  DataColumn(label: Text("Date de Expiration"),
                      tooltip: "To Display description"),
                  DataColumn(label: Text("Category"),
                      tooltip: "To Display description"),
                  DataColumn(label: Text("Position"),
                      tooltip: "To Display description"),
                  DataColumn(label: Text("Update"), tooltip: "Update data"),
                  DataColumn(label: Text("Delete"), tooltip: "Delete data"),
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
                                            updateCreateur(user)));
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
                                      return MyAlertDialogg(
                                          title: 'Delete Alert',
                                          content: "Are you sure you want to delete this event",
                                          idUser: idUserr,
                                          cate: int.parse(
                                              user['evenementDTO']['id'].toString()),
                                          context: context);
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
        ));
  }
  void getCate() {

    http.get(Uri.parse(Param.UrlAllEventUser+idUserr.toString()))
        .then((resp) {
      setState(() {
        var jsonData = json.decode(resp.body);
        eventes = jsonData['positionDTOSList'] as List;
        print(eventes);
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
  final String idUser;


  MyAlertDialogg({
    required this.title,
    required this.content,
    required this.cate,
    required this.context,
    this.actions = const [],
    required this.idUser
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
                content: message.toString(), idUser: idUser,
            );
          });
    }).catchError((error) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return MyAlertDialogSHOWWW(
                title: 'Delete Alert',
                content: "Failed to delete this Event  ",
            idUser: idUser,
            );
          });
      print(error);
    });
  }
}



class MyAlertDialogSHOWWW extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;
  final String idUser;

  MyAlertDialogSHOWWW({
    required this.title,
    required this.content,
    this.actions = const [],
    required this.idUser
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
                      builder: (context) => CreateurEvent(idUser)));
            })

      ],
      content: Text(
        this.content,
        style: Theme.of(context).textTheme.bodyLarge,
      ),

    );
  }
}
