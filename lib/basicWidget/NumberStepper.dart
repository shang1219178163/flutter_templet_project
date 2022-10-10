//
//  NumberStepper.dart
//  flutter_templet_project
//
//  Created by shang on 6/13/21 6:23 AM.
//  Copyright © 6/13/21 shang. All rights reserved.
//

// ignore: must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

enum NumberStepperStyle {
system,
outlined,
textfield,
}

///自定义数值增减 Stepper
class NumberStepper extends StatefulWidget {
  NumberStepper({
    required this.minValue,
    required this.maxValue,
    required this.stepValue,
    this.iconSize = 24,
    required this.value,
    this.color = Colors.blue,
    this.style = NumberStepperStyle.system,
    this.radius = 5.0,
    this.wraps = true,
    required this.block,
  });

  final int minValue;
  final int maxValue;
  final int stepValue;
  final double iconSize;
  int value;

  final bool wraps;

  final Color color;
  final NumberStepperStyle style;
  final double radius;
  void Function(int value) block;


  @override
  _NumberStepperState createState() => _NumberStepperState();
}

class _NumberStepperState extends State<NumberStepper> {

  // 控制器
  final _textController = TextEditingController();
  // 焦点
  final focusNode1 = FocusNode();

  @override
  void initState() {
    // TODO: implement initState

    _textController.text = "${widget.value}";

    ddlog(_textController.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return buildOther(context);
    switch (widget.style) {
      case NumberStepperStyle.outlined:
        return buildOutlinedStyle(context);
        break;
      case NumberStepperStyle.textfield:
        return buildTexfieldStyle(context);
      default:
        break;
    }
    return buildSystemStyle(context);
  }

  Widget buildSystemStyle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: widget.iconSize,
          height: widget.iconSize,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(color: widget.color, width: 1), // 边色与边宽度
          ),
          child: IconButton(
            icon: Icon(Icons.remove, size: widget.iconSize),
            // iconSize: widget.iconSize,
            padding: EdgeInsets.zero,
            color: Colors.white,
            onPressed: () {
              go(-widget.stepValue);
            },

          ),
        ),

        Container(
          width: widget.value.toString().length*18*widget.iconSize/30,
          // width: widget.iconSize + 20,
          child: Text('${widget.value}',
            style: TextStyle(
              fontSize: widget.iconSize * 0.8,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        Container(
          width: widget.iconSize,
          height: widget.iconSize,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(color: widget.color, width: 1), // 边色与边宽度
          ),
          child: IconButton(
            icon: Icon(Icons.add, size: widget.iconSize,),
            // iconSize: widget.iconSize,
            padding: EdgeInsets.zero,
            color: Colors.white,
            onPressed: () {
              setState(() {
                go(widget.stepValue);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildOutlinedStyle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: widget.iconSize,
          height: widget.iconSize,
          // color: Theme.of(context).primaryColor,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(color: widget.color, width: 1), // 边色与边宽度
          ),
          child: IconButton(
            icon: Icon(Icons.remove, size: widget.iconSize),
            // iconSize: widget.iconSize,
            padding: EdgeInsets.zero,
            color: widget.color,
            onPressed: () {
              go(-widget.stepValue);
            },
          ),
        ),

        Container(
          width: widget.value.toString().length*18*widget.iconSize/30,
          // width: widget.iconSize + 20,
          child: Text('${widget.value}',
            style: TextStyle(
              fontSize: widget.iconSize * 0.8,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        Container(
          width: widget.iconSize,
          height: widget.iconSize,
          // color: Theme.of(context).primaryColor,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(color: widget.color, width: 1), // 边色与边宽度
          ),
          child: IconButton(
            icon: Icon(Icons.add, size: widget.iconSize),
            // iconSize: widget.iconSize,
            padding: EdgeInsets.zero,
            color: widget.color,
            onPressed: () {
              setState(() {
                go(widget.stepValue);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildTexfieldStyle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            enableInteractiveSelection: false,
            toolbarOptions: ToolbarOptions(
              copy:false,
              paste: false,
              cut: false,
              selectAll: false,
              //by default all are disabled 'false'
            ),
            controller: _textController,
            decoration: InputDecoration(
                // labelText: "请输入内容",//输入框内无文字时提示内容，有内容时会自动浮在内容上方
                // helperText: "随便输入文字或数字", //输入框底部辅助性说明文字
                prefixIcon:IconButton(
                  icon: Icon(
                    Icons.remove,
                    size: widget.iconSize,
                  ),
                  onPressed: (){
                    // go(-widget.stepValue);
                    setState(() {
                      go(-widget.stepValue);
                      _textController.text = "${widget.value}";
                    });
                  },
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0) //圆角大小
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.add,
                    size: widget.iconSize,
                  ),
                  onPressed: (){
                    // go(widget.stepValue);
                    setState(() {
                      // FocusScope.of(context).requestFocus(FocusNode());
                      go(widget.stepValue);
                      _textController.text = "${widget.value}";
                    });
                  },
                ),
                contentPadding: const EdgeInsets.only(bottom:8)
            ),
            keyboardType: TextInputType.number,
          ),
        ),
    ],
    );
  }

  void go(int stepValue) {
    setState(() {
      if (stepValue < 0 && (widget.value == widget.minValue || widget.value + stepValue < widget.minValue)) {
        ddlog("it's minValue!");
        if (widget.wraps) widget.value = widget.maxValue;
        widget.block(widget.value);
        return;
      }
      if (stepValue > 0 && (widget.value == widget.maxValue || widget.value + stepValue > widget.maxValue)) {
        ddlog("it's maxValue!");
        if (widget.wraps) widget.value = widget.minValue;
        widget.block(widget.value);
        return;
      }
      widget.value += stepValue;
    });
    widget.block(widget.value);
  }
}