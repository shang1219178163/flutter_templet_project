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
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;

    final textTheme = themeData.textTheme;

    final items = [
      (name: "displayLarge", value: textTheme.displayLarge),
      (name: "displayMedium", value: textTheme.displayMedium),
      (name: "displaySmall", value: textTheme.displaySmall),
      (name: "headlineLarge", value: textTheme.headlineLarge),
      (name: "headlineMedium", value: textTheme.headlineMedium),
      (name: "headlineSmall", value: textTheme.headlineSmall),
      (name: "titleLarge", value: textTheme.titleLarge),
      (name: "titleMedium", value: textTheme.titleMedium),
      (name: "titleSmall", value: textTheme.titleSmall),
      (name: "bodyLarge", value: textTheme.bodyLarge),
      (name: "bodyMedium", value: textTheme.bodyMedium),
      (name: "bodySmall", value: textTheme.bodySmall),
      (name: "labelLarge", value: textTheme.labelLarge),
      (name: "labelMedium", value: textTheme.labelMedium),
      (name: "labelSmall", value: textTheme.labelSmall),
    ];

    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ...items.map((e) {
              final desc = [
                e.name,
                e.value?.fontSize,
                e.value?.fontWeight,
              ].join("_");
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  // border: Border.all(color: Colors.blue),
                  // borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Text(desc),
              );
            }),
          ],
        ),
      ),
    );
  }
}
