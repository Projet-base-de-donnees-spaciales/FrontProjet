
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/pages/Param.dart';
import 'package:flutter_map_example/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map_example/pages/CRudCategory.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'CRudCategory.dart';
import 'CRudCategory.dart';
import 'CrudEvent.dart';



class TapToAddPage extends StatefulWidget {
  static const String route = '/tap';

  const TapToAddPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TapToAddPageState();
  }
}


class TapToAddPageState extends State<TapToAddPage> {
  dynamic category;
  final minimumPadding = 5.0;
  late List<dynamic> categories;
  String dropdownValue="";
  TextEditingController lastController = TextEditingController();
  TextEditingController nameEvent = TextEditingController();
  TextEditingController dateController = TextEditingController();
  List<dynamic> employees=[];
  List<String > list=[];
  LatLng tappedPoints = LatLng(0, 0);
  LatLng CenterMap = LatLng(31.7917, -7.0926);

  @override
  void initState() {
    getCate();
    super.initState();
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
        setState((){
          dropdownValue=list.first;
        });
      print(list);
      });
    }).catchError((error){
      print(error);
    });
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

    return Scaffold(
        appBar: AppBar(title: const Text('ADD Event')),
        drawer: buildDrawer(context, CrudCategory.route),
    body:
      Column(
          children: <Widget>[

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
                      labelText: 'Event name',
                      hintText: 'Enter Name of the Event',
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
                          hintText: 'Enter Description of the Event',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ))
            ,TextField(

              controller: dateController, //editing controller of this TextField
              decoration: const InputDecoration(

                  icon: Icon(Icons.calendar_today), //icon of text field
                  labelText: "Enter Date" //label text of field
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
            ,Flexible(
              child: FlutterMap(
                options: MapOptions(
                    center: CenterMap,
                    zoom: 5,
                    onTap: _handleTap),
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
                child: Text('ADD'),
                onPressed: ()  {
                ADDevent();
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
    );
  }

  void _handleTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      tappedPoints=latlng;
      CenterMap=latlng;
    });
  }
  void ADDevent(){
    print("X: "+ this.tappedPoints.latitude.toString()+" Y: " +this.tappedPoints.longitude.toString());
    print("Categorie: "+dropdownValue);
    print("Description: "+lastController.text);

    Category emp = new Category( name: dropdownValue);
    Event event=new Event(description: lastController.text,category: emp
        ,point: "POINT("+this.tappedPoints.latitude.toString()+" "+this.tappedPoints.longitude.toString()+")"
        ,date_expiration: dateController.text,name: nameEvent.text);


    http.post(Uri.parse(Param.UrlAddEvent),headers: <String, String>{"Content-Type": "application/json"},
    body: jsonEncode(event))
        .then((resp){
    showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
    var jsonData = json.decode(resp.body);
    var message = jsonData['message'];
    return MyAlertDialogSHOWWW(
    title: 'Backend Response', content: message.toString());
    });

    }).catchError((error){
    print(error);
    });
  }
}
class MyAlertDialogSHOWW extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  MyAlertDialogSHOWW({
    required this.title,
    required this.content,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        this.title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: <Widget>[
        ElevatedButton(
            child: Text('OK'),
            onPressed: ()  {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CrudCategory()));
            })

      ],
      content: Text(
        this.content,
        style: Theme.of(context).textTheme.bodyLarge,
      ),

    );
  }
}

class Event {

  String? description;
  Category? category;
  String? point;
  String? date_expiration;
  String? name;

  //il faut user


  Event({this.description, this.category, this.point,this.date_expiration,this.name});

  Map<String, dynamic> toJson() => {
    "description": description,
    "category": category,
    'point': point,
    'date_expiration':date_expiration,
    'name':name
  };
  factory Event.fromJson( dynamic json) => Event(
      description: json['description'].toString(),category: json["category"] as Category, point: json["point"].toString(),
      date_expiration:json['date_expiration'].toString(),name:json['name'].toString()
  );
}

