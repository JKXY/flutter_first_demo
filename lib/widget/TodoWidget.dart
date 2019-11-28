import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoWidget extends StatefulWidget {
  TodoWidget(
      {Key key,
      this.switchValue,
      @required this.content,
      @required this.onChanged})
      : super(key: key);
  bool switchValue;
  String content;
  ValueChanged<bool> onChanged;

  @override
  TodoWidgetState createState() => TodoWidgetState();
}

class TodoWidgetState extends State<TodoWidget> {
  GlobalKey _lableKey = new GlobalKey();
  GlobalKey _sliderKey = new GlobalKey();
  double marginVal = 0;
  double _lableWidth = 0;
  double _sliderWidth = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  @override
  void didUpdateWidget(TodoWidget oldWidget) {
    if (oldWidget.content != widget.content ||
        oldWidget.switchValue != widget.switchValue ||
        oldWidget.onChanged != widget.onChanged) {
      marginVal = 0;
      _lableWidth = 0;
      _sliderWidth = 0;
      WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    }
    super.didUpdateWidget(oldWidget);
  }

  _afterLayout(_) {
    _lableWidth = _lableKey.currentContext.size.width;
    _sliderWidth =
        (_sliderKey.currentContext.findRenderObject() as RenderBox).size.width;
    if (widget.switchValue) {
      marginVal = _lableWidth - _sliderWidth;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Chip(
          key: _lableKey,
          backgroundColor: Color(0xffE5E5E5),
          padding: EdgeInsets.all(3),
          label: Text(widget.switchValue
              ? "${widget.content}        "
              : "        ${widget.content}"),
        ),
        GestureDetector(
          child: Container(
            key: _sliderKey,
            height: 28,
            child: CircleAvatar(
                backgroundColor: widget.switchValue
                    ? Theme.of(context).primaryColor
                    : Colors.red[300],
                child: new Text(widget.switchValue ? "Y" : "N",
                    style: TextStyle(fontSize: 12.0, color: Colors.white))),
            margin: EdgeInsets.only(left: marginVal),
          ),
          onHorizontalDragUpdate: (details) {
            var mag = marginVal + details.delta.dx;
            if (mag < 0) mag = 0;
            if (mag > _lableWidth - _sliderWidth)
              mag = _lableWidth - _sliderWidth;
            setState(() {
              marginVal = mag;
              widget.switchValue =
                  (marginVal + (_sliderWidth / 2)) / _lableWidth >= 0.5;
            });
          },
          onHorizontalDragEnd: (details) {
            _updateDragSwitchState();
          },
          onHorizontalDragCancel: () {
            _updateDragSwitchState();
          },
        )
      ],
    );
  }

  _updateDragSwitchState() {
    setState(() {
      widget.switchValue =
          (marginVal + (_sliderWidth / 2)) / _lableWidth >= 0.5;
      if (widget.switchValue) {
        marginVal = _lableWidth - _sliderWidth;
        if (widget.onChanged != null) widget.onChanged(true);
      } else {
        marginVal = 0;
        if (widget.onChanged != null) widget.onChanged(false);
      }
    });
  }
}
