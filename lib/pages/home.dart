import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geotasks/models/task.dart';
import 'package:geotasks/services/location.dart';
import 'package:geotasks/style/colors.dart';



class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  ValueNotifier<Future<List<Task>>> future;
  BuildContext _ctx;

  @override
  initState() {
    future = ValueNotifier(getTasks(context));
    super.initState();
  }

  Widget _errorWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Ooops no tasks were found in your current vicinity, make sure you granted geotask access to your location",
            textAlign: TextAlign.center,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => future.value = getTasks(_ctx ?? context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => future.value = getTasks(context),
      ),
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
      body: Builder(
        builder: (context) {
          _ctx = context;
          return Container(
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
                        return _errorWidget(context);
                      }
                      if (data.data.length == 0) {
                        return _errorWidget(context);
                      }
                      return ListView.builder(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        itemCount: data.data.length,
                        itemBuilder: (context, int idx) {
                          final Task task = data.data[idx];
                          if (idx == 0) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${data.data.length} tasks were found near you",
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
                                              Position(
                                                  latitude: 0, longitude: 0)
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
                                    "loc": pos ??
                                        Position(latitude: 0, longitude: 0)
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
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    future.dispose();
    super.dispose();
  }
}
