import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geotasks/models/task.dart';
import 'package:geotasks/services/distance_parser.dart';
import 'package:geotasks/style/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class NavData {
  Position position;
  String distance;

  NavData({this.position, this.distance});
}

class TaskPage extends StatefulWidget {
  final Task task;
  final ValueNotifier<Position> curPos;

  TaskPage({@required this.task, @required this.curPos});

  @override
  State<StatefulWidget> createState() {
    return _TaskPageState(
      curPos: ValueNotifier(
        NavData(position: curPos.value, distance: task.distance),
      ),
    );
  }
}

class _TaskPageState extends State<TaskPage> with WidgetsBindingObserver {
  Completer<GoogleMapController> _controller = Completer();
  // GoogleMapController _ctrl;
  ValueNotifier<NavData> curPos;
  StreamSubscription<Position> tracker;
  BuildContext _ctx;

  _TaskPageState({this.curPos});

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  _launchURL(double lat, double long, Map<String, dynamic> dest) async {
    final url = 'google.navigation:q=${dest["lat"]},${dest["lng"]}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final webUrl =
          'https://www.google.com/maps/dir/$lat,$long/${dest["name"]}/@{dest["lat"]},${dest["lng"]}';
      await launch(webUrl);
    }
  }

  void _getImage(BuildContext context, NavData pos) async {
    final dist = await Geolocator().distanceBetween(pos.position.latitude,
        pos.position.longitude, widget.task.lat, widget.task.long);
    if (dist > 6) {
      Scaffold.of(_ctx ?? context).showSnackBar(
        SnackBar(
          content: Text(
            "You are outside the camera range, get within 5 metres of the task location to use the camera",
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Navigator.of(context).pushNamed('/camera/${widget.task.name}');
  }

  void _trackPos() async {
    tracker = Geolocator()
        .getPositionStream(
      LocationOptions(
        accuracy: LocationAccuracy.best,
        distanceFilter: 4,
        timeInterval: 1000,
      ),
    )
        .listen((Position pos) async {
      try {
        double dist = await Geolocator().distanceBetween(
            pos.latitude, pos.longitude, widget.task.lat, widget.task.long);
        curPos.value = NavData(
          position: pos,
          distance: parseDistance(dist, isRaw: true),
        );
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((interval) {
      _trackPos();
    });
    return Scaffold(
      floatingActionButton: ValueListenableBuilder(
        valueListenable: curPos,
        child: FloatingActionButton(
          child: Icon(Icons.camera_alt),
          onPressed: () => _getImage(context, curPos.value),
        ),
        builder: (context, val, child) {
          return child;
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.3,
        ),
        decoration: BoxDecoration(
          color: appWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1.5,
              spreadRadius: 1.1,
            )
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  widget.task.name.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headline
                      .copyWith(fontSize: 18),
                ),
                ValueListenableBuilder(
                  valueListenable: curPos,
                  builder: (context, NavData val, _) {
                    return Text(
                      "You are ${val.distance} ${val.distance.endsWith('range')  ? 'of' : 'from'} the task location",
                    );
                  },
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.body1,
                    children: [
                      TextSpan(text: "Objective: "),
                      TextSpan(
                        text:
                            "Go to the task location and take a picture of it",
                        style: TextStyle(color: appYellow),
                      ),
                    ],
                  ),
                ),
                ButtonBar(
                  buttonPadding: EdgeInsets.all(0),
                  alignment: MainAxisAlignment.start,
                  children: <Widget>[
                    RaisedButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      color: appRed,
                      textColor: appWhite,
                      child: Text("Ignore Task"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    RaisedButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text("Track Task"),
                      onPressed: () => _launchURL(
                          curPos.value.position.latitude,
                          curPos.value.position.longitude, {
                        "lat": widget.task.lat,
                        "lng": widget.task.long,
                        "name": widget.task.name
                      }),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Text(
          "TASK",
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      body: Builder(
        builder: (context) {
          _ctx = context;
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: GoogleMap(
                    markers: Set<Marker>()
                      ..add(
                        Marker(
                          markerId: MarkerId('B'),
                          position: LatLng(
                            widget.task.lat,
                            widget.task.long,
                          ),
                        ),
                      ),
                    // mapType: MapType.terrain,
                    onMapCreated: (GoogleMapController controller) {
                      // _ctrl = controller;
                      _controller.complete(controller);
                    },
                    indoorViewEnabled: true,
                    trafficEnabled: true,
                    myLocationEnabled: true,
                    compassEnabled: true,
                    initialCameraPosition: CameraPosition(
                      zoom: 15,
                      bearing: 30,
                      target: LatLng(
                        widget.task.lat,
                        widget.task.long,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    if (tracker != null) {
      tracker.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
