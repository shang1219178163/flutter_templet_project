import 'package:flutter/material.dart';

import 'package:get/get.dart';

/// 编译环境相关参数
class CompileEnvironmentPage extends StatefulWidget {
  const CompileEnvironmentPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<CompileEnvironmentPage> createState() => _CompileEnvironmentPageState();
}

class _CompileEnvironmentPageState extends State<CompileEnvironmentPage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant CompileEnvironmentPage oldWidget) {
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
            Text("$widget"),
            buildWrap(),
          ],
        ),
      ),
    );
  }

  Widget buildWrap() {
    final list = List.generate(8, (i) => i);

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final spacing = 8.0;
      final rowCount = 4.0;
      final itemWidth = (constraints.maxWidth - spacing * (rowCount - 1)) / rowCount;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        // crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...list.map((e) {
            return GestureDetector(
              onTap: () {
                final appEnv = const String.fromEnvironment("app_env");
                DLog.d([appEnv, appEnv.length.toString()]);
              },
              child: Container(
                width: itemWidth,
                height: itemWidth * 1.2,
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Text("item $e"),
              ),
            );
          }),
        ],
      );
    });
  }
}
