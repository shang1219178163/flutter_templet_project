//
//  ExpandModel.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/13 10:05.
//  Copyright © 2025/3/13 shang. All rights reserved.
//

class NExpandModel<T> {
  NExpandModel({
    required this.value,
    this.isExpand = true,
  });

  T value;
  bool isExpand;

  Map<String, dynamic> toJson() {
    return {
      "value": value,
      "isExpand": isExpand,
    };
  }

  @override
  String toString() {
    return "$runtimeType: ${toJson()}";
  }
}
