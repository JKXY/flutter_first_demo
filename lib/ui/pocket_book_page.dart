import 'package:FlutterDemo/bean/pocketBookBean.dart';
import 'package:FlutterDemo/res/strings.dart';
import 'package:FlutterDemo/ui/pocket_book_add_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class PocaketBookPage extends StatefulWidget {
  @override
  createState() => PocaketBookState();
}

class PocaketBookState extends State<PocaketBookPage> {
  var pocketBookList = new List<PocketBookBean>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: const Text(Strings.pcocketBook),
      ),
      body: getBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData(0);
  }

  Widget getBody() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[HandleView(), Expanded(child: getListView())],
        ),
        Positioned(
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: _toAddPage,
          ),
          bottom: 20,
        )
      ],
    );
  }

  void _toAddPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return PocketBookAddPage();
    }));
  }

  Widget HandleView() {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(Strings.allMoney),
              Expanded(
                child: Center(
                    child: Text(
                  "0.00",
                  style: TextStyle(fontSize: 30, color: Colors.red),
                )),
              )
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(child: Text(Strings.income)),
              Center(child: Text(Strings.expenditure))
            ],
          )
        ],
      ),
    ));
  }

  Widget getListView() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: pocketBookList.length,
        itemBuilder: (BuildContext context, int postion) {
          return Card(
              child: Column(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0),
                child: Row(
                  children: <Widget>[
                    Expanded(child: new Text(pocketBookList[postion].date)),
                    Text(
                        "收:${pocketBookList[postion].income} 支:${pocketBookList[postion].expenditure}")
                  ],
                ),
              ),
              getRecordListView(pocketBookList[postion].record)
            ],
          ));
        });
  }

  Widget getRecordListView(List<PocketBookRecord> record) {
    if (record == null || record.length <= 0) {
      return null;
    } else {
      return ListView.separated(
        padding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: record.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: new Row(
                children: <Widget>[
                  Icon(
                    Icons.brightness_1,
                    color: getRecordColor(record[index].type),
                    size: 5,
                  ),
                  Text(
                    "  ${record[index].name}",
                  )
                ],
              ),
              trailing: new Text(
                getRecordStr(record[index].money, record[index].type),
                style: TextStyle(color: getRecordColor(record[index].type)),
              ));
        },
        separatorBuilder: (context, index) {
          return Divider(height: 1);
        },
      );
    }
  }

  Color getRecordColor(int type) {
    if (type == 1)
      return Colors.green;
    else
      return Colors.red;
  }

  String getRecordStr(double text, int type) {
    if (type == 1)
      return "+$text";
    else
      return "-$text";
  }

  _loadData(int page) async {
    String jsonStr = await _loadAsset();
    setState(() {
      pocketBookList = new PocketBookList.fromJson(json.decode(jsonStr)).list;
    });
  }

  Future<String> _loadAsset() async {
    return await DefaultAssetBundle.of(context)
        .loadString('lib/data/pocketBook.json');
  }
}
