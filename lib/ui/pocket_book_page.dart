import 'package:FlutterDemo/bean/pocketBookBean.dart';
import 'package:FlutterDemo/data/DatabaseHelper.dart';
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
            onPressed: () {
              _toAddPacketPage(
                  "${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}");
            },
          ),
          bottom: 20,
        )
      ],
    );
  }

  void _toAddPacketPage(String time) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            settings: RouteSettings(arguments: time),
            builder: (context) {
              return PocketBookAddPage();
            }))
        .then((isRefresh) {
      _loadData(0);
    });
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
                  "$allMoney",
                  style: TextStyle(
                      fontSize: 30, color: Theme.of(context).primaryColor),
                )),
              )
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(child: Text("${Strings.income}$incomeMoney")),
              Center(child: Text("${Strings.expenditure}$exMoney"))
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
              GestureDetector(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: new Text(
                              _formatDate(pocketBookList[postion].date))),
                      Text(
                          "收:${pocketBookList[postion].income} 支:${pocketBookList[postion].expenditure}")
                    ],
                  ),
                ),
                onTap: () {
                  _toAddPacketPage(pocketBookList[postion].date);
                },
              ),
              getRecordListView(pocketBookList[postion].record)
            ],
          ));
        });
  }

  Widget getRecordListView(List<PocketBookRecord> record) {
    if (record == null || record.length <= 0) {
//      return null;
      return Text("暂无记录");
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
            trailing: Text(
              getRecordStr(record[index].money, record[index].type),
              style: TextStyle(color: getRecordColor(record[index].type)),
            ),
            onTap: () {
              _showDetailDialog(record[index]);
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(height: 1);
        },
      );
    }
  }

  Future _showDetailDialog(PocketBookRecord data) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15.0),
                //bottom: new Radius.circular(20.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        Strings.pcocket_detail,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                      IconButton(
                        alignment: Alignment.center,
                        onPressed: () async {
                          var res = await _showComfrimDialog(data);
                          if (res) {
                            Navigator.of(context).pop();
                            await db.detelePacket(data);
                            _loadData(0);
                          }
                        },
                        icon: Icon(Icons.delete,
                            color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                ),
                Divider(height: 1),
                Padding(
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                  child: Row(
                    children: <Widget>[
                      Text(Strings.money),
                      Expanded(
                          child: Text(
                        getRecordStr(data.money, data.type),
                        textAlign: TextAlign.end,
                        style: TextStyle(color: getRecordColor(data.type)),
                      ))
                    ],
                  ),
                ),
                Divider(height: 1),
                Padding(
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                  child: Row(
                    children: <Widget>[
                      Text(Strings.type),
                      Expanded(
                          child: Text(
                        data.name,
                        textAlign: TextAlign.end,
                      ))
                    ],
                  ),
                ),
                Divider(height: 1),
                Padding(
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                  child: Row(
                    children: <Widget>[
                      Text(Strings.time),
                      Expanded(
                        child: Text(
                          data.date,
                          textAlign: TextAlign.end,
                        ),
                      )
                    ],
                  ),
                ),
                Visibility(
                  child: Divider(height: 1),
                  visible: data.remack.length > 0,
                ),
                Visibility(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                    child: Row(
                      children: <Widget>[
                        Text(Strings.remack),
                        Expanded(
                          child: Text(
                            data.remack,
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),
                  ),
                  visible: data.remack.length > 0,
                ),
              ],
            ),
          );
        });
  }

  Future<bool> _showComfrimDialog(PocketBookRecord data) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              Strings.tips,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            content: Text(Strings.pcocket_delete_tips),
            actions: <Widget>[
              FlatButton(
                  child: Text(Strings.cancle),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  }),
              FlatButton(
                child: Text(Strings.comfirm),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  Color getRecordColor(int type) {
    if (type == 1)
      return Colors.green;
    else
      return Theme.of(context).primaryColor;
  }

  String _formatDate(String date) {
    var dateList = date.split('.');
    if (dateList.length == 3) {
      var time = DateTime.now();
      if (time.year == int.tryParse(dateList[0])) {
        if (time.month == int.tryParse(dateList[1]) &&
            time.day - int.tryParse(dateList[2]) < 3) {
          var diff = time.day - int.tryParse(dateList[2]);
          if (diff == 0) {
            return "${dateList[1]}.${dateList[2]} 今天";
          } else if (diff == 1) {
            return "${dateList[1]}.${dateList[2]} 昨天";
          } else if (diff == 2) {
            return "${dateList[1]}.${dateList[2]} 前天";
          } else {
            return "${dateList[1]}.${dateList[2]}";
          }
        } else {
          return "${dateList[1]}.${dateList[2]}";
        }
      } else {
        return date;
      }
    } else {
      return date;
    }
  }

  String getRecordStr(String text, int type) {
    if (type == 1)
      return "+$text";
    else
      return "-$text";
  }

  var db = PocketDatabaseHelper();

  var allMoney = 0.00;
  var incomeMoney = 0.00;
  var exMoney = 0.00;

  _loadData(int page) async {
//    String jsonStr = await _loadAsset();
    var data = await db.getTotalList(page);
    pocketBookList = data.list;
    allMoney = 0.00;
    incomeMoney = 0.00;
    exMoney = 0.00;
    data.list.forEach((item) {
      incomeMoney += double.tryParse(item.income);
      exMoney += double.tryParse(item.expenditure);
    });
    allMoney = incomeMoney - exMoney;
    setState(() {
//      pocketBookList = new PocketBookList.fromJson(json.decode(jsonStr)).list;
    });
  }

  Future<String> _loadAsset() async {
    return await DefaultAssetBundle.of(context)
        .loadString('lib/data/pocketBook.json');
  }
}
