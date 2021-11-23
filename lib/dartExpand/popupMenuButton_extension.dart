

import 'dart:convert';
import 'package:flutter/material.dart';


extension PopupMenuButtonExt on PopupMenuButton{

  /// itemBuilder: <PopupMenuItem<String>>[]
  static from({Widget? child, required List<String> list, Offset offset = Offset.zero, void callback(String value)?}) => PopupMenuButton<String>(
    itemBuilder: (BuildContext context) => list.map((value) => PopupMenuItem(
      child: Text(value),
      value: "${list.indexOf(value)}",
    )).toList(),
    onSelected: callback,
    offset: offset,
    child: child,
  );

  /// itemBuilder: <PopupMenuButton<String>>[]
  static fromJson({Widget? child, required Map<String, String> json, Offset offset = Offset.zero, void callback(String value)?}) => PopupMenuButton<String>(
    itemBuilder: (BuildContext context) => json.keys.map((key) => PopupMenuItem(
      child: Text(key),
      value: json[key],
    )).toList(),
    onSelected: callback,
    child: child,
    offset: offset,
  );

  /// itemBuilder: <CheckedPopupMenuItem<String>>[]
  static fromCheckList({Widget? child, required List<String> list, int checkedIdx = 0, Offset offset = Offset.zero, void callback(String value)?}) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => list.map((value) => CheckedPopupMenuItem<String>(
        child: Text(value),
        checked: checkedIdx == list.indexOf(value),
        value: "${list.indexOf(value)}",
      )).toList(),
      onSelected: callback,
      child: child,
      offset: offset,
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.grey.withAlpha(70)
          ),
          borderRadius: BorderRadius.circular(5)
      ),
    );
  }

  /// itemBuilder: <CheckedPopupMenuItem<String>>[]
  static fromCheckJson({Widget? child, required Map<String, String> json, required String checkedString, Offset offset = Offset.zero, void Function(String value)? callback}) async => PopupMenuButton<String>(
    itemBuilder: (BuildContext context) => json.keys.map((key) => CheckedPopupMenuItem<String>(
      child: Text(key),
      checked: key == checkedString,
      value: json[key],
    )).toList(),
    onSelected: callback,
    child: child,
    offset: offset,);

  /// itemBuilder: <PopupMenuEntry<String>>[]
  static fromEntryList({Widget? child, required List<String> list, required int checkedIdx, Offset offset = Offset.zero, void callback(String value)?}) {
    var items = <PopupMenuEntry<String>>[];
    for (int i = 0; i < list.length; i++) {
      final String e = list[i];
      items.add(
          CheckedPopupMenuItem<String>(
            child: Text(e),
            value: e,
            checked: i == checkedIdx,
          ));
      items.add(PopupMenuDivider(height: 1.0));
    }

    return PopupMenuButton<String>(
      child: child,
      itemBuilder: (BuildContext context) => items,
      onSelected: callback,
      offset: offset,
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.grey.withAlpha(70)
          ),
          borderRadius: BorderRadius.circular(5)
      ),
    );
  }
  /// itemBuilder: <PopupMenuEntry<String>>[]
  static fromEntryFromJson({Widget? child, required Map<String, String> json, required String checkedString, Offset offset = Offset.zero, void Function(String value)? callback}) {
    var list = <PopupMenuEntry<String>>[];
    for (final String e in json.keys) {
      list.add(
          CheckedPopupMenuItem<String>(
            child: Text(e),
            checked: e == checkedString,
            value: json[e],
          ));
      list.add(PopupMenuDivider(height: 1.0));
    }

    return PopupMenuButton<String>(
      child: child,
      itemBuilder: (BuildContext context) => list,
      onSelected: callback,
      offset: offset,
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.grey.withAlpha(70)
          ),
          borderRadius: BorderRadius.circular(5)
      ),
    );
  }
}




