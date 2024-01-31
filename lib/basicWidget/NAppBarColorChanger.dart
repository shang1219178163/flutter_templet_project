
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';

class NAppBarColorChanger extends StatefulWidget {
  const NAppBarColorChanger({
    super.key,
    this.offsetY = 190,
    required this.child,
    this.isDefault = false,
    this.defaultThemeData,
    this.themeData,
  });

  /// y偏移量,页面滚动达到此偏移量会触发配色方案变化
  final double offsetY;

  /// 默认导航栏颜色
  final bool isDefault;

  final ThemeData? defaultThemeData;

  final ThemeData? themeData;

  final Widget child;

  @override
  State<NAppBarColorChanger> createState() => _NAppBarColorChangerState();
}

class _NAppBarColorChangerState extends State<NAppBarColorChanger> {

  late bool noDefault = !widget.isDefault;

  @override
  void initState() {
    super.initState();
  }


  ThemeData get _transparentThemeData {
    return Theme.of(context).copyWith(
      actionIconTheme: ActionIconTheme.of(context)?.copyWith(
        backButtonIconBuilder: (_) => const Icon(
          Icons.arrow_back_ios_new_outlined,
          color: Colors.white,
          size: 20,
        ),
      ),
      appBarTheme: AppBarTheme.of(context).copyWith(
        systemOverlayStyle: NSystemOverlayStyle.transparent,
        backgroundColor: Colors.transparent,
        titleTextStyle: const TextStyle(color: Colors.transparent),
      ),
    );
  }

  ThemeData get _dartThemeData {
    return Theme.of(context).copyWith(
      // actionIconTheme: ActionIconTheme.of(context)?.copyWith(
      //   backButtonIconBuilder: (_) => const Icon(
      //     Icons.arrow_back_ios_new_outlined,
      //     color: Colors.black,
      //     size: 20,
      //   ),
      // ),
      appBarTheme: AppBarTheme.of(context).copyWith(
        systemOverlayStyle: NSystemOverlayStyle.transparent,
        backgroundColor: primaryColor,
      ),
    );
  }

  ThemeData get _whiteThemeData {
    return Theme.of(context).copyWith(
      actionIconTheme: ActionIconTheme.of(context)?.copyWith(
        backButtonIconBuilder: (_) => const Icon(
          Icons.arrow_back_ios_new_outlined,
          color: Colors.black,
          size: 20,
        ),
      ),
      appBarTheme: AppBarTheme.of(context).copyWith(
        systemOverlayStyle: NSystemOverlayStyle.white,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        toolbarTextStyle: TextStyle(
          color: Colors.black,
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = noDefault ? (widget.themeData ?? _transparentThemeData) : (widget.defaultThemeData ?? _whiteThemeData);

    return NotificationListener<ScrollNotification>(
      onNotification: onNotification,
      child: Theme(
        data: data,
        child: widget.child,
      ),
    );
  }

  bool onNotification(ScrollNotification notification) {
    final noChange = notification.metrics.pixels < widget.offsetY;
    if (noDefault != noChange) {
      noDefault = !noDefault;
      setState(() {});
    }
    return true;
  }
}

/// SystemUiOverlayStyle 变量封装
class NSystemOverlayStyle {
  /// 透明色
  ///
  /// - 状态栏背景色 `透明`
  /// - 状态栏图标 `深色`
  static const transparent = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  /// 暗色
  ///
  /// - 状态栏背景色 `透明`
  /// - 状态栏图标 `浅色`
  static const dark = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  /// 暗色
  ///
  /// - 状态栏背景色 `透明`
  /// - 状态栏图标 `浅色`
  static const white = SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    systemNavigationBarColor: Colors.white,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  );
}
