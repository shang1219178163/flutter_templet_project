//
//  number_stepper.dart
//  flutter_templet_project
//
//  Created by shang on 6/13/21 6:23 AM.
//  Copyright © 6/13/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/TextInputFormatter/int_clamp_text_input_formatter.dart';

///自定义数值增减 Stepper
class NumberStepper extends StatefulWidget {
  NumberStepper({
    super.key,
    this.min = 1,
    this.max = 9999,
    required this.step,
    this.iconSize = 32,
    required this.value,
    this.color = Colors.blue,
    this.readOnly = false,
    this.radius = 5.0,
    this.wraps = true,
    this.style = const TextStyle(fontSize: 20),
    required this.onChanged,
  });

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
  final TextStyle style;

  /// 回调
  final ValueChanged<int> onChanged;

  @override
  State<NumberStepper> createState() => _NumberStepperState();
}

class _NumberStepperState extends State<NumberStepper> {
  late final _textController = TextEditingController(text: '${widget.value}');
  late int current = widget.value;

  @override
  void didUpdateWidget(NumberStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value != current) {
      onValue(widget.value);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildButton(Icons.remove, -widget.step),
        SizedBox(
          width: widget.max.toString().length * 16 * widget.iconSize / 15,
          child: buildField(),
        ),
        buildButton(Icons.add, widget.step),
      ],
    );
  }

  Widget buildButton(IconData icon, int delta) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size(widget.iconSize, widget.iconSize),
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.radius)),
      ),
      onPressed: () => go(delta),
      child: Icon(icon, size: widget.iconSize),
    );
  }

  Widget buildField() {
    return TextField(
      controller: _textController,
      readOnly: widget.readOnly,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      enableInteractiveSelection: false,
      style: widget.style,
      decoration: const InputDecoration(
        isCollapsed: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        border: InputBorder.none,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter('${widget.max}'.length),
        IntClampTextInputFormatter(max: widget.max, min: widget.min),
      ],
      onChanged: onText,
    );
  }

  void onText(String value) {
    final n = int.tryParse(value);
    if (n == null || n == current) {
      return;
    }
    current = n;
    widget.onChanged(current);
  }

  void onValue(int value) {
    current = value;
    _textController.text = '$current';
  }

  void go(int delta) {
    var next = current + delta;
    if (next < widget.min) {
      next = widget.wraps ? widget.max : widget.min;
    } else if (next > widget.max) {
      next = widget.wraps ? widget.min : widget.max;
    }
    if (next == current) {
      return;
    }
    onValue(next);
    widget.onChanged(current);
  }
}
