import 'package:flutter/material.dart';
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


  var _theme = [Colors.blue,Colors.green,Colors.grey,Colors.purple,Colors.yellow,Colors.red];

  Widget _buildThemeRow(int i) {
    return ListTile(
      title: new Text("主题", style: TextStyle(color: _theme[i])),
      leading: new Icon(Icons.fiber_manual_record, color: _theme[i]),
      onTap: () {
        setState(() {
          Provider.of<AppInfoProvider>(context).setTheme(_theme[i]);
        });
      },
    );
  }
}


class AppInfoProvider with ChangeNotifier {
  MaterialColor _themeColor = Colors.blue;

  MaterialColor get themeColor => _themeColor;

  setTheme(MaterialColor themeColor) {
    _themeColor = themeColor;
    notifyListeners();
  }
}
