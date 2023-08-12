

import 'package:flutter/cupertino.dart';

typedef VoidCallbackWidgetBuilder = Widget Function(BuildContext context, VoidCallback cb);

typedef ValueChangedWidgetBuilder = Widget Function<T>(BuildContext context, ValueChanged<T> onChanged);
