import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'res/strings.dart';
import 'ui/theme_page.dart';
import './ui/main_page.dart';

void main() async {
  var localeTheme = await _getThemeColor();
  runApp(MyApp(localeTheme));
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
            theme: ThemeData(primaryColor: appinfo.themeColor ?? localeTheme),
          );
        },
      ),
    );
  }
}
