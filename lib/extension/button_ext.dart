//
//  button_ext.dart
//  flutter_templet_project
//
//  Created by shang on 7/1/21 5:44 PM.
//  Copyright © 7/1/21 shang. All rights reserved.
//


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_label_and_icon.dart';

extension ButtonStyleExt on ButtonStyle {

  ///边框线加圆角
  static outline({
    BorderRadius borderRadius = BorderRadius.zero,
    required Color borderColor,
  }) {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(color: borderColor)
        ),
      ),
    );
  }
  
}



extension OutlinedButtonExt on OutlinedButton{

  /// 自定义方法
  OutlinedButton copy({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    MaterialStatesController? statesController,
    Widget? child,
  }) {
    return OutlinedButton(
      key: key ?? this.key,
      onPressed: onPressed ?? this.onPressed,
      onLongPress: onLongPress ?? this.onLongPress,
      onHover: onHover ?? this.onHover,
      onFocusChange: onFocusChange ?? this.onFocusChange,
      style: style ?? this.style,
      focusNode: focusNode ?? this.focusNode,
      autofocus: autofocus ?? this.autofocus,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      statesController: statesController ?? this.statesController,
      child: child ?? this.child,
    );
  }
}

extension TextButtonExt on TextButton{

  /// 自定义方法
  TextButton copy({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    MaterialStatesController? statesController,
    Widget? child,
  }) {
    return TextButton(
      key: key ?? this.key,
      onPressed: onPressed ?? this.onPressed,
      onLongPress: onLongPress ?? this.onLongPress,
      onHover: onHover ?? this.onHover,
      onFocusChange: onFocusChange ?? this.onFocusChange,
      style: style ?? this.style,
      focusNode: focusNode ?? this.focusNode,
      autofocus: autofocus ?? this.autofocus,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      statesController: statesController ?? this.statesController,
      child: child ?? this.child ?? SizedBox(),
    );
  }
}

extension ElevatedButtonExt on ElevatedButton{

  /// 自定义方法
  ElevatedButton copy({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    MaterialStatesController? statesController,
    Widget? child,
  }) {
    return ElevatedButton(
      key: key ?? this.key,
      onPressed: onPressed ?? this.onPressed,
      onLongPress: onLongPress ?? this.onLongPress,
      onHover: onHover ?? this.onHover,
      onFocusChange: onFocusChange ?? this.onFocusChange,
      style: style ?? this.style,
      focusNode: focusNode ?? this.focusNode,
      autofocus: autofocus ?? this.autofocus,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      statesController: statesController ?? this.statesController,
      child: child ?? this.child ?? SizedBox(),
    );
  }
}

extension PopupMenuButtonExt on PopupMenuButton{

  static fromList({
    Widget? child,
    required List<String> list,
    Offset offset = Offset.zero,
    void Function(String value)? callback
  }) => PopupMenuButton<String>(
    itemBuilder: (BuildContext context) => list.map((value) => PopupMenuItem(
      value: "${list.indexOf(value)}",
      child: Text(value),
    )).toList(),
    onSelected: callback,
    offset: offset,
    child: child,
  );

  /// itemBuilder: <PopupMenuButton<String>>[]
  static fromJson<T>({
    Widget? child,
    required Map<String, T> json,
    T? initialValue,
    Offset offset = Offset.zero,
    PopupMenuItemSelected<T>? onSelected,
  }) => PopupMenuButton<T>(
    itemBuilder: (context) {
      return json.keys.map((key) => PopupMenuItem<T>(
        value: json[key],
        child: Text(key),
      )).toList();
    },
    initialValue: initialValue,
    onSelected: onSelected,
    offset: offset,
    child: child,
  );

  /// itemBuilder: <CheckedPopupMenuItem<String>>[]
  static fromCheckList({
    Widget? child,
    required List<String> list,
    int checkedIdx = 0, Offset
    offset = Offset.zero,
    void Function(String value)? callback
  }) => PopupMenuButton<String>(
    itemBuilder: (BuildContext context) => list.map((value) => CheckedPopupMenuItem<String>(
      checked: checkedIdx == list.indexOf(value),
      value: "${list.indexOf(value)}",
      child: Text(value),
    )).toList(),
    onSelected: callback,
    offset: offset,
    shape: RoundedRectangleBorder(
      side: BorderSide(
        color: Colors.grey.withOpacity(0.7),
      ),
      borderRadius: BorderRadius.circular(5)
    ),
    child: child,
  );

  /// itemBuilder: <CheckedPopupMenuItem<String>>[]
  static fromCheckJson({
    Widget? child,
    required Map<String, String> json,
    required String checkedString,
    Offset offset = Offset.zero,
    void Function(String value)? callback
  }) => PopupMenuButton<String>(
    itemBuilder: (BuildContext context) => json.keys.map((key) => CheckedPopupMenuItem<String>(
      checked: key == checkedString,
      value: json[key],
      child: Text(key),
    )).toList(),
    onSelected: callback,
    offset: offset,
    child: child,
  );

  /// itemBuilder: <PopupMenuEntry<String>>[]
  static fromEntryList({
    Widget? child,
    required List<String> list,
    required int checkedIdx,
    Offset offset = Offset.zero,
    void Function(String value)? callback
  }) {
    var items = list.map((e) => CheckedPopupMenuItem<String>(
      value: e,
      checked: list.indexOf(e) == checkedIdx,
      child: Text(e),
    )).toList();

    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => items,
      onSelected: callback,
      offset: offset,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey.withOpacity(0.7),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }

  /// itemBuilder: <PopupMenuEntry<String>>[]
  static fromEntryJson({
    Widget? child,
    required Map<String, String> json,
    required String checkedString,
    Offset offset = Offset.zero,
    void Function(String value)? callback
  }) {
    var items = json.keys.map((e) => CheckedPopupMenuItem<String>(
      value: e,
      checked: e == checkedString,
      child: Text(e),
    )).toList();

    return PopupMenuButton<String>(
      itemBuilder: (context) => items,
      onSelected: callback,
      offset: offset,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey.withOpacity(0.7),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}
