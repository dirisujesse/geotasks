import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geotasks/models/task.dart';
import 'package:geotasks/pages/camera.dart';
import 'package:geotasks/pages/home.dart';
import 'package:geotasks/pages/login.dart';
import 'package:geotasks/pages/onboard.dart';
import 'package:geotasks/pages/preview.dart';
import 'package:geotasks/pages/signup.dart';
import 'package:geotasks/pages/splash_page.dart';
import 'package:geotasks/pages/task.dart';
import 'package:geotasks/style/theme.dart';

 void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoTasks',
      theme: appTheme(),
      home: SplashPage(),
      routes: {
        '/login': (BuildContext context) => LoginPage(),
        '/signup': (BuildContext context) => SignupPage(),
        '/home': (BuildContext context) => HomePage(),
        '/onboarding': (BuildContext context) => OnboardPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        final path = settings.name;
        if (path.startsWith('/task')) {
          final data = settings.arguments as Map<String, dynamic>;
          Task task = data["task"];
          return MaterialPageRoute(builder: (BuildContext context) {
            return TaskPage(
              task: task,
              curPos: ValueNotifier<Position>(data["loc"] as Position),
            );
          });
        } else if (path.startsWith('/camera')) {
          return MaterialPageRoute(builder: (BuildContext context) {
            return CameraPage(
              taskName: path.replaceFirst('/camera/', ''),
            );
          });
        } else if (path.startsWith('/preview')) {
          final data = settings.arguments;
          return MaterialPageRoute(builder: (BuildContext context) {
            return PreviewPage(
              pictures: data,
            );
          });
        } else {
          return MaterialPageRoute(
            builder: (BuildContext context) => HomePage(),
          );
        }
      },
    );
  }
}
