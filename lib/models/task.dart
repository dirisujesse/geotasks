import 'package:flutter/cupertino.dart';

class Task {
  String name;
  String object;
  String vicinity;
  double lat;
  double long;
  bool isCompleted;
  List<String> pictures;
  String distance;

  Task({
    @required this.name,
    @required this.object,
    @required this.long,
    @required this.lat,
    this.isCompleted,
    this.pictures,
    this.vicinity,
    this.distance,
  });
}
