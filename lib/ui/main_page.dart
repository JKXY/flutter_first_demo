import 'package:FlutterDemo/bean/wanandroidBean.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../res/strings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../ui/theme_page.dart';
import '../ui/webview_page.dart';

class MainPage extends StatefulWidget {
  @override
  createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  ScrollController _scrollController;
  int currPage = 0;
  bool isRefreshing = false;
  bool isLoadingMore = false;
  var _member = new WanandroidBean();
  var _saved = Set<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(Strings.app_name),
          actions: <Widget>[
            IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
          ],
        ),
        body: getBody());
  }

  @override
  void initState() {
    super.initState();
    _loadData(0);
    _scrollController = new ScrollController()..addListener(_scrollListener);
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
        child: GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      childAspectRatio: 1.0,
      children: <Widget>[
        Icon(Icons.ac_unit),
        Icon(Icons.airport_shuttle),
        Icon(Icons.all_inclusive),
        Icon(Icons.beach_access)
      ],
    ));
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return ThemePage();
    }));
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