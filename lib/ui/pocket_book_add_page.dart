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
  @override
  Widget build(BuildContext context) {
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
          decoration: BoxDecoration(color: Colors.grey[300]),
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
  var currentNameIndex = 0;

  Widget _getTypeView() {
    return GridView.builder(
        shrinkWrap: false,
        itemCount: nameList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, //横轴三个子widget
            childAspectRatio: 1.0 //宽高比为1时，子widget
            ),
        itemBuilder: (context, index) {
          return ListTile(
            title: Center(
              child: Column(
                children: <Widget>[
                  Icon(nameIconList[index], color: _typeColor(index)),
                  Text(nameList[index],
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
                  });
                },
              ),
            ),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(_moneyValue,
                        textAlign: TextAlign.end, maxLines: 1)))
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
              return ListTile(
                title: _getNumberRowView(index),
                onTap: () {
                  _numberRowOnClick(index);
                },
              );
            }),
      ],
    );
  }

  Widget _getNumberRowView(int index) {
    if (index == 3) {
      //x
      return Center(
          child: IconButton(
        icon: Icon(Icons.backspace),
      ));
    } else if (index == 15) {
      //保存
      return DecoratedBox(
          decoration: BoxDecoration(color: Colors.red),
          position: DecorationPosition.background,
          child: Center(
            child:
                Text(_numberList[index], style: TextStyle(color: Colors.white)),
          ));
    } else {
      return Center(child: Text(_numberList[index]));
    }
  }

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

        currentNameIndex = 0;
        _typeValue = 2;
        _moneyValue = '0.0';
        _isInput = false;
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
}
