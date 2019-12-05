import 'dart:convert';

import 'package:FlutterDemo/bean/sisterImageBean.dart';
import 'package:FlutterDemo/res/strings.dart';
import 'package:FlutterDemo/widget/HeroPhotoViewWrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SisterImagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SisterImageState();
}

class SisterImageState extends State<SisterImagePage> {
  var datas = SisterImageBean();
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _refreshData();
    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  var isLoadAll = false;
  var isLoading = false;
  var currPage = 1;

  //滑动到底了自动加载更多
  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 5) {
      if (!isLoadAll) {
        if (!isLoading) {
          setState(() {
            isLoading = true;
            currPage++;
          });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.sister_image),
        actions: <Widget>[
          IconButton(icon: Icon(_getIcon()), onPressed: _updataShow)
        ],
      ),
      body: RefreshIndicator(
          child: StaggeredGridView.countBuilder(
            primary: false,
            itemCount: datas != null && datas.results != null
                ? datas.results.length
                : 0,
            crossAxisCount: 4,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            controller: _scrollController,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Hero(tag: datas.results[index].Id, child: Image.network(datas.results[index].url)),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HeroPhotoViewWrapper(
                        imageTag: datas.results[index].Id,
                        imageProvider: NetworkImage(datas.results[index].url))
                    ),
                  );
                },
              );
            },
            staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
          ),
          onRefresh: _refreshData),
    );
  }

  var isOrderType = false;

  IconData _getIcon() {
    if (isOrderType)
      return Icons.all_inclusive;
    else
      return Icons.av_timer;
  }

  void _updataShow() {
    isOrderType = !isOrderType;
    if (isOrderType) {
      Fluttertoast.showToast(
          msg: Strings.sister_image_order_yes,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: Strings.sister_image_order_no,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    _refreshData();
  }

  Future<Null> _refreshData() async {
    if (!isLoading) {
      isLoading = true;
      currPage = 1;
      isLoadAll = false;
      if (datas.results != null) datas.results.clear();
      await _loadData(currPage);
    }
    return;
  }

  _loadData(int page) async {
    String url;
    if (isOrderType)
      url = "http://gank.io/api/data/福利/20/$page";
    else
      url = "http://gank.io/api/random/data/福利/20";
    print(url);
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        var jsonMap = json.decode(response.body);
        SisterImageBean data = SisterImageBean.fromMap(jsonMap);
        if (data.results != null) {
          if (datas.results != null) {
            datas.results.addAll(data.results);
          } else {
            datas.results = data.results;
          }
        } else {
          isLoadAll = true;
        }
        isLoading = false;
      });
    } else {
      Fluttertoast.showToast(
          msg: Strings.network_error,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
