import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';

const maxMarkersCount = 5000;

/// On this page, [maxMarkersCount] markers are randomly generated
/// across europe, and then you can limit them with a slider
///
/// This way, you can test how map performs under a lot of markers
class ManyMarkersPage extends StatefulWidget {
  static const String route = '/many_markers';

  const ManyMarkersPage({Key? key}) : super(key: key);

  @override
  _ManyMarkersPageState createState() => _ManyMarkersPageState();
}

class _ManyMarkersPageState extends State<ManyMarkersPage> {
  double doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;
  List<Marker> allMarkers = [];

  int _sliderVal = maxMarkersCount ~/ 10;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final r = Random();
      for (var x = 0; x < maxMarkersCount; x++) {
        allMarkers.add(
          Marker(
            point: LatLng(
              doubleInRange(r, 37, 55),
              doubleInRange(r, -9, 30),
            ),
            builder: (context) => const Icon(
              Icons.circle,
              color: Colors.red,
              size: 12,
            ),
          ),
        );
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('A lot of markers')),
      drawer: buildDrawer(context, ManyMarkersPage.route),
      body: Column(
        children: [
          Slider(
            min: 0,
            max: maxMarkersCount.toDouble(),
            divisions: maxMarkersCount ~/ 500,
            label: 'Markers',
            value: _sliderVal.toDouble(),
            onChanged: (newVal) {
              _sliderVal = newVal.toInt();
              setState(() {});
            },
          ),
          Text('$_sliderVal markers'),
          Flexible(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(50, 20),
                zoom: 5,
                interactiveFlags: InteractiveFlag.all - InteractiveFlag.rotate,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                MarkerLayer(
                    markers: allMarkers.sublist(
                        0, min(allMarkers.length, _sliderVal))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
