import 'dart:convert';

import 'package:FlutterDemo/bean/quickStartBean.dart';
import 'package:FlutterDemo/bean/wanandroidBean.dart';
import 'package:FlutterDemo/res/fonts/AntdIcons.dart';
import 'package:FlutterDemo/ui/quick_start_page.dart';
import 'package:FlutterDemo/ui/sister_image_page.dart';
import 'package:FlutterDemo/ui/timer_page.dart';
import 'package:FlutterDemo/ui/todo_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../res/strings.dart';
import '../ui/pocket_book_page.dart';
import '../ui/theme_page.dart';
import '../ui/webview_page.dart';

class MainPage extends StatefulWidget {
  @override
  createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  var _scaffoldkey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController;
  int currPage = 0;
  bool isRefreshing = false;
  bool isLoadingMore = false;
  var _member = new WanandroidBean();
  var _saved = Set<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          title: const Text(Strings.app_name),
        ),
        drawer: _getDrawer(),
        body: getBody());
  }

  @override
  void initState() {
    super.initState();
    _QucikStart();
    _loadData(0);
    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  _QucikStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    QuickStartBean quickStartPage =
        QuickStartBean(name: "无", index: 0, icon: Icons.home);
    String saveQucik = prefs.getString("QuickStart");
    if (saveQucik != null) {
      quickStartPage = QuickStartBean.fromMap(json.decode(saveQucik));
    }
    if (quickStartPage.index > 0) {
      Navigator.of(context).pushNamed(quickStartPage.path);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  //滑动到底了自动加载更多
  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 2) {
      if (_member.data != null && _member.data.pageCount - 1 > currPage) {
        if (!isLoadingMore) {
          isLoadingMore = true;
          currPage++;
          _loadData(currPage);
        }
      } else {
        Fluttertoast.showToast(
            msg: Strings.loadAllTip,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  Widget getBody() {
    return new RefreshIndicator(
      onRefresh: _refreshData,
      child: getContent(),
    );
  }

  Future<Null> _refreshData() async {
    if (!isRefreshing) {
      isRefreshing = true;
      currPage = 0;
      _loadData(currPage);
    }
    return;
  }

  showLoadingDialog() {
    return _member.data == null || _member.data.datas == null;
  }

  Widget getContent() {
    if (showLoadingDialog()) {
      return new Center(child: new CircularProgressIndicator());
    } else {
      return new Column(
        children: <Widget>[
          HandleView(),
          Expanded(
            child: getListView(),
          )
        ],
      );
    }
  }

  Widget getListView() {
    return new ListView.builder(
      itemCount: _member.data.datas.length * 2,
      itemBuilder: (BuildContext context, int position) {
        if (position.isOdd)
          return Divider();
        else
          return _buildRow(position ~/ 2);
      },
      controller: _scrollController,
    );
  }

  Widget HandleView() {
    return new Card(
        elevation: 15,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
        margin: EdgeInsets.all(8),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          childAspectRatio: 1.0,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.attach_money,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: _toPocketBookPage,
            ),
            IconButton(
              icon: Icon(AntdIcons.scan, color: Theme.of(context).primaryColor),
              onPressed: _parseQrcode,
            ),
            IconButton(
              icon: Icon(Icons.all_inclusive,
                  color: Theme.of(context).primaryColor),
              onPressed: _toTodoPage,
            ),
            IconButton(
              icon: Icon(Icons.timer, color: Theme.of(context).primaryColor),
              onPressed: _toTimerPage,
            )
          ],
        ));
  }

  void _toPocketBookPage() {
    Navigator.of(context)
        .push(new CupertinoPageRoute(builder: (BuildContext context) {
      return PocaketBookPage();
    }));
  }

  void _toTodoPage() {
    Navigator.of(context)
        .push(new CupertinoPageRoute(builder: (BuildContext context) {
      return TodoPage();
    }));
  }

  void _toTimerPage() {
    Navigator.of(context)
        .push(new CupertinoPageRoute(builder: (BuildContext context) {
      return TimerPage();
    }));
  }

  Future _parseQrcode() async {
    var res = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", Strings.cancle, true, ScanMode.DEFAULT);
    if (res != null && res != "-1") {
      var snackBar = SnackBar(
        content: new Text("$res"),
        action: new SnackBarAction(
            label: Strings.copy,
            onPressed: () {
              Clipboard.setData(new ClipboardData(text: res));
            }),
      );
      _scaffoldkey.currentState.showSnackBar(snackBar);
    }
  }

  void _toThemePage() {
    Navigator.of(context)
        .push(new CupertinoPageRoute(builder: (BuildContext context) {
      return ThemePage();
    }));
  }

  void _toQuickStartPage() {
    Navigator.of(context)
        .push(new CupertinoPageRoute(builder: (BuildContext context) {
      return QuickStartPage();
    }));
  }

  void _toSisterImagePage() {
    Navigator.of(context)
        .push(new CupertinoPageRoute(builder: (BuildContext context) {
      return SisterImagePage();
    }));
  }

  Widget _getDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: 60.0,
                    height: 60.0,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("lib/res/images/logo_s.png"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(Strings.my_name,
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  )
                ],
              ),
            ),
          ),
          ListTile(
              leading: Icon(Icons.color_lens),
              title: Text(Strings.theme),
              onTap: () {
                Navigator.of(context).pop();
                _toThemePage();
              }),
          ListTile(
              leading: Icon(Icons.flight_takeoff),
              title: Text(Strings.quick_start),
              onTap: () {
                Navigator.of(context).pop();
                _toQuickStartPage();
              }),
          ListTile(
              leading: Icon(Icons.pregnant_woman),
              title: Text(Strings.sister_image),
              onTap: () {
                Navigator.of(context).pop();
                _toSisterImagePage();
              }),
        ],
      ),
    );
  }

  Widget _buildRow(int i) {
    bool isSave = _saved.contains("${_member.data.datas[i].id}");
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: new Text("${_member.data.datas[i].title}"),
          subtitle: new Text("${_member.data.datas[i].author}"),
//          leading: new CircleAvatar(
//            backgroundColor: Colors.white,
//            foregroundColor: Colors.green,
//            backgroundImage: new NetworkImage("${_member.data.datas[i].id}"),
//          ),
          trailing: new IconButton(
            icon: new Icon(
              isSave ? Icons.favorite : Icons.favorite_border,
              color: isSave ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                if (isSave)
                  _saved.remove("${_member.data.datas[i].id}");
                else
                  _saved.add("${_member.data.datas[i].id}");
              });
            },
          ),
          onTap: () {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (BuildContext context) {
              return WebViewPage(
                  _member.data.datas[i].title, _member.data.datas[i].link);
            }));
          },
        ));
  }

  _loadData(int page) async {
    String url = "https://www.wanandroid.com/article/list/$page/json";
    http.Response response = await http.get(url);
    setState(() {
      var jsonMap = json.decode(response.body);
      WanandroidBean data = WanandroidBean.fromMap(jsonMap);
      if (page == 0) {
        _member = data;
        isRefreshing = false;
      } else {
        isLoadingMore = false;
        if (data.data != null && data.data.datas != null) {
          _member.data.datas.addAll(data.data.datas);
        }
      }
    });
  }
}
