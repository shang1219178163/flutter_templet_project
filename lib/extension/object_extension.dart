//
//  ObjectExtension.dart
//  flutter_templet_project
//
//  Created by shang on 10/12/22 4:54 PM.
//  Copyright © 10/12/22 shang. All rights reserved.
//


// class ObjectBaseModel {
//   ///运算符重载
//   dynamic operator [](String key) {
//     final keys = this.toJson().keys.toList();
//     return keys.contains(key) ? this.toJson()[key] : null;
//   }
//
//   ///运算符重载
//   void operator []=(String key, dynamic value) {
//     this.toJson()[key] = value;
//   }
//
//   Map<String, dynamic> toJson() {
//     return {};
//   }
//
//   // ObjectBaseModel modelFromJson(Map<String, dynamic>) {
//   //
//   // }
// }


class ObjectEnhanceMixin {
  ///运算符重载
  dynamic operator [](String key) {
    // final keys = this.toJson().keys.toList();
    // return keys.contains(key) ? this.toJson()[key] : null;
  }

  ///运算符重载
  void operator []=(String key, dynamic value) {
    // this.toJson()[key] = value;
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}


extension ObjectExt on Object{

}


