import 'dart:convert';

import 'package:FlutterDemo/bean/quickStartBean.dart';
import 'package:FlutterDemo/res/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuickStartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QuickStartState();
}

class QuickStartState extends State<QuickStartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.quick_start),
      ),
      body: _getBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    _getSaveQucikStart();
  }

  var currSelect = 0;

  _getBody() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(quickData[index].icon),
            title: Text(quickData[index].name),
            trailing: index == currSelect
                ? Icon(Icons.done)
                : null,
            onTap: (){
              setState(() {
                currSelect = index;
              });
              _saveQuickStart();
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: quickData.length);
  }

  var quickData = [
    QuickStartBean(name: "Nothing", index: 0, icon: Icons.home),
    QuickStartBean(name: "Add Bill Page", path:"/bill",index: 1, icon: Icons.attach_money),
    QuickStartBean(name: "TODO Page", path:"/todo",index: 2, icon: Icons.all_inclusive),
    QuickStartBean(name: "Timer Page", path:"/timer",index: 3, icon: Icons.timer),
  ];

  _saveQuickStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("QuickStart", json.encode(quickData[currSelect].toSaveJson()));
  }

  _getSaveQucikStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    QuickStartBean quickStartPage =
    QuickStartBean(name: "Nothing", index: 0, icon: Icons.home);
    String saveQucik = prefs.getString("QuickStart");
    if (saveQucik != null) {
      quickStartPage = QuickStartBean.fromMap(json.decode(saveQucik));
    }
    currSelect = quickStartPage.index;
    setState(() {});
  }

}
