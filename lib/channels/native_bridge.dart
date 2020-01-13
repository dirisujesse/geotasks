import 'package:flutter/services.dart';
// import 'package:permission_handler/permission_handler.dart';

class NativeCaller {
  static MethodChannel channel = const MethodChannel('geotasks_cam_channel');
  static NativeCaller instance;
  // static PermissionHandler _permissionHandler = PermissionHandler();

  // static void takePhoto() async {
  //   bool isPermitted = true;
  //   PermissionStatus permitStorage =
  //       await _permissionHandler.checkPermissionStatus(PermissionGroup.storage);
  //   PermissionStatus permitCam =
  //       await _permissionHandler.checkPermissionStatus(PermissionGroup.camera);
  //   isPermitted = (permitCam != null && permitStorage != null)
  //       ? ((permitCam == PermissionStatus.granted) &&
  //           (permitCam == PermissionStatus.granted))
  //       : false;
  //   if (!isPermitted) {
  //     await _permissionHandler.requestPermissions(
  //         [PermissionGroup.camera, PermissionGroup.storage],);
  //     return;
  //   }
  //   try {
  //     await channel.invokeMethod('capture');
  //   } on PlatformException catch (e) {
  //     throw "Failed to capture: '${e.message}'.";
  //   }
  // }
}
