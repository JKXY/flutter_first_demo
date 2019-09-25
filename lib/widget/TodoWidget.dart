import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoWidget extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  bool defaultSwitchValue = false;
  String content = "";
  double marginVal = 0;

  TodoWidget({this.defaultSwitchValue = false, this.content = "",this.onChanged});

  @override
  createState() => TodoWidgetState();
}

class TodoWidgetState extends State<TodoWidget> {
  GlobalKey _myKey = new GlobalKey();
  String showText = "";
  String switchText = "N";
  Color color = Colors.red[300];

  @override
  void initState() {
    super.initState();
    _getText();
  }

  String _getText() {
    if (this.widget.defaultSwitchValue){
      showText = "${this.widget.content}        ";
      switchText = "Y";
      color = Colors.lightBlue.shade400;
    }else{
      showText = "        ${this.widget.content}";
      switchText = "N";
      color = Colors.red[300];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Chip(
          key: _myKey,
          backgroundColor: Color(0xffE5E5E5),
          padding: EdgeInsets.all(3),
          label: Text(showText),
        ),
        GestureDetector(
          child: Container(
            height: 28,
            child: CircleAvatar(
                backgroundColor: color,
                child: new Text(switchText,softWrap: true,
                    style: TextStyle(fontSize: 12.0, color: Colors.white))),
            margin: EdgeInsets.only(left: this.widget.marginVal),
          ),
          onHorizontalDragUpdate: (details) {
            var mag = this.widget.marginVal + details.delta.dx;
            if (mag < 0) mag = 0;
            if (mag > _myKey.currentContext.size.width - 40)
              mag = _myKey.currentContext.size.width - 40;
            setState(() {
              this.widget.marginVal = mag;
            });
          },
          onHorizontalDragEnd: (details) {
            setState(() {
              this.widget.defaultSwitchValue =
                  this.widget.marginVal / _myKey.currentContext.size.width> 0.5;
              if (this.widget.defaultSwitchValue) {
                this.widget.marginVal = _myKey.currentContext.size.width - 40;
                showText = "${this.widget.content}        ";
                switchText = "Y";
                color = Colors.lightBlue.shade400;
                if(this.widget.onChanged!=null) this.widget.onChanged(true);
              } else {
                this.widget.marginVal = 0;
                showText = "        ${this.widget.content}";
                switchText = "N";
                color = Colors.red[300];
                if(this.widget.onChanged!=null) this.widget.onChanged(false);
              }
            });
          },
        )
      ],
    );
  }
}