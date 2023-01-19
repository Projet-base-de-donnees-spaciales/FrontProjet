import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../Param.dart';
import '../custom_popup.dart';


class MarkerEventPage extends StatefulWidget {
  static const String route = '/marker_events';

  const  MarkerEventPage({Key? key}) : super(key: key);

  @override
  MarkerEventPageState createState() {
    return MarkerEventPageState();
  }
}

class MarkerEventPageState extends State< MarkerEventPage> {

  late List<dynamic> eventes;
  final List<Marker> Emarkers = <Marker>[];
  @override
  void initState() {
    this.getEvents();
    super.initState();

  }
  void getEvents() {
    http.get(Uri.parse(Param.UrlAllEvent))
        .then((resp) {
      setState(() {
        var jsonData = json.decode(resp.body);
        eventes = jsonData['positionDTOSList'] as List;
        print(eventes[0]);
        print("************************************************");
        print("*************Markers****************************");
        for(int i=0;i<eventes.length;i++){
          print("point" + eventes[i]['evenementDTO']['name'].toString());
          Emarkers.add(Marker(
              name: eventes[i]['evenementDTO']['name']as String,
              width: 100,
              height: 50,
              point: LatLng(eventes[i]['pointX'] as double,eventes[i]['pointY'] as double),
              builder: (ctx) => _buildCustomMarker(eventes[i]['evenementDTO']['name']as String)
          ));
        }

      });
    }).catchError((error) {
      print(error);
    });
  }
  @override
  Widget build(BuildContext context) {


    final markers = <Marker>[
      Marker(
        width: 80,
        height: 80,
        point: LatLng(51.5, -0.09),
        builder: (ctx) => const FlutterLogo(),

      ),
      Marker(
        width: 80,
        height: 80,
        point: LatLng(53.3498, -6.2603),
        builder: (ctx) => const FlutterLogo(
          textColor: Colors.green,
        ),

      ),
      Marker(
        width: 50,
        height: 50,
        point: LatLng(48.8566, 2.3522),
        builder: (ctx) => const FlutterLogo(textColor: Colors.purple),

      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Events Points')),
      drawer: buildDrawer(context, MarkerEventPage.route),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // const Padding(
            //   padding: EdgeInsets.only(top: 8, bottom: 8),
            //   child: Text(
            //       'Markers can be anchored to the top, bottom, left or right.'),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 8, bottom: 8),
            //   child: Wrap(
            //     children: <Widget>[
            //       MaterialButton(
            //         onPressed: () => _setAnchorAlignPos(AnchorAlign.left),
            //         child: const Text('Left'),
            //       ),
            //       MaterialButton(
            //         onPressed: () => _setAnchorAlignPos(AnchorAlign.right),
            //         child: const Text('Right'),
            //       ),
            //       MaterialButton(
            //         onPressed: () => _setAnchorAlignPos(AnchorAlign.top),
            //         child: const Text('Top'),
            //       ),
            //       MaterialButton(
            //         onPressed: () => _setAnchorAlignPos(AnchorAlign.bottom),
            //         child: const Text('Bottom'),
            //       ),
            //       MaterialButton(
            //         onPressed: () => _setAnchorAlignPos(AnchorAlign.center),
            //         child: const Text('Center'),
            //       ),
            //       MaterialButton(
            //         onPressed: () => _setAnchorExactlyPos(Anchor(80, 80)),
            //         child: const Text('Custom'),
            //       ),
            //     ],
            //   ),
            // ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(0, 0),
                  zoom: 3,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(markers: Emarkers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  var infoWindowVisible = false;
  late GlobalKey<State> key;
  Stack _buildCustomMarker(String str) {
    key = new GlobalKey();
    return Stack(
      children: <Widget>[
        popup(),
        marker(str)
      ],
    );
  }
  Opacity popup() {
    return Opacity(
      opacity: infoWindowVisible ? 1.0 : 0.0,
      child: Container(
        alignment: Alignment.bottomCenter,
        width: 279.0,
        height: 256.0,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("../assets/images/event.png"),
                fit: BoxFit.cover)),
        child: CustomPopup(key: key),
      ),
    );
  }
  Opacity marker(String str) {
    return Opacity(
      child: Container(

          alignment: Alignment.bottomCenter,
          child:  Text(str,textAlign: TextAlign.center,style: TextStyle(background: Paint()..color = Colors.blueAccent ..strokeWidth = 20
            ..strokeJoin = StrokeJoin.round
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
            color: Colors.white,),)
          // Image.asset(
          //   '../assets/images/event.png',
          //   width: 49,
          //   height: 65,
          //
          // )
        ),
      opacity: infoWindowVisible ? 0.0 : 1.0,

    );
  }
  static List<Shadow> outlinedText({double strokeWidth = 2, Color strokeColor = Colors.black, int precision = 5}) {
    Set<Shadow> result = HashSet();
    for (int x = 1; x < strokeWidth + precision; x++) {
      for(int y = 1; y < strokeWidth + precision; y++) {
        double offsetX = x.toDouble();
        double offsetY = y.toDouble();
        result.add(Shadow(offset: Offset(-strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(-strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
      }
    }
    return result.toList();
  }
}
