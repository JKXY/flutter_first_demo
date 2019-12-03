import 'package:FlutterDemo/bean/timerTemplateBean.dart';
import 'package:FlutterDemo/res/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TimerState();
}

class TimerState extends State<TimerPage> {
  var _hourController = FixedExtentScrollController();
  var _minuteController = FixedExtentScrollController();
  var _secondController = FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  _afterLayout(_) {
    setState(() {
      _updataTimerView(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.timer)),
      body: _getBody(),
    );
  }

  _getBody() {
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
                      return Center(child: Text("${index}"));
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
                    return Center(child: Text("${index}"));
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
                            Text(
                                "${templateData[index].hour}:${templateData[index].minute}:${templateData[index].second}",
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: currTemplate == index
                              ? Theme.of(context).primaryColor
                              : (Theme.of(context).brightness == Brightness.dark
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
            onPressed: () {},
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

  _updataTimerView(int index) {
    if (_hourController.selectedItem != templateData[index].hour) {
      _hourController.animateToItem(templateData[index].hour,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
    }
    if (_minuteController.selectedItem != templateData[index].minute) {
      _minuteController.animateToItem(templateData[index].minute,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
    }
    if (_secondController.selectedItem != templateData[index].second) {
      _secondController.animateToItem(templateData[index].second,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
    }
  }

  var currTemplate = 0;
  var templateData = [
    TimerTemplateBean(name: "午睡", minute: 30),
    TimerTemplateBean(name: "敷面膜", minute: 15),
    TimerTemplateBean(name: "泡面", minute: 3),
    TimerTemplateBean(name: "泡脚", minute: 30),
    TimerTemplateBean(name: "洗衣服", minute: 45),
    TimerTemplateBean(name: "刷牙", minute: 3),
    TimerTemplateBean(name: "煮饭", minute: 30),
    TimerTemplateBean(name: "泡面", minute: 3)
  ];

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _secondController.dispose();
    super.dispose();
  }
}
