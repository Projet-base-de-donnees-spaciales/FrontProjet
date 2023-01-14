import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/ADDCategory.dart';
import 'package:flutter_map_example/pages/updateCategory.dart';
import 'package:http/http.dart' as http;

class Param {
 static String UrlAddCat = "http://192.168.43.215:8080/Category/Add";
 static String UrlAllCat = "http://192.168.43.215:8080/Category/getAll";
 static String UrlDeleteCat = "http://192.168.43.215:8080/Category/Delete/";
 static String UrlUpdateCat ="http://192.168.43.215:8080/Category/Update";
 static String UrlAllEvent = "http://192.168.43.215:8080/Evenement/getAll";
 static String UrlAddEvent= "http://192.168.43.215:8080/Evenement/Add";
 static String UrlDeleteEvent="http://192.168.43.215:8080/Evenement/Delete/";
 static String UrlUpdateEvent= "";
}