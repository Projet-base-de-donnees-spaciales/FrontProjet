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

  Future<http.Response> fetchFruit()  {
    return http.get(Uri.parse("http://192.168.43.215:8080/Evenement/getAll"));

  }


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
}