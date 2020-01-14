import 'dart:math';
import 'dart:core';
import 'package:geotasks/models/coordinates.dart';

double toRad(degree) {
  return degree * pi / 180;
}

String humanizeDistance(Coordinates pointA, Coordinates pointB,
    {locale = "en-US", unitSystem = "metric"}) {
  final deltaLatitude = toRad((pointA.latitude - pointB.latitude).abs());
  final deltaLongitude = toRad((pointA.longitude - pointB.longitude).abs());

  final a = pow(sin(deltaLatitude / 2), 2) +
      pow(sin(deltaLongitude / 2), 2) *
          cos(toRad(pointA.latitude)) *
          cos(toRad(pointB.latitude));

  final hav = 2 * atan2(sqrt(a), sqrt(1 - a));

  final distance = unitSystem == "metric" ? hav * 6373 : hav * 3960;
  return parseDistance(distance);
}

String parseDistance(
  double distance, {
  locale = "en-US",
  unitSystem = "metric",
  isRaw = false,
}) {
  if (isRaw) {
    distance = unitSystem == "metric" ? distance / 1000 : distance / 1760;
  }
  final result = unitSystem == "metric"
      ? {
          "distance": distance,
          "unit": "km",
          "smallUnit": "meters",
          "factor": 1000,
          "smallBorder": 0.9
        }
      : {
          "distance": distance,
          "unit": "mi",
          "smallUnit": "yards",
          "factor": 1760,
          "smallBorder": 0.5
        };

  if ((result["distance"] as double) < (result["smallBorder"] as double)) {
    distance =
        (result["distance"] as double) * (result["factor"] as int);
    if (distance <= 20) {
      return "within camera range";
    } else {
      distance = distance / 50 * 50.0;
      return "${distance.toStringAsFixed(2)} ${result["smallUnit"]} away";
    }
  } else {
    return "${(result["distance"] as double).toStringAsFixed(2)} ${result["unit"]} away";
  }
}
