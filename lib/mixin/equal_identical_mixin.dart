//
//  EqualIdenticalMixin.dart
//  projects
//
//  Created by shang on 2024/11/27 09:31.
//  Copyright © 2024/11/27 shang. All rights reserved.
//


/// 相等性判断(是否对象相同)
mixin EqualIdenticalMixin {

  @override
  bool operator ==(Object other) {
    throw UnimplementedError("❌$this 未实现 == 运算符重载");
  }

  @override
  int get hashCode => throw UnimplementedError("❌$this 未实现 hashCode");
}

