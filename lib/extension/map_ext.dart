//
//  MapExtension.dart
//  flutter_templet_project
//
//  Created by shang on 2022/11/24 10:43.
//  Copyright © 2022/11/24 shang. All rights reserved.
//

extension MapExt on Map<String, dynamic>{
  // 拼接键值成字符串
  String join({String char = '&'}) {
    if (this.keys.length == 0) {
      return '';
    }
    String paramStr = '';
    this.forEach((key, value) {
      paramStr += '${key}=${value}${char}';
    });
    String result = paramStr.substring(0, paramStr.length - 1);
    return result;
  }
}
