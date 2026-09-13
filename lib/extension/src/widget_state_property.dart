import 'package:flutter/widgets.dart';

extension WidgetStatePropertyExt on WidgetStateProperty {
  /// 按状态取值：selected > disabled > [value]
  static WidgetStateProperty<T> stateValue<T>({
    required T value,
    T? selected,
    T? disabled,
  }) {
    return WidgetStateProperty.resolveWith((states) {
      if (selected != null && states.contains(WidgetState.selected)) {
        return selected;
      }
      if (disabled != null && states.contains(WidgetState.disabled)) {
        return disabled;
      }
      return value;
    });
  }
}
