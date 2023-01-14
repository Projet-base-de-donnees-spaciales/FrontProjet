import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/pages/LoginScreen.dart';

import 'package:flutter_map_example/pages/tap_to_add.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

import 'CRudCategory.dart';
import 'Param.dart';

class updateEvent extends StatefulWidget {
  dynamic event;
  static const String route = 'updateEvent';
  @override
  State<StatefulWidget> createState() {
    return _UpdateEventState(event);
  }

  updateEvent(this.event);
}
class _UpdateEventState extends State<updateEvent> {
  late List<dynamic> categories;
  dynamic event;
  final minimumPadding = 5.0;
  List<String > list=[];
  String dropdownValue="";
  TextEditingController lastController = TextEditingController();
  TextEditingController nameEvent = TextEditingController();
  TextEditingController dateController = TextEditingController();
  LatLng tappedPoints = LatLng(0, 0);
  LatLng CenterMap = LatLng(31.7917, -7.0926);
  bool _isEnabled = false;
  List<dynamic> employees=[];

  _UpdateEventState(this.event) {
    nameEvent = TextEditingController(text: this.event['evenementDTO']['name'].toString());
    lastController = TextEditingController(text: this.event['evenementDTO']['description'].toString());
    dateController = TextEditingController(text: this.event['evenementDTO']['date_expiration'].toString());
    dropdownValue=this.event['evenementDTO']['categoryDTO']['name'].toString();
     tappedPoints=LatLng(double.parse(this.event['pointX'].toString()),double.parse(this.event['pointY'].toString())) ;


  }
  @override
  void initState() {
    getCate();
    super.initState();
  }
  int _selected = 0;

  void on(int? value) {
    setState((){
      _selected = value!;
    });

    print('Value = $value');
  }
  List<Widget> makeRadios() {
    List<Widget> list = <Widget>[];

      list.add(RadioListTile(
        value: 0,
        title: Text('Focus'),
        groupValue: _selected,
        onChanged: (int? value){on(value);},
        activeColor: Colors.red,
        subtitle: Text('Ajouter votre position manullement'),
      ));
      list.add(RadioListTile(
        value: 1,
        title: Text('Live Location'),
        groupValue: _selected,
        onChanged: (int? value){on(value);},
        activeColor: Colors.red,
        subtitle: Text('Ajouter votre postion actuelle'),
      ));

    return list;
  }
  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.subtitle2;
    final markers = <Marker>[];
    markers.add( Marker(
      width: 80,
      height: 80,
      point: tappedPoints,
      builder: (context) => const Icon(
        Icons.location_on,
        color: Colors.green,
        size: 40,
      ),
    ));
    return MaterialApp(
        title: 'Update Event',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(


          appBar: AppBar(title: const Text('Modifier événement'),
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () { Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));},
                      child: Icon(
                        Icons.logout,
                        size: 26.0,
                      ),
                    )
                )]
          ),

            body:
            Column(
            children: <Widget>[
              const ListTile(
                  title:  Center(child:  Text("Catégorie"))),

    DropdownButton<String>(
    value: dropdownValue,
    icon: const Icon(Icons.arrow_downward),
    elevation: 16,
    style: const TextStyle(color: Colors.deepPurple),
    underline: Container(
    height: 2,
    color: Colors.deepPurpleAccent,
    ),

    items:list.map<DropdownMenuItem<String>>((String valuer) {
    return DropdownMenuItem<String>(
    value: valuer,
    child: Text(valuer),
    );
    }).toList(),
    onChanged: (String? value) {
    setState((){
    dropdownValue = value!;
    });
    // This is called when the user selects an item.

    },
    ),
    Padding(
    padding: EdgeInsets.only(
    top: minimumPadding, bottom: minimumPadding),
    child: TextFormField(
    style: textStyle,
    controller: nameEvent,
    /*validator: (String value) {
                              if (value.isEmpty) {
                                return 'please enter your name';
                              }
                            },*/
    decoration: InputDecoration(
    labelText: 'Nom',
    hintText: "Saisir le nom d'événement",
    labelStyle: textStyle,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0))),
    ))

    , Padding(
    padding: EdgeInsets.only(
    top: minimumPadding, bottom: minimumPadding),
    child: TextFormField(
    style: textStyle,
    controller: lastController,
    /*validator: (String value) {
                              if (value.isEmpty) {
                                return 'please enter your name';
                              }
                            },*/
    decoration: InputDecoration(
    labelText: 'Description',
    hintText: "Saisir la description d'événement",
    labelStyle: textStyle,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0))),
    ))
    ,TextField(

    controller: dateController, //editing controller of this TextField
    decoration: const InputDecoration(

    icon: Icon(Icons.calendar_today), //icon of text field
    labelText: "La date d'expiration" //label text of field
    ),
    readOnly: true,  // when true user cannot edit text
    onTap: () async {
    DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(), //get today's date
    firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
    lastDate: DateTime(2101)
    );

    if(pickedDate != null ){
    print(pickedDate);  //get the picked date in the format => 2022-07-04 00:00:00.000
    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
    print(formattedDate); //formatted date output using intl package =>  2022-07-04
    //You can format date as per your need

    setState(() {
    dateController.text = formattedDate; //set foratted date to TextField value.

    });
    print(dateController.text);
    }else{
    print("Date is not selected");
    }
    },
    )


  ,
    Flexible(
                child: FlutterMap(
                  options: MapOptions(

                    center: CenterMap,
                    zoom: 5,
                      onTap: _handleTap
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
     ElevatedButton(
    child: Text('Ajouter'),
    onPressed: ()  {
    Updateevent(context);

    })
    /* Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Tap your location'),
            ),

          ],
        ),
      ),])*/
    ])

    ));


  }

  void _handleTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      CenterMap=latlng;
    });
  }
  void getCate(){

    http.get(Uri.parse(Param.UrlAllCat))
        .then((resp){

      setState((){
        var jsonData = json.decode(resp.body);
        categories = jsonData['categorieList'] as List;

        print(categories);
        for(int i=0;i<categories.length;i++){
          //Category calcium = Category.fromJson(json);
          list.add(categories[i]['name'].toString()) ;
          print(categories[i]['name'].toString());
        }

        print(list);
      });
    }).catchError((error){
      print(error);
    });
  }

  void Updateevent(BuildContext context)  {
    Category emp = new Category( name: dropdownValue);
    print("POINT("+this.CenterMap.latitude.toString()+" "+this.CenterMap.longitude.toString()+")");
    print(int.parse(this.event['id'].toString()));
    User user=new User(id:int.parse(this.event['evenementDTO']['userDTO']['id'].toString()));
    Event event=new Event(id:int.parse(this.event['evenementDTO']['id'].toString()),description: lastController.text,category: emp
        ,point: "POINT("+this.CenterMap.latitude.toString()+" "+this.CenterMap.longitude.toString()+")",idPoint:int.parse(this.event['id'].toString())
        ,date_expiration: dateController.text,name: nameEvent.text,user:user );

    http.put(Uri.parse(Param.UrlUpdateEvent),headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(event))
        .then((resp){
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            var jsonData = json.decode(resp.body);
            var message = jsonData['message'];
            return MyAlertDialogSHOWW(
                title: 'Backend Response', content: message.toString());
          });




    }).catchError((error){
      print(error);
    });


  }

}

