import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/Param.dart';
import 'package:flutter_map_example/pages/users/addUser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map_example/widgets/drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../CRudCategory.dart';


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
class Users extends StatefulWidget {
  static const String route = 'Users';
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {

  late List<dynamic> users;
  @override
  void initState() {
    getUsers();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users'),),
      drawer: buildDrawer(context, Users.route),
      body: Column(
    children:<Widget> [
      if(!_isLoading)...[
        spinkit2
    ]else...[
        ElevatedButton(
          child: Text('Add User'),
          onPressed: (){
            Navigator.push(
              context,MaterialPageRoute(builder: (context)=> AddUser())
          );
          },
        ),
        DataTable(
          onSelectAll: (b) {},
          sortColumnIndex: 0,
          sortAscending: true,
          columns: <DataColumn>[
            DataColumn(label: Text("UserName"),tooltip: "Username"),
            DataColumn(label: Text("Email"),tooltip: "Email"),
            DataColumn(label: Text("Role"),tooltip: "Role"),
            DataColumn(label: Text("Update"),tooltip: "Update user"),
            DataColumn(label: Text("Delete"),tooltip: "Delete user"),
          ],
          rows: this.users
              .map(
                  (user) => DataRow(
                      cells: [
                        DataCell(
                            Text(user['username'].toString()),
                        ),
                        DataCell(
                            Text(user['email'].toString()),
                        ),
                        DataCell(
                            Text(user['role']['name'].toString()),
                        ),
                        DataCell(
                          IconButton(
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => ));
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
                                        title: 'Delete Alert', content: "Are you sure you want to delete this user",cate:int.parse(user['id'].toString()),context: context);
                                  });

                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ]),
                      ).toList(),

          ),
    ]
    ,
    ]
      ));
  }

  void getUsers(){
    _isLoading = false;
    print('get users');
    http.get(Uri.parse(Param.urlUsers))
        .then((response) => {
          setState( (){
            var usersJson = json.decode(response.body);
            users= usersJson as List;
            _isLoading = true;
            print('get users loaded!');
          })
    }).catchError((Error){
      _isLoading = false;
      print(Error);
    });
  }

}



