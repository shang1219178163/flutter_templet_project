import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextThemeDemo extends StatefulWidget {
  const TextThemeDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<TextThemeDemo> createState() => _TextThemeDemoState();
}

class _TextThemeDemoState extends State<TextThemeDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant TextThemeDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Text("标题大", style: textTheme.titleLarge),
            Text("标题中", style: textTheme.titleMedium),
            Text("标题小", style: textTheme.titleSmall),
            const SizedBox(height: 20),
            Text("正文大", style: textTheme.bodyLarge),
            Text("正文中", style: textTheme.bodyMedium),
            Text("正文小", style: textTheme.bodySmall),
            const SizedBox(height: 20),
            Text("标签文字", style: textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}
