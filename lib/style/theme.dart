import 'package:flutter/material.dart';
import 'package:geotasks/style/colors.dart';

ThemeData appTheme([bool darkTheme = false]) {
  final base = darkTheme ? ThemeData.dark() : ThemeData.light();
  return ThemeData(
    bottomAppBarColor: darkTheme ? white : blue,
    errorColor: appRed,
    appBarTheme: AppBarTheme(
      elevation: 1,
    ),
    scaffoldBackgroundColor: darkTheme ? blue : white,
    fontFamily: 'Montserrat',
    textTheme: TextTheme(
      headline: TextStyle(fontFamily: 'Orbitron'),
      title: TextStyle(fontWeight: FontWeight.bold),
      subtitle: TextStyle(fontStyle: FontStyle.italic),
    ).apply(displayColor: darkTheme ? appWhite : appBlack),
    buttonTheme: base.buttonTheme.copyWith(
      colorScheme: ColorScheme(
        primary: darkTheme ? appYellow : appBlue,
        primaryVariant: darkTheme ? appYellow : appBlue,
        secondary: !darkTheme ? appYellow : appBlue,
        secondaryVariant: !darkTheme ? appYellow : appBlue,
        onError: appRed,
        brightness: darkTheme ? Brightness.dark : Brightness.light,
        error: appRed,
        surface: darkTheme ? appYellow : appBlue,
        onPrimary: darkTheme ? appYellow : appBlue,
        onSecondary: !darkTheme ? appYellow : appBlue,
        onBackground: darkTheme ? appYellow : appBlue,
        onSurface: darkTheme ? appYellow : appBlue,
        background: darkTheme ? appYellow : appBlue,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
      ),
      buttonColor: darkTheme ? appYellow : appBlue,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    ),
    primarySwatch: darkTheme ? white : blue,
    brightness: darkTheme ? Brightness.dark : Brightness.light,
    primaryColor: darkTheme ? blue : white,
    accentColor: darkTheme ? white : blue,
    primaryColorDark: blue,
    primaryColorLight: white,
    backgroundColor: darkTheme ? blue : white,
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: darkTheme ? appWhite : appBlack),
      hintStyle: TextStyle(color: darkTheme ? appWhite : appBlack),
      focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: darkTheme ? appWhite : appBlue, width: 3.0)),
      enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: darkTheme ? appWhite : appBlue, width: 2.0)),
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appGrey, width: 2.0)),
      focusedErrorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: appRed, width: 3.0)),
      errorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: appRed, width: 2.0)),
    ),
  );
}
