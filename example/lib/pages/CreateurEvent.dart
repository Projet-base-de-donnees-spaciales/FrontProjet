import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/tap_to_add.dart';
import 'package:flutter_map_example/pages/updateEvent.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import '../widgets/drawer.dart';
import 'CrudEvent.dart';
import 'LoginScreen.dart';
import 'Param.dart';
import 'TapToAddPageCreateur.dart';
import 'UpdateCreateur.dart';

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
       appBar: AppBar(title: const Center(child: Text('Events.com')),

            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 40.0,top: 11),
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
        SingleChildScrollView(
        child:
        Center(
          child: Column(
              children:<Widget> [
              if(!_isLoading)...[
        spinkit2
        ]else...[
                  const ListTile(
                    title:  Center(child:  Text("Gestion des ??v??nements \n",
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
                        label: const Text('Ajouter ??v??n??m??nt'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TapToAddPageCreateur(idUserr)));
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
                                                updateCreateur(user)));
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
                                              title: "Suppresion d'??v??nement",
                                              content: "Vous voulez vraiment supprimer cet ??v??nement",
                                              cate: int.parse(
                                                  user['evenementDTO']['id'].toString()),
                                              context: context, idUser: idUserr,);
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
    _isLoading=false;
    http.get(Uri.parse(Param.UrlAllEventUser+idUserr.toString()))
        .then((resp) {
      setState(() {
        var jsonData = json.decode(resp.body);
        eventes = jsonData['positionDTOSList'] as List;
        print(eventes);
        _isLoading=true;
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
