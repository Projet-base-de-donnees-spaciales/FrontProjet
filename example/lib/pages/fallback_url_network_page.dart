import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/pages/fallback_url/fallback_url.dart';
import 'package:latlong2/latlong.dart';

class FallbackUrlNetworkPage extends StatelessWidget {
  static const String route = '/fallback_url_network';

  const FallbackUrlNetworkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FallbackUrlPage(
      route: route,
      tileLayer: TileLayer(
        urlTemplate: 'https://fake-tile-provider.org/{z}/{x}/{y}.png',
        fallbackUrl: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        subdomains: const ['a', 'b', 'c'],
        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
      ),
      title: 'Fallback URL NetworkTileProvider',
      description:
          'Map with a fake url should use the fallback, showing (51.5, -0.9).',
      zoom: 5,
      center: LatLng(51.5, -0.09),
    );
  }
}
