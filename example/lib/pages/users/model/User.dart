
import 'Role.dart';


class User {

  int? id;
  String? username;
  String? email;
  String? password;
  Role? role;

  //il faut user


  User({this.id,this.username, this.email, this.password,this.role});
  static int getIsRole(String name){
    switch(name){
      case "ADMIN":{
        return 1;
      }
      case "FINAL_USER":{
        return 2;
      }
      case "PROVIDER_USER":{
        return 3;
      }
      default:{
        return 0;
      }
    }
  }
  Map<String, dynamic> toJson() => {
    "id":id,
    "username": username,
    "email": email,
    'password': password,
    'role':role
  };
  factory User.fromJson( dynamic json) => User(id:int.parse(json['id'].toString()),
      username: json['username'].toString(),email: json["email"].toString(), password: json["password"].toString(),
      role:json['role'] as Role);
}