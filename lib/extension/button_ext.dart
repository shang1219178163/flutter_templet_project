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


extension TextButtonExt on TextButton{

  static TextButton build({
    required Text text,
    required Widget image,
    ImageAlignment? imageAlignment = ImageAlignment.left,
    EdgeInsets? padding = const EdgeInsets.all(5),
    double? spacing = 3,
    // BorderSide? side = const BorderSide(width: 1.0, color: Colors.black12),
    BorderSide? side,
    int tag = 0,
    required void Function(Text text, int tag) callback
  }) {

    var child = TextButtonExt.buildTextAndImage(
      text: text,
      image: image,
      imageAlignment: imageAlignment,
      spacing: spacing,
    );
    return TextButton(
      onPressed: () => callback(text, tag),
      style: OutlinedButton.styleFrom(side: side,),
      child: Container(
        padding: padding,
        child: child,
      ),
    );
  }

  /// 建立 TextAndImage
  static Widget buildTextAndImage({
    required Text text,
    required Widget image,
    ImageAlignment? imageAlignment = ImageAlignment.left,
    double? spacing = 3,
  }) {

    Widget child;

    switch (imageAlignment) {
      case ImageAlignment.top:
        child = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            image,
            SizedBox(height: spacing),
            text,
          ],
        );
        break;

      case ImageAlignment.right:
        child = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            text,
            SizedBox(width: spacing),
            image,
          ],
        );
        break;

      case ImageAlignment.bottom:
        child = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            text,
            SizedBox(height: spacing),
            image,
          ],
        );
        break;

      default:
        child = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            image,
            SizedBox(width: spacing),
            text,
          ],
        );
    }
    return child;
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
