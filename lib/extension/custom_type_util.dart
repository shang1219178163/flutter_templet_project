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