import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/ADDCategory.dart';
import 'package:flutter_map_example/pages/updateCategory.dart';
import 'package:http/http.dart' as http;

class Param {
 static String baseurl="http://192.168.16.178:8080";
 static String socketUrl=baseurl+"/sgbds-endpoint";
 static String UrlAddCat = baseurl +"/Category/Add";
 static String UrlAllCat = baseurl+"/Category/getAll";
 static String UrlDeleteCat = baseurl+"/Category/Delete/";
 static String UrlUpdateCat =baseurl+"/Category/Update";
 static String UrlAllEvent = baseurl+"/Evenement/getAll";
 static String UrlAddEvent= baseurl+"/Evenement/Add";
 static String UrlDeleteEvent=baseurl+"/Evenement/Delete/";
 static String UrlUpdateEvent= baseurl+"/Evenement/Update";
 static String UrlLogin= baseurl+"/users/login";
 static String UrlAllEventUser=baseurl+"/Evenement/User/getAll/";
 static String urlUsers=baseurl+"/users";
 static String urlADDUser= baseurl+"/users/Add";
 static String urlGetRoles=baseurl+"/roles";

}