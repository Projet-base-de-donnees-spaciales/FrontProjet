/*
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatelessWidget {
  static const String route = '/';

  const HomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final markers = <Marker>[];
    markers.add( Marker(
      width: 80,
      height: 80,
      point: LatLng(31.7917, -7.0926),
      builder: (context) => const Icon(
        Icons.location_on,
        color: Colors.red,
        size: 40,
      ),
    ));
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: buildDrawer(context, route),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Selection of localisation'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(31.7917, -7.0926),
                  zoom: 5,
                ),
                nonRotatedChildren: [
                  AttributionWidget.defaultWidget(
                    source: 'OpenStreetMap contributors',
                    onSourceTapped: () {},
                  ),
                ],
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/pages/LoginScreen.dart';
import 'package:flutter_map_example/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HomePage extends StatelessWidget {
  static const String route = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        drawer: buildDrawer(context, HomePage.route),
        body: const MyCardWidget(),
      ),
    );
  }
}
class MyCardWidget extends StatelessWidget {
  const MyCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          width: 800,
          height: 400,
          padding: const EdgeInsets.all(10.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.blue,
            elevation: 10,
            child: Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLdysCwKn4e2Ito24Sh-lrUo7kz54PqH16nA&usqp=CAU'),
                ),
                const ListTile(
                      title:  Center(child:  Text("Events.com",
                      style:  TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 25.0 , color: Colors.white),
                      )),
                      subtitle:  Center(child:  Text("L'application de gestion des événements en ligne \n\n\n"))
                  ),
                 SizedBox(
                      width: 150, // <-- Your width
                      height: 50, // <-- Your height
                          child:  ElevatedButton.icon(
                            icon: const Icon(
                              Icons.login_rounded,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            label: const Text('Se conncter'),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              //onPrimary: Colors.black,
                            ),
                          )

                 ),


              ],
            )),
          ),
        ));
  }
}
