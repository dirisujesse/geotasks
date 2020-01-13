import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geotasks/services/storage.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 200), () async {
      final isFirstTimeUser = await StorageService.removeItem(key: 'isPrevUser');
      if (isFirstTimeUser == null || isFirstTimeUser == false) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      } else {
        final isLoggedIn = await StorageService.getItem(key: 'isLoggedIn');
        isLoggedIn == true ? Navigator.of(context).pushReplacementNamed('/home') : Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/img/GEOTASKS.png"),
      ),
    );
  }
}
