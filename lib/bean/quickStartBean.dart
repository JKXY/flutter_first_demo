import 'package:flutter/material.dart';

class QuickStartBean {
  String name;
  String path;
  int index;
  IconData icon;

  QuickStartBean({this.name, this.path, this.index, this.icon});

  static QuickStartBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    QuickStartBean pocketBookBean = QuickStartBean();
    pocketBookBean.name = map['name'];
    pocketBookBean.path = map['path'];
    pocketBookBean.index = map['index'];
    return pocketBookBean;
  }

  Map toSaveJson() => {"name": name, "path": path, "index": index};
}
