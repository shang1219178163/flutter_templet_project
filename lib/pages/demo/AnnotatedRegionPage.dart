import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/button/AppButton.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:get/get.dart';

class AnnotatedRegionPage extends StatefulWidget {
  const AnnotatedRegionPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<AnnotatedRegionPage> createState() => _AnnotatedRegionPageState();
}

class _AnnotatedRegionPageState extends State<AnnotatedRegionPage> {
  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  final currIndexVN = ValueNotifier(0);

  @override
  void didUpdateWidget(covariant AnnotatedRegionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // 1. 定义你需要的状态栏样式
    final overlayStyle = SystemUiOverlayStyle(
      // Android: 状态栏背景色设为透明，以显示AppBar的颜色
      statusBarColor: Colors.transparent,
      // 状态栏图标/文字颜色 (深色: 适用于浅色背景, 浅色: 适用于深色背景)
      statusBarIconBrightness: Brightness.dark,
      // iOS: 状态栏文字颜色
      statusBarBrightness: Brightness.light,
    );
    // 2. 使用 AnnotatedRegion 包裹页面根布局
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        appBar: AppBar(
          title: Text("$widget"),
          backgroundColor: Colors.green, // 你的页面背景色
          // 在 AppBar 中再次设置，保证 Android 沉浸式效果
          systemOverlayStyle: overlayStyle,
        ),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Text("用 AnnotatedRegion 设置单个页面顶部电池栏颜色"),
            AppButton(
              onPressed: () {
                Get.toNamed(AppRouter.unknown);
              },
              child: Text("AppButton"),
            ),
          ],
        ),
      ),
    );
  }
}
