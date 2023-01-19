import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/pages/Param.dart';
import 'package:flutter_map_example/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:flutter_map_example/widgets/drawer.dart';
class LiveLocation1Page extends StatefulWidget {
  static const String route = '/event_location';

  const LiveLocation1Page({Key? key}) : super(key: key);

  @override
  _LiveLocationPageState createState() => _LiveLocationPageState();
}

class _LiveLocationPageState extends State<LiveLocation1Page> {
  late List<dynamic> eventes;
  late final markers= <Marker>[];
  late Marker markerLocation;//= Marker(point: null, builder: (BuildContext context) { const Text("data") });
  late int x=0;
  //final List<Marker> Emarkers = <Marker>[];
  StompClient? stompClient;
  LocationData? _currentLocation;
  late final MapController _mapController;
  LatLng CenterMap = LatLng(31.7917, -7.0926);
  bool _liveUpdate = false;
  bool _permission = false;

  String? _serviceError = '';

  int interActiveFlags = InteractiveFlag.all;

  final Location _locationService = Location();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    Timer.periodic(Duration(seconds: 5), (timer)
    {
      //print("********************************************************************");

      initLocationService();
      connection();

      //print("********************************************************************");
    });
  }

  void initLocationService() async {
    await _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );

    LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      serviceEnabled = await _locationService.serviceEnabled();

      if (serviceEnabled) {
        final permission = await _locationService.requestPermission();
        _permission = permission == PermissionStatus.granted;

        if (_permission) {
          location = await _locationService.getLocation();
          _currentLocation = location;
          _locationService.onLocationChanged
              .listen((LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;
                sentEvents();
                // If Live Update is enabled, move map center
                if (_liveUpdate) {
                  _mapController.move(
                      LatLng(_currentLocation!.latitude!,
                          _currentLocation!.longitude!),
                      _mapController.zoom);
                  CenterMap= LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
                  sentEvents();
                }
              });
            }
          });
        }
      } else {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        _serviceError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _serviceError = e.message;
      }
      location = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentLatLng;

    // Until currentLocation is initially updated, Widget can locate to 0, 0
    // by default or store previous location value to show.
    if (_currentLocation != null) {
      currentLatLng =
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);

    } else {
      currentLatLng = LatLng(0, 0);
    }
    markerLocation=  Marker(
  width: 80,
  height: 80,
  point: currentLatLng,
  builder: (context) =>
      Container(
          child: Tooltip(
              message: "My location",
              textStyle: TextStyle(
                  fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.blue
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 40,
              )
          )
      )
  ,
);

    if(markers.contains(markerLocation))
      {
        int i=markers.indexOf(markerLocation);
        markers[i].point=currentLatLng;
      }else
        markers.add(markerLocation);
    return Scaffold(
      appBar: AppBar(title: const Text('Getting live events')),
      drawer: buildDrawer(context, LiveLocation1Page.route),
      body: Padding(
        padding: const EdgeInsets.all(8),

        child: Column(
          children: [

            Flexible(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center:
                  CenterMap,
                  zoom: 5,
                  interactiveFlags: interActiveFlags,
                ),
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
  void sentEvents(){

    var x =_currentLocation!.latitude.toString();
    var y =_currentLocation!.longitude.toString();
    String pointXY="Point("+ x +" " + y +")";
    print(pointXY);
    stompClient?.send(destination: "/app/sendEvents", body: json.encode({'point': pointXY}));

  }
  void onConnect(StompFrame connectFrame) {
    print("*******************************************************************");
    print("on connect1");
    //sentEvents();
    stompClient?.subscribe(
        destination: '/topic/events',
        callback: (StompFrame frame) {
          print("on connect2");
          if (frame.body != null) {
            print("on connect3");
            print(frame.body!);
            var jsonData = json.decode(frame.body!);
            eventes = jsonData['positionDTOSList'] as List;
            print(eventes[0]);
            print("************************************************");
            print("*************Markers****************************");
            for(int i=0;i<eventes.length;i++){
              String str="Event : "+eventes[i]['evenementDTO']['name'].toString()+"\nInfos: "+eventes[i]['evenementDTO']['description'].toString()+"\ndate d'expiration: "+eventes[i]['evenementDTO']['date_expiration'].toString();
              print("name of event : "+(i+1).toString() + eventes[i]['evenementDTO']['name'].toString());
              markers.add(Marker(
                  name: eventes[i]['evenementDTO']['name']as String,
                  width: 100,
                  height: 50,
                  point: LatLng(eventes[i]['pointX'] as double,eventes[i]['pointY'] as double),
                  builder: (ctx) => Container(
                        child: Tooltip(
                            message: str,
                            textStyle: TextStyle(
                                fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10), color: Colors.green
                            ),
                            child:  Icon(
                                    Icons.location_pin,
                                    size: 26.0,
                                    color: Colors.deepPurple,
                                  )
                            )
                  )
                        //     Icon(
                  //   Icons.location_pin,
                  //   size: 26.0,
                  // )
              ));
            }
          }
        });
  }
  void connection() {
    stompClient ??= StompClient(
        config: StompConfig.SockJS(
          url: Param.socketUrl,
          onConnect: onConnect,
          onWebSocketError: (dynamic error) => print(error.toString()),
        ));
    stompClient?.activate();
  }

}