import 'package:FlutterDemo/bean/todoBean.dart';
import 'package:FlutterDemo/data/DatabaseHelper.dart';
import 'package:FlutterDemo/res/strings.dart';
import 'package:FlutterDemo/widget/TodoWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TodoPage extends StatefulWidget {
  @override
  createState() => TodoState();
}

class TodoState extends State<TodoPage> {
  List<TodoBean> list = [];
  var db = PocketDatabaseHelper();
  var isShowComplet = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.todo),
        actions: <Widget>[
          IconButton(icon: Icon(_getIcon()), onPressed: _updataShow)
        ],
      ),
      body: _getBody(),
    );
  }

  IconData _getIcon() {
    if (isShowComplet)
      return Icons.cloud_off;
    else
      return Icons.cloud_queue;
  }

  void _updataShow() {
    isShowComplet = !isShowComplet;
    _loadData();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Widget _getBody() {
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: TodoWidget(
                    onChanged: (stateVal) {
                      if (stateVal) {
                        list[index].type = 1;
                      } else {
                        list[index].type = 2;
                      }
                      db.updataTodoItem(list[index]);
                    },
                    switchValue: list[index].type == 1,
                    content: list[index].name),
              );
            }),
        Positioned(
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              //弹出对话框并等待其关闭
              bool save = await addDialog();
              if (save == null) {
                print("取消");
              } else {
                print("已确认");
                _loadData();
              }
            },
          ),
          bottom: 20,
          right: 20,
        ),
      ],
    );
  }

  TextEditingController _todoController = TextEditingController();

  Future<bool> addDialog() {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Todo"),
            content: TextField(
              autofocus: true,
              maxLines: 1,
              maxLength: 20,
              decoration: InputDecoration(
                hintText: Strings.todo_tip,
                border: InputBorder.none,
              ),
              controller: _todoController,
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text("取消"),
                  onPressed: () {
                    Navigator.of(context).pop(); //关闭对话框
                    _todoController.clear();
                  }),
              FlatButton(
                child: Text("添加"),
                onPressed: () {
                  var todo = _todoController.text;
                  if (todo != null && todo.trim().length > 0) {
                    var bean = TodoBean();
                    bean.type = 2;
                    bean.name = todo.trim();
                    bean.date = DateTime.now().toIso8601String();
                    db.saveTodoItem(bean);
                    Navigator.of(context).pop(true); //关闭对话框
                    _todoController.clear();
                  } else {
                    Fluttertoast.showToast(
                        msg: Strings.todo_tip,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              ),
            ],
          );
        });
  }

  /**
   * tips FIXME: https://github.com/flutter/flutter/issues/42142
   */
  _loadData() async {
    var data = await db.getTodoList(isShowComplet);
    setState(() {
      list.clear();
      list.addAll(data.list);
    });
  }
}
