//
//  SelectedMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2024/4/3 17:55.
//  Copyright © 2024/4/3 shang. All rights reserved.
//

/// 带有选择属性的 Mixin
mixin SelectableMixin {
  /// 唯一性id,做对比
  String get selectableId;

  /// 名称显示
  String get selectableName;
  // String code = "";
  bool isSelected = false;
}
