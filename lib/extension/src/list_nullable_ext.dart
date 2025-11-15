//
//  ListNullableExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/8/29 20:18.
//  Copyright © 2023/8/29 shang. All rights reserved.
//

extension ListNullableExt<E> on List<E> {
  /// 重写属性
  E? get first {
    try {
      return this.first;
    } catch (exception) {
      return null;
    }
  }

  /// 重写属性
  E? get last {
    try {
      return this.last;
    } catch (exception) {
      return null;
    }
  }

  /// 查询元素索引,没有则返回为空
  int? indexOf(E element) {
    try {
      return this.indexOf(element);
    } catch (exception) {
      return null;
    }
  }

  /// 倒叙查询元素索引
  int? lastIndexOf(E element) {
    try {
      return this.lastIndexOf(element);
    } catch (exception) {
      return null;
    }
  }
}
