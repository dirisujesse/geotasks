import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geotasks/components/fragments/dots.dart';
import 'package:geotasks/style/colors.dart';

final ValueNotifier<int> curPage = ValueNotifier(0);

class PreviewPage extends StatefulWidget {
  final List<String> pictures;

  PreviewPage({this.pictures});

  @override
  State<StatefulWidget> createState() {
    return _PreviewPageState();
  }
}

class _PreviewPageState extends State<PreviewPage> {
  final PageController _ctrl = PageController();
  ValueNotifier<bool> isSubmitting = ValueNotifier(false);

  _submitPics(BuildContext context) {
    isSubmitting.value = true;
    Timer(Duration(seconds: 5), () => isSubmitting.value = false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.black54,
          body: SafeArea(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 15.0,
                    ),
                    constraints: BoxConstraints(maxHeight: 400, maxWidth: 300),
                    padding: EdgeInsets.only(
                      top: 40.0,
                      bottom: 10.0,
                      left: 15.0,
                      right: 15.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: isSubmitting,
                      builder: (context, val, child) {
                        if (val) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CircularProgressIndicator(),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Please wait as we process your task",
                                  style: TextStyle(
                                    fontFamily: 'Orbitron',
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/img/fogg-payment-processed-1.png',
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Thanks for submitting your task",
                                style: TextStyle(
                                  fontFamily: 'Orbitron',
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: .5,
                    child: FloatingActionButton(
                      backgroundColor: appRed,
                      heroTag: "cls",
                      onPressed: () {
                        isSubmitting.value
                            ? print("ok")
                            : Navigator.of(context)
                                .popUntil(ModalRoute.withName('/home'));
                      },
                      child: Icon(Icons.close),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "PREVIEW",
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      bottomNavigationBar: Container(
        constraints: BoxConstraints(maxHeight: width * 0.2),
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "reject",
              child: Icon(Icons.close),
              backgroundColor: Color(0xFFeb4d55),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: curPage,
                  builder: (context, val, _) {
                    return Dots(val, widget.pictures.length);
                  },
                ),
              ),
            ),
            FloatingActionButton(
              heroTag: "accept",
              child: Icon(Icons.done),
              backgroundColor: Colors.green,
              onPressed: () => _submitPics(context),
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          PageView(
            controller: _ctrl,
            onPageChanged: (int idx) => curPage.value = idx,
            children: List.generate(
              widget.pictures.length,
              (int idx) {
                File pic = File.fromUri(Uri.file(widget.pictures[idx]));
                return Container(
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.02,
                    horizontal: width * 0.02,
                  ),
                  alignment: Alignment.center,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: FileImage(pic),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            left: 10,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FloatingActionButton(
                backgroundColor: appBlack.withOpacity(0.7),
                elevation: 0,
                heroTag: "prev",
                child: Icon(Icons.arrow_back_ios),
                onPressed: () => _ctrl.previousPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                ),
              ),
            ),
          ),
          Positioned.fill(
            right: 10,
            child: Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                backgroundColor: appBlack.withOpacity(0.7),
                elevation: 0,
                heroTag: "next",
                child: Icon(Icons.arrow_forward_ios),
                onPressed: () => _ctrl.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
