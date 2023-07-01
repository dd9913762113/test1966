import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "单机谷歌验证器",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      themeMode: ThemeMode.dark,
      theme: ThemeData(fontFamily: "Rubik"),
      darkTheme: AppTheme.dark,
    ),
  );
}



class AppTheme {
  static ThemeData light = lightTheme;
  static ThemeData dark = darkTheme;
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  highlightColor: Colors.transparent,
  splashColor: Colors.transparent,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black87,
  highlightColor: Colors.transparent,
  splashColor: Colors.transparent,
);
