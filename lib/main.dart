import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'res/strings.dart';
import 'ui/theme_page.dart';
import './ui/main_page.dart';

void main() async {
  var localeTheme = await _getThemeColor();
  runApp(MyApp(localeTheme));
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，
    // 是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

_getThemeColor() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Color themeColor;
  if (prefs.getInt("ThemeColor") != null) {
    themeColor = Color(prefs.getInt("ThemeColor"));
  } else {
    themeColor = Colors.blue;
  }
  return themeColor;
}

class MyApp extends StatelessWidget {
  final Color localeTheme;

  MyApp(this.localeTheme);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: AppInfoProvider())],
      child: Consumer<AppInfoProvider>(
        builder: (context, appinfo, _) {
          return MaterialApp(
            title: Strings.app_name,
            home: MainPage(),
            theme: _getThemeData(appinfo.themeColor),
          );
        },
      ),
    );
  }

  _getThemeData(Color color) {
    var info = color ?? localeTheme;
    if (info.value == Colors.black.value) {
      return ThemeData(
        brightness: Brightness.dark,
      );
    } else {
      return ThemeData(
          brightness: Brightness.light, primaryColor: info, accentColor: info);
    }
  }
}
