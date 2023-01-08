import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';

class SlidingMapPage extends StatelessWidget {
  static const String route = '/sliding_map';

  const SlidingMapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sliding Map')),
      drawer: buildDrawer(context, route),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                  'This is a map that can be panned smoothly when the boundaries are reached.'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(56.704173, 11.543808),
                  minZoom: 12,
                  maxZoom: 14,
                  zoom: 13,
                  swPanBoundary: LatLng(56.6877, 11.5089),
                  nePanBoundary: LatLng(56.7378, 11.6644),
                  slideOnBoundaries: true,
                  screenSize: MediaQuery.of(context).size,
                ),
                children: [
                  TileLayer(
                    tileProvider: AssetTileProvider(),
                    maxZoom: 14,
                    urlTemplate: 'assets/map/anholt_osmbright/{z}/{x}/{y}.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
