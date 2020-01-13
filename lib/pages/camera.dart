import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geotasks/style/colors.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  final String taskName;

  CameraPage({this.taskName});

  @override
  State<StatefulWidget> createState() {
    return _CameraPageState();
  }
}

class _CameraPageState extends State<CameraPage> {
  CameraController _ctrl;
  bool isCapturing = false;

  @override
  void initState() {
    _ctrl = CameraController(
      CameraDescription(
        name: "0",
        lensDirection: CameraLensDirection.back,
        sensorOrientation: 90,
      ),
      ResolutionPreset.ultraHigh,
    );
    _ctrl.initialize();
    super.initState();
  }

  Future<List<String>> _takePhoto() async {
    isCapturing = true;
    List<String> imagePaths = [];

    if (_ctrl != null) {
      int count = 0;
      while (count < 3) {
        try {
          final tempDir = await getTemporaryDirectory();
          final path = join(
            tempDir.path,
            "${DateTime.now()}_${widget.taskName}_$count.png",
          );
          imagePaths.add(path);
          await _ctrl.takePicture(path);
        } catch (e) {
          print(e);
        }
        count++;
      }
    }
    isCapturing = false;
    return imagePaths;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBlack,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () async {
          if (isCapturing) {
            return;
          }
          final images = await _takePhoto();
          if (images.length > 0) {
            Navigator.of(context).pushNamed('/preview', arguments: images);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ValueListenableBuilder(
        valueListenable: _ctrl,
        builder: (context, cam, _) {
          if (_ctrl.value.isInitialized) {
            return AspectRatio(
              aspectRatio: _ctrl.value.aspectRatio,
              child: CameraPreview(_ctrl),
            );
          } else if (_ctrl.value.hasError) {
            return Center(
              child: Text("An Error occured while initialising the camera"),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}
