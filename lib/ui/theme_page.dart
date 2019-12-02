import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../res/strings.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatefulWidget {
  @override
  createState() => ThemePageState();
}

class ThemePageState extends State<ThemePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.theme)),
      body: new ListView.builder(
          itemCount: _theme.length,
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (BuildContext context, int position) {
            return _buildThemeRow(position);
          }),
    );
  }

  var _theme = [
    Colors.black,
    Colors.blue,
    Colors.green,
    Colors.grey,
    Colors.purple,
    Colors.yellow,
    Colors.red
  ];

  Widget _buildThemeRow(int i) {
    return ListTile(
      title: new Text(Strings.theme, style: TextStyle(color: _theme[i])),
      leading: new Icon(Icons.fiber_manual_record, color: _theme[i]),
      onTap: () {
        setState(() {
          Provider.of<AppInfoProvider>(context).setTheme(_theme[i]);
        });
      },
    );
  }
}


_saveThemeColor(Color themeColor) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("ThemeColor", themeColor.value);
}

class AppInfoProvider with ChangeNotifier {
  Color _themeColor;
  Color get themeColor => _themeColor;

  setTheme(Color themeColor) {
    _themeColor = themeColor;
    _saveThemeColor(themeColor);
    notifyListeners();
  }
}
