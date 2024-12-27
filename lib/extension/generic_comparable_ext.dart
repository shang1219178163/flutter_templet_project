//
//  GenericComparableExt.dart
//  flutter_templet_project
//
//  Created by shang on 2024/11/8 16:03.
//  Copyright © 2024/11/8 shang. All rights reserved.
//

extension GenericComparableExt<T extends Comparable<T>> on T {
  /// > 运算符重载
  bool operator >(T value) => compareTo(value) > 0;

  /// < 运算符重载
  bool operator <(T value) => compareTo(value) < 0;

  /// 是否在区间之内
  bool inRange(T lowerLimit, T upperLimit) {
    final result = compareTo(lowerLimit) >= 0 && compareTo(upperLimit) <= 0;
    // debugPrint("inRange ${{
    //   "lowLimit": lowLimit.toString(),
    //   "this": toString(),
    //   "highLimit": highLimit.toString(),
    // }}");
    return result;
  }

  /// 超出底限用底限, 超出上限用上限
  T clamp(T lowerLimit, T upperLimit) {
    if (compareTo(lowerLimit) < 0) {
      return lowerLimit;
    }

    if (compareTo(upperLimit) > 0) {
      return upperLimit;
    }
    return this;
  }
}
