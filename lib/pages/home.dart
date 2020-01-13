import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geotasks/models/coordinates.dart';
import 'package:geotasks/models/task.dart';
import 'package:geotasks/services/distance_parser.dart';
import 'package:geotasks/services/http.dart';
import 'package:geotasks/style/colors.dart';

Position pos;

Future<List<Task>> _getTasks() async {
  try {
    pos = await Geolocator().getCurrentPosition();
    List<dynamic> locs =
        await HttpService.searchNearby("${pos.latitude},${pos.longitude}");
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
  } catch (e) {
    return [];
  }
}

ValueNotifier<Future<List<Task>>> future = ValueNotifier(_getTasks());

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Text(
          "HOME",
          style: Theme.of(context).textTheme.headline,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('/login'),
          )
        ],
      ),
      body: Container(
        height: height,
        width: width,
        child: ValueListenableBuilder(
          valueListenable: future,
          builder: (context, promise, _) {
            return FutureBuilder(
              future: promise,
              builder: (context, AsyncSnapshot<List<Task>> data) {
                if (data.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (data.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                              "Ooops no tasks were found in your current vicinity"),
                          IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () => future.value = _getTasks(),
                          )
                        ],
                      ),
                    );
                  }
                  if (data.data.length == 0) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                              "Ooops no tasks were found in your current vicinity, make sure you granted geotask access to your location"),
                          IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () => future.value = _getTasks(),
                          )
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    itemCount: data.data.length,
                    itemBuilder: (context, int idx) {
                      final Task task = data.data[idx];
                      if (idx == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${data.data.length} locations were found near you",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.all(0),
                              leading: CircleAvatar(
                                child: Text(task.name[0].toUpperCase()),
                                backgroundColor: appBlue,
                              ),
                              title: Text(task.name),
                              subtitle: Text(task.distance),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    '/task',
                                    arguments: {
                                      "task": task,
                                      "loc": pos ??
                                          Position(latitude: 0, longitude: 0)
                                    },
                                  );
                                  // future.dispose();
                                },
                              ),
                            )
                          ],
                        );
                      }
                      return ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: CircleAvatar(
                          child: Text(task.name[0].toUpperCase()),
                          backgroundColor: appBlue,
                        ),
                        title: Text(task.name),
                        subtitle: Text(task.distance),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              '/task',
                              arguments: {
                                "task": task,
                                "loc":
                                    pos ?? Position(latitude: 0, longitude: 0)
                              },
                            );
                            // future.dispose();
                          },
                        ),
                      );
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
