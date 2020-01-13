// import 'dart:convert';
import 'package:dio/dio.dart';

class HttpService {
  static String _apiKey = "AIzaSyAJ-IbFEdKuKbhDIxZuXVZhH34HhnEmvBQ";
  static List<dynamic> crudeCache;
  static DateTime lastCacheTime; 
  static Dio http = new Dio(
    BaseOptions(connectTimeout: 1000 * 120),
  );
  static String url =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json";

  static CancelToken cancelToken = new CancelToken();

  static Future<List<dynamic>> searchNearby(String loc) async {
    if (lastCacheTime != null && lastCacheTime.add(Duration(minutes: 30)).millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) {
      if (crudeCache != null) {
        return crudeCache;
      }
    }
    try {
      final req = await http.get(url, queryParameters: {
        "key": _apiKey,
        "radius": 1000,
        "location": loc,
      });
      if (req.statusCode <= 201) {
        final Map<String, dynamic> data = req.data;
        if (data["status"] == "OK") {
        final List<dynamic> match = data != null && data["results"] != null ? data["results"] : [];
        crudeCache = match;
        lastCacheTime = DateTime.now();
        return match;
        }
        return [];
      }
      return [];
    } catch (e) {
      throw e;
    }
  }

  void cancelReqs() {
    cancelToken.cancel("Request has been cancelled");
  }
}
