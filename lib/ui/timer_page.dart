import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:FlutterDemo/bean/timerTemplateBean.dart';
import 'package:FlutterDemo/res/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TimerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TimerState();
}

enum TimerStatus { SELECT, TIMER }

class TimerState extends State<TimerPage> {
  var _hourController = FixedExtentScrollController();
  var _minuteController = FixedExtentScrollController();
  var _secondController = FixedExtentScrollController();

  var _status = TimerStatus.SELECT;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(title: Text(Strings.timer)),
        body: _bodyView(),
      ),
      onWillPop: () async {
        if (_status == TimerStatus.SELECT ||
            (_status == TimerStatus.TIMER && isTime)) {
          return true;
        } else {
          _showTimberDialog();
          return false;
        }
      },
    );
  }

  _bodyView() {
    if (_status == TimerStatus.SELECT) {
      return _getSelectView();
    } else if (_status == TimerStatus.TIMER) {
      return _countDownView();
    }
  }

  _getSelectView() {
    return Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Center(child: Text(Strings.hour)),
                    )),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Center(child: Text(Strings.minute)),
                    )),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Center(child: Text(Strings.second)),
                    )),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: CupertinoPicker(
                        scrollController: _hourController,
                        backgroundColor: Colors.transparent,
                        itemExtent: 32,
                        onSelectedItemChanged: null,
                        looping: true,
                        squeeze: 1,
                        children: List.generate(99, (index) {
                          return Center(child: Text("${index}"));
                        })),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: CupertinoPicker(
                        scrollController: _minuteController,
                        backgroundColor: Colors.transparent,
                        itemExtent: 32,
                        onSelectedItemChanged: null,
                        looping: true,
                        squeeze: 1,
                        children: List.generate(60, (index) {
                          return Center(child: Text("$index"));
                        })),
                  ),
                ),
                Expanded(
                    child: SizedBox(
                      height: 200,
                      child: CupertinoPicker(
                          scrollController: _secondController,
                          backgroundColor: Colors.transparent,
                          itemExtent: 32,
                          onSelectedItemChanged: null,
                          looping: true,
                          squeeze: 1,
                          children: List.generate(60, (index) {
                            return Center(child: Text("$index"));
                          })),
                    ))
              ],
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                  itemExtent: 85,
                  itemCount: templateData.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Container(
                          margin: EdgeInsets.all(8),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text("${templateData[index].name}",
                                    style: TextStyle(color: Colors.white)),
                                Text("${_getSelectDateFormat(index)}",
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: currTemplate == index
                                  ? Theme
                                  .of(context)
                                  .primaryColor
                                  : (Theme
                                  .of(context)
                                  .brightness == Brightness.dark
                                  ? Colors.white10
                                  : Colors.grey[400]),
                              shape: BoxShape.circle)),
                      onTap: () {
                        setState(() {
                          _updataTimerView(index);
                          currTemplate = index;
                        });
                      },
                    );
                  }),
            ),
            Container(
              height: 80,
              alignment: Alignment.center,
              child: FlatButton(
                onPressed: () {
                  _updataCurrTemplate();
                  int second = _hourController.selectedItem * 60 * 60 +
                      _minuteController.selectedItem * 60 +
                      _secondController.selectedItem;
                  if (second > 0) {
                    setState(() {
                      _status = TimerStatus.TIMER;
                      _startTimer(second, 0);
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: Strings.timer_error_tip,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
                child: Text(
                  Strings.start,
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
              ),
            )
          ],
        ));
  }

  _countDownView() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 40),
          Container(
            height: 260,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  height: 220,
                  width: 220,
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    backgroundColor: Theme
                        .of(context)
                        .textSelectionColor,
                    value: _oldSecond / _currSecond,
                  ),
                ),
                Visibility(
                    visible: !isTime,
                    child: Text("${_getDateFormat(_dateTime)}",
                        style: TextStyle(fontSize: 45))),
                Visibility(
                    visible: isTime,
                    child: Icon(
                      Icons.done,
                      size: 50,
                      color: Colors.green,
                    )),
                Positioned(
                    top: 80,
                    child: Text(
                        "${currTemplate == -1 ? "" : templateData[currTemplate]
                            .name}"))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: !isTime,
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      if (isPause) {
                        _startTimer(_currSecond, _oldSecond);
                        isPause = false;
                      } else {
                        _timer.cancel();
                        isPause = true;
                      }
                    });
                  },
                  child: Text(
                    isPause ? Strings.goon : Strings.pause,
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                ),
              ),
              Visibility(
                  visible: !isTime, child: SizedBox(width: 60, height: 120)),
              Visibility(
                  visible: isTime, child: SizedBox(width: 0, height: 120)),
              FlatButton(
                onPressed: () {
                  setState(() {
                    FlutterRingtonePlayer.stop();
                    isTime = false;
                    isPause = false;
                    _status = TimerStatus.SELECT;
                    currTemplate = -1;
                    _timer.cancel();
                  });
                },
                child: Text(
                  isTime ? Strings.ok : Strings.cancle,
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> _showTimberDialog() {
    return showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(Strings.tips),
            content: Text(Strings.timer_tip),
            actions: <Widget>[
              FlatButton(
                child: Text(Strings.cancle),
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(Strings.comfirm),
                onPressed: () async {
                  _addNotification(_currSecond - _oldSecond);
                  Navigator.pop(context);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Timer _timer;
  int _currSecond = 0;
  int _oldSecond = 0;
  DateTime _dateTime;
  bool isPause = false;
  bool isTime = false;

  _startTimer(int second, int oldSecond) {
    _currSecond = second;
    oldSecond += 1; //启动需要1s,所以要-1s
    _oldSecond = oldSecond;
    _dateTime =
        DateTime.fromMillisecondsSinceEpoch(second * 1000 - oldSecond * 1000,isUtc: true);
    _timer = Timer.periodic(Duration(seconds: 1), (timber) {
      _oldSecond++;
      if (_oldSecond >= second) {
        timber.cancel();
        isTime = true;
        FlutterRingtonePlayer.playAlarm(looping: true);
      } else {
        _dateTime = _dateTime.subtract(Duration(seconds: 1));
      }
      setState(() {});
    });
  }

  _getSelectDateFormat(int index) {
    int second = templateData[index].hour * 60 * 60 +
        templateData[index].minute * 60 +
        templateData[index].second;
    if (second <= 0) return "00:00";
    var dateTime = DateTime.fromMillisecondsSinceEpoch(second * 1000,isUtc: true);
    if (dateTime.hour > 0) {
      return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute
          .toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(
          2, '0')}";
    } else {
      return "${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second
          .toString().padLeft(2, '0')}";
    }
  }

  _getDateFormat(DateTime dateTime) {
    if (dateTime == null)
      return "00:00:00";
    else
      return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute
          .toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(
          2, '0')}";
  }

  _updataTimerView(int index) {
    if (_hourController != null &&
        _hourController.selectedItem != templateData[index].hour) {
      _hourController.animateToItem(templateData[index].hour,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
    }
    if (_minuteController != null &&
        _minuteController.selectedItem != templateData[index].minute) {
      _minuteController.animateToItem(templateData[index].minute,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
    }
    if (_secondController != null &&
        _secondController.selectedItem != templateData[index].second) {
      _secondController.animateToItem(templateData[index].second,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
    }
  }

  _updataCurrTemplate() {
    if (currTemplate >= 0 &&
        currTemplate < templateData.length &&
        _hourController.selectedItem == templateData[currTemplate].hour &&
        _minuteController.selectedItem == templateData[currTemplate].minute &&
        _secondController.selectedItem ==
            templateData[currTemplate].second) {} else {
      currTemplate = -1;
    }
  }

  var currTemplate = -1;
  var templateData = [
    TimerTemplateBean(name: "午睡", minute: 30),
    TimerTemplateBean(name: "敷面膜", minute: 15),
    TimerTemplateBean(name: "洗衣服", minute: 45),
    TimerTemplateBean(name: "泡面", minute: 3),
    TimerTemplateBean(name: "泡脚", minute: 30),
    TimerTemplateBean(name: "刷牙", minute: 3),
    TimerTemplateBean(name: "煮饭", minute: 30)
  ];

  _addNotification(int second) async {
    var scheduledNotificationDateTime =
    new DateTime.now().add(new Duration(seconds: second));
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '0', 'Timber', 'Timer time is up notification',
        importance: Importance.Max, priority: Priority.High, ticker: 'Timber');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        Random().nextInt(10000),
        Strings.app_name,
        "${_getNotificationContent()} Timer time is up !",
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload: 'timer',
        androidAllowWhileIdle: true);
  }

  _getNotificationContent() {
    var temp = "";
    if (currTemplate >= 0 && currTemplate < templateData.length) {
      temp = "[ ${templateData[currTemplate].name} ]";
    } else {
      temp = "[ ${_getDateFormat(DateTime.fromMillisecondsSinceEpoch(_currSecond * 1000,isUtc: true))} ]";
    }
    return temp;
  }

  @override
  void dispose() {
    _timer?.cancel();
    FlutterRingtonePlayer.stop();
    _hourController?.dispose();
    _minuteController?.dispose();
    _secondController?.dispose();
    super.dispose();
  }
}
