import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/CRudCategory.dart';
import 'package:flutter_map_example/pages/live_location.dart';
import 'package:flutter_map_example/pages/users/model/User.dart';
import 'package:flutter_map_example/pages/widgets/email_field.dart';
import 'package:flutter_map_example/pages/widgets/get_started_button.dart';
import 'package:flutter_map_example/pages/widgets/password_field.dart';
import 'package:http/http.dart' as http;

import '../widgets/drawer.dart';
import 'CreateurEvent.dart';
import 'Param.dart';

class LoginScreen extends StatefulWidget {
  static const String route = 'LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  double _elementsOpacity = 1;
  bool loadingBallAppear = false;
  double loadingBallSize = 1;
  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentifation')),
      body:
      // SingleChildScrollView(
      //   scrollDirection: Axis.horizontal,
      //     child:
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child:
                  Column(
          children: <Widget>[

                          Icon(Icons.flutter_dash,
                              size: 60, color: Color(0xff21579C)),
                          SizedBox(height: 25),
                          Text(
                            "Welcome,",
                            style: TextStyle(
                                color: Colors.black, fontSize: 35),
                          ),
                          Text(
                            "Sign in to continue",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 35),
                          ),

                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        EmailField(
                            fadeEmail: _elementsOpacity == 0,
                            emailController: emailController),
                        SizedBox(height: 40),
                        PasswordField(
                            fadePassword: _elementsOpacity == 0,
                            passwordController: passwordController),
                        SizedBox(height: 60),
                        ElevatedButton(
                          onPressed: () { goRedirection(emailController,passwordController); }

                          , child: Text('Se Connecter'),
                        )
                      ],
                    ),
                  ),
                ],
              )),
    );
  }
 void goRedirection(   TextEditingController emailController, TextEditingController passwordController){
    User user=User(email: emailController.text,password:passwordController.text);
    http.post(Uri.parse(Param.UrlLogin),headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(user))
        .then((resp){
            var jsonData = json.decode(resp.body);
            var role = jsonData['user']['role']['id'];

            if(role.toString()=="1"){
              print("I am admin");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  CrudCategory()));

            }
            else if(role.toString()=="3"){
              print("I am createur");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateurEvent(jsonData['user']['id'])))
                  ;
            }
            else{
              print("I am a user");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LiveLocationPage()))
              ;
            }


    }).catchError((error){
      print(error);
    });



  }
}

