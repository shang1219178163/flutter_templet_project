//  Property.dart
//  flutter_templet_project
//
//  Created by shang on 3/31/23 9:41 AM.
//  Copyright © 3/31/23 shang. All rights reserved.
//


enum VariableType {
  /// null
  nil,
  bool,
  int,
  double,
  string,
  list,
  object,
}

class PropertyInfo {

  static getVariableType({required String name, dynamic value}) {
    var type = VariableType.nil;

    if (value is Map) {
      type = VariableType.object;
    } else if (value is List) {
      type = VariableType.list;
    } else if (value is String) {
      type = VariableType.string;
    } else if (value is num) {
      var n = value;
      if (n.toInt() == n) {
        type = VariableType.int;
      } else {
        type = VariableType.double;
      }
    } else if (value is bool) {
      type = VariableType.bool;
    } else {
      // null
      type = VariableType.nil;
    }
    return type;
  }
}