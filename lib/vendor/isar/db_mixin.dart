//
//  DbMixin.dart
//  projects
//
//  Created by shang on 2024/11/19 09:00.
//  Copyright © 2024/11/19 shang. All rights reserved.
//

import 'package:isar/isar.dart';

export 'package:isar/isar.dart';

/// 数据库混入: 含必需参数, 标为 @collection 的都必须遵循此混入
mixin DbMixin {
  /// 数据库唯一 id
  Id get isarId => throw UnimplementedError("❌$this 未实现 isarId");
}
