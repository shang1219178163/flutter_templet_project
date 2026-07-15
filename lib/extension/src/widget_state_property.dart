import 'package:flutter/widgets.dart';

extension WidgetStatePropertyExt on WidgetStateProperty {
  /// 可用值,不可用值
  static WidgetStateProperty<T?>? stateValue<T>({
    required T value,
    required T disabledValue,
  }) {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return disabledValue;
      }
      return value;
    });
  }
}
