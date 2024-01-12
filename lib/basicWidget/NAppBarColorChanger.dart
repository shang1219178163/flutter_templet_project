
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';

class NAppBarColorChanger extends StatefulWidget {
  const NAppBarColorChanger({
    super.key,
    this.yThresholdOffset = 30,
    required this.child,
    this.scrollToDark = false,
  });

  /// y轴阈值
  ///
  /// 页面滚动达到此阈值会触发配色方案变化
  final double yThresholdOffset;

  /// 由浅入深
  final bool scrollToDark;

  final Widget child;

  @override
  State<NAppBarColorChanger> createState() => _NAppBarColorChangerState();
}

class _NAppBarColorChangerState extends State<NAppBarColorChanger> {
  late bool light;

  bool comingLight(ScrollNotification notification) {
    return notification.metrics.pixels < widget.yThresholdOffset;
  }

  @override
  void initState() {
    light = !widget.scrollToDark;
    super.initState();
  }

  bool _listener(ScrollNotification notification) {
    bool comingLight(ScrollNotification notification) =>
        notification.metrics.pixels < widget.yThresholdOffset;

    if (light != comingLight(notification)) {
      setState(() => light = !light);
    }
    return true;
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
    return NotificationListener<ScrollNotification>(
      onNotification: _listener,
      child: Theme(
        data: light ? _transparentThemeData : _whiteThemeData,
        child: widget.child,
      ),
    );
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
