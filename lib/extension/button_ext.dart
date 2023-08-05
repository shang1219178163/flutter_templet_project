//
//  button_ext.dart
//  flutter_templet_project
//
//  Created by shang on 7/1/21 5:44 PM.
//  Copyright © 7/1/21 shang. All rights reserved.
//


import 'dart:convert';
import 'package:flutter/material.dart';

extension ButtonStyleExt on ButtonStyle {

  ///边框线加圆角
  static outline({
    BorderRadius borderRadius = BorderRadius.zero,
    required Color borderColor
  }) {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(color: borderColor)
        )
      )
    );
  }
}



enum ImageAlignment {
  /// 文字左边
  left,

  /// 文字顶部
  top,

  /// 文字右边
  right,

  /// 文字底部
  bottom,
}


extension ButtonExt on ButtonStyleButton{

  static OutlinedButton outlined({
    /// 文字
    required Widget text,
    /// 图标
    Widget? icon,
    /// 标题图标方向
    Axis direction = Axis.horizontal,
    /// 图标标题间距
    double iconTextGap = 6,
    /// 标题图标翻转
    bool isReverse = false,
    /// 边距
    EdgeInsets padding = const EdgeInsets.all(8),
    BorderSide? side = const BorderSide(color: Color(0xffE4E4E4)),
    Clip clipBehavior = Clip.none,
    required VoidCallback onPressed,
  }) {

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        side: side,
      ),
      clipBehavior: clipBehavior,
      onPressed: onPressed,
      child: textAndicon(
        text: text,
        icon: icon,
        direction: direction,
        isReverse: isReverse,
        iconTextGap: iconTextGap,
        padding: padding,
      ),
    );
  }

  static ElevatedButton elevated({
    /// 文字
    required Widget text,
    /// 图标
    Widget? icon,
    /// 标题图标方向
    Axis direction = Axis.horizontal,
    /// 图标标题间距
    double iconTextGap = 6,
    /// 标题图标翻转
    bool isReverse = false,
    /// 边距
    EdgeInsets padding = const EdgeInsets.all(8),
    BorderSide? side = const BorderSide(color: Color(0xffE4E4E4)),
    Clip clipBehavior = Clip.none,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        side: side,
      ),
      clipBehavior: clipBehavior,
      onPressed: onPressed,
      child: textAndicon(
        text: text,
        icon: icon,
        direction: direction,
        isReverse: isReverse,
        iconTextGap: iconTextGap,
        padding: padding,
      ),
    );
  }

  /// 建立 TextAndImage
  static Widget textAndicon({
    /// 文字
    required Widget text,
    /// 图标
    Widget? icon,
    /// 标题图标方向
    Axis direction = Axis.horizontal,
    /// 图标标题间距
    double iconTextGap = 6,
    /// 标题图标翻转
    bool isReverse = false,
    /// 边距
    EdgeInsets padding = const EdgeInsets.all(8),
  }) {
    var children = <Widget>[
      if (icon != null)icon,
      if (icon != null)SizedBox(width: iconTextGap,),
      text,
    ];

    if (isReverse) {
      children = children.reversed.toList();
    }

    return Padding(
      padding: padding,
      child: Flex(
        direction: direction,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
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
