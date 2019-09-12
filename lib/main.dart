import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'res/strings.dart';
import 'ui/theme_page.dart';
import './ui/main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: AppInfoProvider())],
      child: Consumer<AppInfoProvider>(
        builder: (context, appinfo, _) {
          return MaterialApp(
            title: Strings.app_name,
            home: MainPage(),
            theme: ThemeData(primaryColor: appinfo.themeColor),
          );
        },
      ),
    );
  }
}


