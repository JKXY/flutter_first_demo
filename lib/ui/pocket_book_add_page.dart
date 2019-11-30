import 'package:FlutterDemo/bean/pocketBookBean.dart';
import 'package:FlutterDemo/data/DatabaseHelper.dart';
import 'package:FlutterDemo/res/fonts/AntdIcons.dart';
import 'package:FlutterDemo/res/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PocketBookAddPage extends StatefulWidget {
  @override
  createState() => PocketBookAddState();
}

class PocketBookAddState extends State<PocketBookAddPage> {
  String currTimeStr;

  @override
  Widget build(BuildContext context) {
    if (currTimeStr == null)
      currTimeStr = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.pcocketBookAdd),
        ),
        body: _getBody());
  }

  Widget _getBody() {
    return Column(
      children: <Widget>[
        Expanded(
            child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.grey[100]),
          position: DecorationPosition.background,
          child: _getTypeView(),
        )),
        _getNumberView()
      ],
    );
  }

  var nameList = [
    "三餐",
    "零食",
    "衣服",
    "交通",
    "旅行",
    "话费",
    "学习",
    "住房",
    "医疗",
    "日用品",
    "红包",
    "娱乐",
    "请客",
    "电器",
    "其他"
  ];
  var nameIconList = [
    Icons.local_dining,
    AntdIcons.monitor,
    AntdIcons.skin,
    Icons.directions_bus,
    Icons.flight,
    Icons.language,
    Icons.school,
    Icons.domain,
    AntdIcons.medicinebox,
    AntdIcons.rest,
    AntdIcons.red_envelope,
    Icons.music_video,
    Icons.group,
    Icons.phone_android,
    Icons.widgets
  ];

  var incomeNameList = ["工资", "奖金", "红包", "投资", "外快", "其他"];
  var incomeIconList = [
    Icons.attach_money,
    AntdIcons.money_collect,
    AntdIcons.red_envelope,
    AntdIcons.trophy,
    Icons.child_friendly,
    Icons.widgets
  ];

  var currentNameIndex = 0;

  Widget _getTypeView() {
    return GridView.builder(
        shrinkWrap: false,
        itemCount: _typeValue == 2 ? nameList.length : incomeNameList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, //横轴三个子widget
            childAspectRatio: 1.0 //宽高比为1时，子widget
            ),
        itemBuilder: (context, index) {
          return ListTile(
            title: Center(
              child: Column(
                children: <Widget>[
                  Icon(
                      _typeValue == 2
                          ? nameIconList[index]
                          : incomeIconList[index],
                      color: _typeColor(index)),
                  Text(
                      _typeValue == 2 ? nameList[index] : incomeNameList[index],
                      style: TextStyle(color: _typeColor(index), fontSize: 10))
                ],
              ),
            ),
            onTap: () {
              setState(() {
                currentNameIndex = index;
              });
            },
          );
        });
  }

  Color _typeColor(int index) {
    if (currentNameIndex == index)
      return Theme.of(context).primaryColor;
    else
      return Colors.blueGrey;
  }

  int _typeValue = 2;
  String _moneyValue = '0.0';
  var _numberList = [
    '1',
    '2',
    '3',
    'X',
    '4',
    '5',
    '6',
    '清零',
    '7',
    '8',
    '9',
    '再记',
    '+',
    '0',
    ".",
    "保存"
  ];

  Future<DateTime> _showDatePicker() {
    var date = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(date.year - 100),
      lastDate: date,
    );
  }

  var remackStr = "";
  TextEditingController _remackController = TextEditingController();

  Future<String> _showRemackDialog() {
    return showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(Strings.remack),
            content: TextField(
              autofocus: true,
              maxLines: 1,
              controller: _remackController,
              decoration: InputDecoration(
                hintText: Strings.remack_dialog_hint,
                border: InputBorder.none,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(Strings.comfirm),
                onPressed: () async {
                  var remack = _remackController.text.trim();
                  Navigator.of(context).pop(remack);
                },
              ),
            ],
          );
        });
  }

  Widget _getNumberView() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.tightFor(width: 120.0, height: 50.0),
              child: RadioListTile<int>(
                value: 2,
                dense: true,
                title: Text('支出'),
                groupValue: _typeValue,
                onChanged: (value) {
                  setState(() {
                    _typeValue = value;
                    currentNameIndex = 0;
                  });
                },
              ),
            ),
            Container(
              constraints: BoxConstraints.tightFor(width: 120.0, height: 50.0),
              child: RadioListTile<int>(
                value: 1,
                dense: true,
                title: Text('收入'),
                groupValue: _typeValue,
                onChanged: (value) {
                  setState(() {
                    _typeValue = value;
                    currentNameIndex = 0;
                  });
                },
              ),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(8),
              child: GestureDetector(
                child: Text(
                  remackStr.trim().length > 0 ? remackStr : Strings.remack_hint,
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () async {
                  remackStr = await _showRemackDialog();
                  setState(() {});
                },
              ),
            ))
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20),
              height: 30,
              child: OutlineButton(
//                splashColor: Colors.grey,
                child: Text(
                  currTimeStr,
                  style: TextStyle(fontSize: 16),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                onPressed: () async {
                  var selectTime = await _showDatePicker();
                  setState(() {
                    currTimeStr =
                        "${selectTime.year}.${selectTime.month}.${selectTime.day}";
                  });
                },
              ),
            ),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(_moneyValue,
                        style: TextStyle(
                            fontSize: 22,
                            color: Theme.of(context).primaryColor),
                        textAlign: TextAlign.end,
                        maxLines: 1)))
          ],
        ),
        GridView.builder(
            shrinkWrap: true,
            itemCount: _numberList.length,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, //横轴三个子widget
                childAspectRatio: 2,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1),
            itemBuilder: (context, index) {
              return FlatButton(
                color: index == 15 ? Theme.of(context).primaryColor : null,
                child: _getNumberRowView(index),
                onPressed: () {
                  _numberRowOnClick(index);
                },
              );
            }),
      ],
    );
  }

  bool isSaveing = false;

  Widget _getNumberRowView(int index) {
    if (index == 3) {
      //x
      return Icon(Icons.backspace);
    } else if (index == 15) {
      //保存
      if (isSaveing) {
        return SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(Colors.white)),
        );
      } else {
        return Text(
          _numberList[index],
          style: TextStyle(
            color: Colors.white,
          ),
        );
      }
    } else {
      return Text(_numberList[index]);
    }
  }

  var db = PocketDatabaseHelper();

  var _isInput = false;

  _numberRowOnClick(int index) {
    switch (index) {
      case 3: //x
        if (_moneyValue.length <= 1) {
          _moneyValue = '0.0';
          _isInput = false;
        } else {
          _moneyValue = _moneyValue.substring(0, _moneyValue.length - 1);
        }
        break;
      case 7: //清零
        _moneyValue = '0.0';
        _isInput = false;
        break;
      case 11: //再记(注意+)
        var record = PocketBookRecord();
        if (_moneyValue.contains('+')) {
          if (_moneyValue.endsWith('+')) {
            _moneyValue = _moneyValue.replaceAll('+', '');
          } else {
            var temp = _moneyValue.split('+');
            var count = double.tryParse(temp[0]) + double.tryParse(temp[1]);
            _moneyValue = count.toStringAsFixed(2);
          }
        }
        if (double.tryParse(_moneyValue) > 0) {
          record.money = _moneyValue;
          record.type = _typeValue;
          record.name = _typeValue == 2
              ? nameList[currentNameIndex]
              : incomeNameList[currentNameIndex];
          var date = currTimeStr;
          record.date = date;
          record.remack = remackStr;
          _saveData(record, false);
          //复位
          currentNameIndex = 0;
//        _typeValue = 2;
          _moneyValue = '0.0';
          _isInput = false;
          remackStr = "";
        } else {
          Fluttertoast.showToast(
              msg: Strings.pcocket_number_error_tip,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        break;
      case 12: //+
        if (_isInput && !_moneyValue.endsWith('+')) {
          if (_moneyValue.contains('+')) {
            var temp = _moneyValue.split('+');
            var count = double.tryParse(temp[0]) + double.tryParse(temp[1]);
            _moneyValue = count.toStringAsFixed(2);
          }
          _moneyValue = "$_moneyValue\+";
        }
        break;
      case 14: //.
        if (_isInput && !_moneyValue.endsWith('+')) {
          if (_moneyValue.contains('+')) {
            var temp = _moneyValue.split('+');
            if (!temp[1].contains('.')) {
              _moneyValue = "$_moneyValue\.";
            }
          } else {
            if (!_moneyValue.contains('.')) {
              _moneyValue = "$_moneyValue\.";
            }
          }
        }
        break;
      case 15: //保存(注意+)
        var record = PocketBookRecord();
        if (_moneyValue.contains('+')) {
          if (_moneyValue.endsWith('+')) {
            _moneyValue = _moneyValue.replaceAll('+', '');
          } else {
            var temp = _moneyValue.split('+');
            var count = double.tryParse(temp[0]) + double.tryParse(temp[1]);
            _moneyValue = count.toStringAsFixed(2);
          }
        }
        if (double.tryParse(_moneyValue) > 0) {
          record.money = _moneyValue;
          record.type = _typeValue;
          record.name = _typeValue == 2
              ? nameList[currentNameIndex]
              : incomeNameList[currentNameIndex];
          var date = currTimeStr;
          record.remack = remackStr;
          record.date = date;
          _saveData(record, true);
        } else {
          Fluttertoast.showToast(
              msg: Strings.pcocket_number_error_tip,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }

        break;
      default: //数字
        if (_moneyValue.length >= 14) {
          Fluttertoast.showToast(
              msg: Strings.moneyLangeError,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          if (_isInput) {
            if (_moneyValue.contains('+') && !_moneyValue.endsWith('+')) {
              var temp1 = _moneyValue.split('+');
              var temp = temp1[temp1.length - 1].split('.');
              if (temp.length <= 1 || temp[temp.length - 1].length < 2) {
                _moneyValue = "$_moneyValue${_numberList[index]}";
              }
            } else {
              _moneyValue = "$_moneyValue${_numberList[index]}";
            }
          } else {
            _isInput = true;
            _moneyValue = "${_numberList[index]}";
          }
        }
        break;
    }
    setState(() {});
  }

  _saveData(PocketBookRecord data, bool isBack) async {
    if (isBack) {
      setState(() {
        isSaveing = true;
      });
    }
    await db.saveItem(data);
    if (isBack) {
      setState(() {
        isSaveing = false;
      });
    }
    if (isBack) Navigator.of(context).pop(true);
  }

  @override
  void dispose() {
    super.dispose();
//    db.close();
  }
}
