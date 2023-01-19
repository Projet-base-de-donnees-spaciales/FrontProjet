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
import '../LoginScreen.dart';


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
      appBar: AppBar(title: const Text('Users'),
          actions: <Widget>[
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
      drawer: buildDrawer(context, Users.route),
      body:SingleChildScrollView(
    child:
          Center(
      child: Column(
    children:<Widget> [
      if(!_isLoading)...[
        spinkit2
    ]else...[
        const ListTile(
          title:  Center(child:  Text("Gestion des utilisateurs \n",
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
        label: const Text('Ajouter utilisateur'),
        onPressed: () { Navigator.push(

            context,MaterialPageRoute(
            builder: (context)=> AddUser())); },
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            //onPrimary: Colors.black,
          ),
        ))
        , const ListTile(
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
            DataColumn(label: Text("UserName", style:  TextStyle(color: Colors.white)),tooltip: "Username",),
            DataColumn(label: Text("Email", style:  TextStyle(color: Colors.white)),tooltip: "Email"),
            DataColumn(label: Text("Role", style:  TextStyle(color: Colors.white)),tooltip: "Role"),
            DataColumn(label: Text("Update", style:  TextStyle(color: Colors.white)),tooltip: "Update user"),
            DataColumn(label: Text("Delete", style:  TextStyle(color: Colors.white)),tooltip: "Delete user"),
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
                              color: Colors.lightBlueAccent,
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
                              color: Colors.red,
                            ),
                          ),
                        )
                      ]),
                      ).toList(),

          ),
    ))]
    ,
    ]
      )))
    )
    ;
  }

  void getUsers(){
    _isLoading = false;
    var duration = const Duration(seconds: 5);
    print('Start sleeping');
    //sleep(duration);
    print('5 seconds has passed');
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



