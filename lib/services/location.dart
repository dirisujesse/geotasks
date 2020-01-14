import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geotasks/models/coordinates.dart';
import 'package:geotasks/models/task.dart';
import 'package:geotasks/services/distance_parser.dart';
import 'package:geotasks/services/http.dart';
import 'package:permission_handler/permission_handler.dart';

Position pos;
PermissionHandler _permissionHandler = PermissionHandler();
Geolocator geo = Geolocator();

_showSnack(BuildContext context, {String content}) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(
      content,
      textAlign: TextAlign.center,
    ),
    behavior: SnackBarBehavior.floating,
  ));
}

Future<List<Task>> getTasks(BuildContext context) async {
  try {
    final GeolocationStatus hasPerm =
        await geo.checkGeolocationPermissionStatus();
    if (hasPerm == GeolocationStatus.denied ||
        hasPerm == GeolocationStatus.unknown) {
      await _permissionHandler.requestPermissions(
        [PermissionGroup.location],
      );
      return [];
    } else if (hasPerm == GeolocationStatus.disabled) {
      _showSnack(
        context,
        content:
            "Please turn on the location service on your device to use this app",
      );
      return [];
    } else {
      final bool locationServiceActive = await geo.isLocationServiceEnabled();
      if (!locationServiceActive) {
        _showSnack(
          context,
          content:
              "Please turn on the location service on your device to use this app",
        );
        return [];
      }
      pos = await geo.getCurrentPosition();
      List<dynamic> locs = await HttpService.searchNearby(
          "${pos?.latitude ?? 0},${pos?.longitude ?? 0}");
      return List<Task>.generate(
        locs.length,
        (int idx) {
          Map<String, dynamic> task = locs[idx];
          return Task(
            name: task["name"],
            object: task["icon"],
            isCompleted: false,
            lat: task["geometry"]["location"]["lat"],
            long: task["geometry"]["location"]["lng"],
            vicinity: task["vicinity"],
            distance: humanizeDistance(
              Coordinates(
                latitude: pos.latitude,
                longitude: pos.longitude,
              ),
              Coordinates(
                latitude: task["geometry"]["location"]["lat"],
                longitude: task["geometry"]["location"]["lng"],
              ),
            ),
          );
        },
      );
    }
  } catch (e) {
    return [];
  }
}
