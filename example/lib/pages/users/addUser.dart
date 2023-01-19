import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/pages/Param.dart';
import 'package:flutter_map_example/pages/users/Users.dart';
import 'package:flutter_map_example/pages/users/model/Role.dart';
import 'package:flutter_map_example/pages/users/model/User.dart';
import 'package:flutter_map_example/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map_example/pages/CRudCategory.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class AddUser extends StatefulWidget {
  static const String route ="addUser";
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  dynamic role;
  final minimumPadding = 5.0;
  TextEditingController usernameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  List<dynamic> roles=[];
  List<String> roles1=[];
  String dropdownValue="";
  @override
  void initState() {
    getRoles();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.subtitle2;
    return Scaffold(
        appBar: AppBar(title: const Text('Add User')),
        drawer: buildDrawer(context, AddUser.route),
        body:
      Column(
          children: <Widget>[
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.work),
            elevation: 20,
            style: const TextStyle(color: Colors.blueAccent),
            underline:
            Container(height: 2,
                      color: Colors.deepPurpleAccent,
            ),
            items: roles1.map<DropdownMenuItem<String>>((String valuer){
              return DropdownMenuItem<String>(
                value: valuer,
                child: Text(valuer),
              );
            }).toList(),
            onChanged: (String? value) {
              setState((){
                dropdownValue = value!;
              });
              // This is called when the user selects an item.

            },
          ),
            Padding(padding: EdgeInsets.only(
              top: minimumPadding,
              bottom: minimumPadding
            ),
            child: TextFormField(
              style: textStyle,
              controller: usernameC,
              decoration: InputDecoration(
                labelText: "Username ",
                labelStyle: textStyle,
                hintText: "enter the username",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )
              ),
            ),
            ),
            Padding(padding: EdgeInsets.only(
                top: minimumPadding,
                bottom: minimumPadding
            ),
              child: TextFormField(
                style: textStyle,
                controller: emailC,
                decoration: InputDecoration(
                    labelText: "Email ",
                    labelStyle: textStyle,
                    hintText: "enter the user email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(
                top: minimumPadding,
                bottom: minimumPadding
            ),
              child: TextFormField(
                style: textStyle,
                controller: passwordC,
                decoration: InputDecoration(
                    labelText: "Password ",
                    labelStyle: textStyle,
                    hintText: "enter the user password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )
                ),
              ),
            ),
            ElevatedButton(
                child: Text('ADD'),
                onPressed: ()  {
                  AddUserButtonEvent();

                })
        ]
      ),
    );
  }
  void getRoles(){

    http.get(Uri.parse(Param.urlGetRoles)).then((value){
      setState(() {
        var rolesJson = json.decode(value.body);
        roles=rolesJson as List;
        print(roles);
        for(int i=0;i<roles.length;i++){
          roles1.add(roles[i]['name'].toString());
          dropdownValue=roles1.first;
        }
      });
    });
  }
  void AddUserButtonEvent(){
        int idrole=User.getIsRole(dropdownValue);
        print("Adding user log:*****************************\n");
        print("Role: name"+dropdownValue+" id: "+idrole.toString());
        print("Username: "+usernameC.text);
        print("Email: "+emailC.text);
        print("Password: "+passwordC.text);
        print("\nAdding user Fin log*************************\n");
        Role role1= new Role(id: idrole,name: dropdownValue);
        User user= new User(  email: emailC.text,
                              password: passwordC.text,
                              username:usernameC.text,
                              role:role1);

        http.post(Uri.parse(Param.urlADDUser),
          headers:  <String, String>{"Content-Type": "application/json"},
          body: jsonEncode(user.toJson())
        ).then((response) =>
        {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext dialogContext) {
                if(response.statusCode==201);
                return MyAlertDialogSHOWUsers(
                    title: 'Response', content: "user created !");
              })
        }).catchError((error){
          print(error);
        });
  }
}

class MyAlertDialogSHOWUsers extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  //final String idUser;

  MyAlertDialogSHOWUsers({
    required this.title,
    required this.content,
    this.actions = const [],

    //required this.idUser
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
                      builder: (context) => Users()));
            })

      ],
      content: Text(
        this.content,
        style: Theme.of(context).textTheme.bodyLarge,
      ),

    );
  }
}

