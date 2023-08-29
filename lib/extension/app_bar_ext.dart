//
//  AppBarExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/8/29 20:17.
//  Copyright © 2023/8/29 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension AppBarExt on AppBar{
  /// 自定义 copy
  AppBar copy({
    Widget? leading,
    bool? automaticallyImplyLeading,
    Widget? title,
    List<Widget>? actions,
    Widget? flexibleSpace,
    PreferredSizeWidget? bottom,
    double? elevation,
    double? scrolledUnderElevation,
    ScrollNotificationPredicate? notificationPredicate,
    Color? shadowColor,
    Color? surfaceTintColor,
    ShapeBorder? shape,
    Color? backgroundColor,
    Color? foregroundColor,
    IconThemeData? iconTheme,
    IconThemeData? actionsIconTheme,
    bool? primary ,
    bool? centerTitle,
    bool? excludeHeaderSemantics,
    double? titleSpacing,
    double? toolbarOpacity,
    double? bottomOpacity,
    double? toolbarHeight,
    double? leadingWidth,
    TextStyle? toolbarTextStyle,
    TextStyle? titleTextStyle,
    SystemUiOverlayStyle? systemOverlayStyle,
  }) {
    return AppBar(
      leading: leading ?? this.leading,
      automaticallyImplyLeading: automaticallyImplyLeading ?? this.automaticallyImplyLeading,
      title: title ?? this.title,
      actions: actions ?? this.actions,
      flexibleSpace: flexibleSpace ?? this.flexibleSpace,
      bottom: bottom ?? this.bottom,
      elevation: elevation ?? this.elevation,
      scrolledUnderElevation: scrolledUnderElevation ?? this.scrolledUnderElevation,
      notificationPredicate: notificationPredicate ?? this.notificationPredicate,
      shadowColor: shadowColor ?? this.shadowColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      shape: shape ?? this.shape,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      iconTheme: iconTheme ?? this.iconTheme,
      actionsIconTheme: actionsIconTheme ?? this.actionsIconTheme,
      primary: primary ?? this.primary,
      centerTitle: centerTitle ?? this.centerTitle,
      excludeHeaderSemantics: excludeHeaderSemantics ?? this.excludeHeaderSemantics,
      titleSpacing: titleSpacing ?? this.titleSpacing,
      toolbarOpacity: toolbarOpacity ?? this.toolbarOpacity,
      bottomOpacity: bottomOpacity ?? this.bottomOpacity,
      toolbarHeight: toolbarHeight ?? this.toolbarHeight,
      leadingWidth: leadingWidth ?? this.leadingWidth,
      toolbarTextStyle: toolbarTextStyle ?? this.toolbarTextStyle,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      systemOverlayStyle: systemOverlayStyle ?? this.systemOverlayStyle,
    );
  }
}