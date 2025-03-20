//
//  CellModel.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/13 10:05.
//  Copyright © 2025/3/13 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';

class CellModel {
  CellModel({
    this.icon,
    required this.title,
    this.subtitle,
    this.isOpen,
    this.arguments,
  });

  IconData? icon;
  String title = "title";
  String? subtitle;
  bool? isOpen;

  Map<String, dynamic>? arguments;

  CellModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    icon = json['icon'];
    title = json['title'];
    subtitle = json['subtitle'];
    isOpen = json['isOpen'];
    arguments = json['arguments'];
  }

  Map<String, dynamic> toJson() {
    return {
      "icon": icon,
      "title": title,
      "subtitle": subtitle,
      "isOpen": isOpen,
      "arguments": arguments,
    };
  }

  @override
  String toString() {
    return "$runtimeType: ${toJson()}";
  }
}
