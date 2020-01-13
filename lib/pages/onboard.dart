import 'package:flutter/material.dart';
import 'package:geotasks/components/fragments/dots.dart';
import 'package:geotasks/services/storage.dart';
// import 'package:geotasks/style/colors.dart';

final ValueNotifier<int> curPage = ValueNotifier(0);

class OnboardPage extends StatelessWidget {
  final PageController _ctrl = PageController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: ValueListenableBuilder(
          valueListenable: curPage,
          builder: (context, val, _) {
            return FlatButton(
              padding: EdgeInsets.only(top: 0, left: 20, right: 0, bottom: 0),
              child: Text(val == 0 ? "" : "Prev"),
              onPressed: () => val == 0
                  ? ""
                  : _ctrl.previousPage(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn),
            );
          },
        ),
        title: ValueListenableBuilder(
          valueListenable: curPage,
          builder: (context, val, _) {
            return Dots(val, 4);
          },
        ),
        actions: <Widget>[
          ValueListenableBuilder(
            valueListenable: curPage,
            builder: (context, val, _) {
              return FlatButton(
                padding: EdgeInsets.all(0),
                child: Text(val == 3 ? "" : "Next"),
                onPressed: () => val == 3
                    ? ""
                    : _ctrl.nextPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: _ctrl,
        onPageChanged: (int idx) => curPage.value = idx,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxHeight: height, maxWidth: width),
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Image.asset(
                        "assets/img/undraw_connected_world_wuay.png"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: width * 0.8,
                  height: height * 0.2,
                  child: Text(
                    "Get Tasks Anywhere in the World",
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: height, maxWidth: width),
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Image.asset("assets/img/undraw_best_place_r685.png"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: width * 0.8,
                  height: height * 0.2,
                  child: Text(
                    "Get directions to tasks in your vicinity",
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: height, maxWidth: width),
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Image.asset(
                      "assets/img/digital-camera.png",
                      width: width * 0.8,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: width * 0.8,
                  height: height * 0.2,
                  child: Text(
                    "Take photograph of the task object",
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: height, maxWidth: width),
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Image.asset(
                      "assets/img/40336.png",
                      width: width * 0.8,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: width * 0.2),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "Get paid for completed tasks",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10,),
                      RaisedButton(
                        child: Text("SIGN UP"),
                        onPressed: () async {
                          await StorageService.setItem(key: 'isPrevUser', val: true);
                          Navigator.of(context).pushReplacementNamed('/signup');
                        },
                      ),
                      SizedBox(height: 10,),
                      OutlineButton(
                        child: Text("LOG IN"),
                        onPressed: () async {
                          await StorageService.setItem(key: 'isPrevUser', val: true);
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
