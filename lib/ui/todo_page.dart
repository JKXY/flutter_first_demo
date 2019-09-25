import 'package:FlutterDemo/res/strings.dart';
import 'package:FlutterDemo/widget/TodoWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  @override
  createState() => TodoState();
}

class TodoState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.todo)),
      body: _getBody(),
    );
  }

  var todolist = [
    '学习Flutter 自定义widget',
    '读《挪威的森林》',
    '搭建基于MVVM的框架',
    '学习Flutter 自定义widget',
    '读《挪威的森林》',
    '搭建基于MVVM的框架',
    '学习Flutter 自定义widget',
    '读《挪威的森林》',
    '搭建基于MVVM的框架',
    '学习Flutter 自定义widget',
    '读《挪威的森林》',
    '搭建基于MVVM的框架',
    '学习Flutter 自定义widget',
    '读《挪威的森林》',
    '搭建基于MVVM的框架',
    '学习Flutter 自定义widget',
    '读《挪威的森林》',
    '搭建基于MVVM的框架',
    '学习Flutter 自定义widget',
    '读《挪威的森林》',
    '搭建基于MVVM的框架'
  ];

  Widget _getBody() {
    return ListView.builder(
        itemCount: todolist.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 5,right: 5),
            child: TodoWidget(content: todolist[index]),
          );
        });
  }
}
