//
//  number_stepper.dart
//  flutter_templet_project
//
//  Created by shang on 6/13/21 6:23 AM.
//  Copyright © 6/13/21 shang. All rights reserved.
//

// ignore: must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:get/get.dart';

import 'package:flutter_templet_project/basicWidget/TextInputFormatter/int_clamp_text_input_formatter.dart';

///自定义数值增减 Stepper
class NumberStepper extends StatefulWidget {
  NumberStepper({
    Key? key,
    this.min = 1,
    this.max = 9999,
    required this.step,
    this.iconSize = 32,
    required this.value,
    this.color = Colors.blue,
    this.readOnly = false,
    this.radius = 5.0,
    this.wraps = true,
    this.style = const TextStyle(
      fontSize: 20,
    ),
    required this.onChanged,
  }) : super(key: key);

  ///最小值
  final int min;

  /// 最大值
  final int max;

  /// 步长
  final int step;

  /// 当前值
  final int value;

  /// icon 尺寸
  final double iconSize;

  /// 到达边界值是否继续
  final bool wraps;

  /// icon 颜色
  final Color color;

  /// 是否可以编辑
  final bool readOnly;

  /// 圆角
  final double radius;

  /// 字体样式
  final TextStyle? style;

  /// 回调
  final ValueChanged<int> onChanged;

  @override
  _NumberStepperState createState() => _NumberStepperState();
}

class _NumberStepperState extends State<NumberStepper> {
  // 控制器
  final _textController = TextEditingController();
  // 焦点
  final focusNode1 = FocusNode();

  // late int current = widget.value;
  late int _current = widget.value;

  set current(val) {
    _current = val;
    _textController.text = "${_current}";
  }

  int get current {
    return _current;
  }

  Color centerColor = Color(0xffEDEDED);

  @override
  void initState() {
    // TODO: implement initState

    _textController.text = "${current}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildTexfieldStyle();

    // if (widget.canEdit) {
    //   return buildTexfieldStyle();
    // }
    // return buildSystemStyle();
  }

  // Widget buildSystemStyle() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       buildIconButton(
  //         onPressed: () {
  //           go(-widget.step);
  //         },
  //         child: Icon(Icons.remove, size: widget.iconSize),
  //       ),
  //       Container(
  //         width: widget.max.toString().length*16*widget.iconSize/30,
  //         height: widget.iconSize,
  //         alignment: Alignment.center,
  //         decoration: BoxDecoration(
  //           color: centerColor,
  //         ),
  //         child: Text('$current',
  //           style: widget.style ?? TextStyle(
  //             fontSize: widget.iconSize * 0.7,
  //           ),
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //       buildIconButton(
  //         onPressed: () {
  //           go(widget.step);
  //         },
  //         child: Icon(Icons.add, size: widget.iconSize),
  //       ),
  //     ],
  //   );
  // }

  Widget buildTexfieldStyle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildIconButton(
          onPressed: () {
            go(-widget.step);
          },
          child: Icon(Icons.remove, size: widget.iconSize),
        ),
        Container(
          // margin: EdgeInsets.symmetric(horizontal: 4),
          width: widget.max.toString().length * 16 * widget.iconSize / 30,
          // width: widget.iconSize + 20,
          child: buildTexfield(),
        ),
        buildIconButton(
          onPressed: () {
            go(widget.step);
          },
          child: Icon(Icons.add, size: widget.iconSize),
        ),
      ],
    );
  }

  Widget buildIconButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size(widget.iconSize, widget.iconSize),
      ),
      onPressed: onPressed,
      child: child,
    );
  }

  Widget buildTexfield() {
    return TextField(
      controller: _textController,
      readOnly: widget.readOnly,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      enableInteractiveSelection: false,
      // toolbarOptions: ToolbarOptions(
      //   copy:false,
      //   paste: false,
      //   cut: false,
      //   selectAll: false,
      //   //by default all are disabled 'false'
      // ),
      style: widget.style ??
          const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
      decoration: InputDecoration(
        hintText: "",
        isCollapsed: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        border: InputBorder.none,
        filled: true,
        fillColor: Color(0xffEDEDED),
        // labelText: "请输入内容",//输入框内无文字时提示内容，有内容时会自动浮在内容上方
        // helperText: "随便输入文字或数字", //输入框底部辅助性说明文字
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter("${widget.max}".length),
        IntClampTextInputFormatter(max: widget.max, min: widget.min),
      ],
    );
  }

  void go(int stepValue) {
    if (stepValue < 0 && (current == widget.min || current + stepValue < widget.min)) {
      DLog.d("it's minValue!");
      if (widget.wraps) {
        current = widget.max;
      }
      widget.onChanged(current);
      return;
    }
    if (stepValue > 0 && (current == widget.max || current + stepValue > widget.max)) {
      DLog.d("it's maxValue!");
      if (widget.wraps) {
        current = widget.min;
      }
      widget.onChanged(current);
      return;
    }
    current += stepValue;
    setState(() {});
    widget.onChanged(current);
  }
}
