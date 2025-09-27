//
//  button_ext.dart
//  flutter_templet_project
//
//  Created by shang on 7/1/21 5:44 PM.
//  Copyright © 7/1/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

extension OutlinedButtonExt on OutlinedButton {
  /// 自定义方法
  OutlinedButton copy({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    WidgetStatesController? statesController,
    Widget? child,
  }) {
    return OutlinedButton(
      key: key ?? this.key,
      onPressed: onPressed ?? this.onPressed,
      onLongPress: onLongPress ?? this.onLongPress,
      onHover: onHover ?? this.onHover,
      onFocusChange: onFocusChange ?? this.onFocusChange,
      style: style ?? this.style,
      focusNode: focusNode ?? this.focusNode,
      autofocus: autofocus ?? this.autofocus,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      statesController: statesController ?? this.statesController,
      child: child ?? this.child,
    );
  }
}

extension TextButtonExt on TextButton {
  /// 自定义方法
  TextButton copy({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    WidgetStatesController? statesController,
    Widget? child,
  }) {
    return TextButton(
      key: key ?? this.key,
      onPressed: onPressed ?? this.onPressed,
      onLongPress: onLongPress ?? this.onLongPress,
      onHover: onHover ?? this.onHover,
      onFocusChange: onFocusChange ?? this.onFocusChange,
      style: style ?? this.style,
      focusNode: focusNode ?? this.focusNode,
      autofocus: autofocus ?? this.autofocus,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      statesController: statesController ?? this.statesController,
      child: child ?? this.child ?? SizedBox(),
    );
  }
}

extension ElevatedButtonExt on ElevatedButton {
  /// 自定义方法
  ElevatedButton copy({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    WidgetStatesController? statesController,
    Widget? child,
  }) {
    return ElevatedButton(
      key: key ?? this.key,
      onPressed: onPressed ?? this.onPressed,
      onLongPress: onLongPress ?? this.onLongPress,
      onHover: onHover ?? this.onHover,
      onFocusChange: onFocusChange ?? this.onFocusChange,
      style: style ?? this.style,
      focusNode: focusNode ?? this.focusNode,
      autofocus: autofocus ?? this.autofocus,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      statesController: statesController ?? this.statesController,
      child: child ?? this.child ?? SizedBox(),
    );
  }
}
