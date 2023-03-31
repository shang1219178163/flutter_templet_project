//
//  NNSlider.dart
//  flutter_templet_project
//
//  Created by shang on 3/22/23 11:09 AM.
//  Copyright © 3/22/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

typedef ValueChangedWidgetBuilder<T> = Widget Function(BuildContext context, T value);

/// 自定义 Slider 组件封住，增加首尾组件，尾部组件实时显示当前数值；
class NNSlider extends StatefulWidget {

  NNSlider({
    Key? key, 
    this.title,
    this.leading,
    this.trailingBuilder,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.value = 0,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions = 100,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.mouseCursor,
    this.semanticFormatterCallback,
    this.focusNode,
    this.autofocus = false,
  }) : super(key: key);

  String? title;
  Widget? leading;

  ValueChangedWidgetBuilder<double>? trailingBuilder;

  ValueChanged<double>? onChanged;

  ValueChanged<double>? onChangeStart;

  ValueChanged<double>? onChangeEnd;

  double? value;

  double min;

  double max;

  int? divisions;

  String? label;

  Color? activeColor;

  Color? inactiveColor;

  Color? thumbColor;

  MouseCursor? mouseCursor;

  SemanticFormatterCallback? semanticFormatterCallback;

  FocusNode? focusNode;

  bool autofocus;

  @override
  _NNSliderState createState() => _NNSliderState();
}

class _NNSliderState extends State<NNSlider> {

  var sliderVN = ValueNotifier(0.0);

  @override
  void initState() {
    // TODO: implement initState
    sliderVN.value = widget.value ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSlider();
  }

  _buildSlider() {
    return Row(
      children: [
        if (widget.leading != null) widget.leading!,
        Expanded(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Slider(
                value: sliderVN.value,
                onChanged: (double value) {
                  sliderVN.value = value;
                  widget.onChanged?.call(value);
                  setState(() {});
                },
                onChangeStart: widget.onChangeStart,
                onChangeEnd: widget.onChangeEnd,
                min: widget.min,
                max: widget.max,
                divisions: widget.divisions,
                label: widget.label,
                activeColor: widget.activeColor,
                inactiveColor: widget.inactiveColor,
                thumbColor: widget.thumbColor,
                mouseCursor: widget.mouseCursor,
                semanticFormatterCallback: widget.semanticFormatterCallback,
                focusNode: widget.focusNode,
                autofocus: widget.autofocus,
              );
            }
          ),
        ),
        ValueListenableBuilder<double>(
          valueListenable: sliderVN,
          builder: (context, value, child) {

            final result = widget.max > 1 ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
            return widget.trailingBuilder?.call(context, value) ?? TextButton(
              onPressed: () { debugPrint(result); },
              child: Text(result),
            );
          }
        ),
      ],
    );
  }
}

