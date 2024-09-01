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

  /// 是否可用
  bool get enable => true;

  // /// 是否已选择
  // bool isSelected = false;

  bool _isSelected = false;

  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  }

  Map<String, dynamic> toJson() {
    throw UnimplementedError("❌$this 未实现 toJson");
  }
}
