//
//  CustomeBuider.dart
//  flutter_templet_project
//
//  Created by shang on 2023/8/29 20:17.
//  Copyright © 2023/8/29 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';

typedef VoidCallbackWidgetBuilder = Widget Function(BuildContext context, VoidCallback cb);

typedef ValueChangedWidgetBuilder = Widget Function<T>(BuildContext context, ValueChanged<T> onChanged);
