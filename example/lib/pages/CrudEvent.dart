
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/tap_to_add.dart';
import 'package:http/http.dart' as http;
import '../widgets/drawer.dart';
import 'CRudCategory.dart';

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
        appBar: AppBar(title: const Text('Fetch Events')),
        drawer: buildDrawer(context, CrudEvent.route),
        body:
        Column(
            children: <Widget>[
              ElevatedButton(
                  child: Text('ADD New Event'),
                  onPressed: ()  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TapToAddPage()));
                  }),


              DataTable(
                onSelectAll: (b) {},
                sortColumnIndex: 0,
                sortAscending: true,
                columns: <DataColumn>[
                  DataColumn(label: Text("Name"), tooltip: "To Display name"),
                  DataColumn(label: Text("Description"), tooltip: "To Display description"),
                  DataColumn(label: Text("Date de creation"), tooltip: "To Display description"),
                  DataColumn(label: Text("Date de Expiration"), tooltip: "To Display description"),
                  DataColumn(label: Text("Category"), tooltip: "To Display description"),
                  DataColumn(label: Text("Position"), tooltip: "To Display description"),
                  DataColumn(label: Text("Update"), tooltip: "Update data"),
                  DataColumn(label: Text("Delete"), tooltip: "Delete data"),
                ],
                rows: this.eventes // accessing list from Getx controller
                    .map(
                      (user) => DataRow(
                    cells: [
                      DataCell(
                        Text(user['evenementDTO']['name'].toString()),
                      ),
                      DataCell(
                        Text(user['evenementDTO']['description'].toString()),
                      ),
    DataCell(
    Text(user['evenementDTO']['date_creation'].toString()),
    ),
                      DataCell(
                        Text(user['evenementDTO']['date_expiration'].toString()),
                      ),
                      DataCell(
                        Text(user['evenementDTO']['categoryDTO']['name'].toString()),
                      ),
                      DataCell(
                        Text(user['point'].toString()),
                      ),
                      DataCell(
                        IconButton(
                          onPressed: () {
                           /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    //builder: (context) => updateCategory(user)));*/
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
        ));


  }
  void getCate()  {
    String url="http://192.168.2.103:8080/Evenement/getAll";
    http.get(Uri.parse(url))
        .then((resp){

      setState((){
        var jsonData = json.decode(resp.body);
        eventes = jsonData['positionDTOSList'] as List;
        print(eventes);


      });
    }).catchError((error){
      print(error);
    });

  }




}