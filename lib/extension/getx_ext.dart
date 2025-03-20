//
//  GetExt.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/5 15:55.
//  Copyright © 2025/3/5 shang. All rights reserved.
//

import 'package:get/get.dart';

extension InstExt on GetInterface {
  /// 返回一个实例，如果实例不存在，则创建一个实例
  S putNew<S>(S dependency, {String? tag, bool permanent = false}) {
    if (GetInstance().isRegistered<S>(tag: tag)) {
      return find<S>(tag: tag);
    }

    return put<S>(dependency, tag: tag, permanent: permanent);
  }
}
