//
//  TypeUtil.dart
//  flutter_templet_project
//
//  Created by shang on 2023/10/16 10:01.
//  Copyright © 2023/10/16 shang. All rights reserved.
//

import 'package:flutter/material.dart';

typedef GenericWidgetBuilder<T> = Widget Function(BuildContext context, T generic);

typedef VoidCallbackWidgetBuilder = Widget Function(BuildContext context, VoidCallback cb);

typedef ValueChangedWidgetBuilder<T> = Widget Function(BuildContext context, ValueChanged<T> onChanged);

/// 一个两个元素的元祖;
/// e 泛型数据;
/// action 事件回调;
typedef ActionRecord<T> = ({T e, VoidCallback action});

/// 选择菜单子元素的元祖;
/// title 标题
/// value 泛型数据;
/// title 所选元素对应接口参数;
typedef ChooseItemRecord<T> = ({String title, String key, T value});

typedef TabItemRecord<T> = ({String title, Widget child, T value});

/// 判断条件
typedef ConditionFn = bool Function<T>(T e);

/// 属性元祖
typedef PropertyRecord = ({String name, String type, String comment});

/// BottomNavigationBar 子项数据
typedef BarItemRecord = ({
  String title,
  String icon,
  String activeIcon,
  Widget page,
  ValueNotifier<int>? unreadVN,
});
