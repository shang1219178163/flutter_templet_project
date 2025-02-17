import 'package:flutter/material.dart';

class SelectableTextDemo extends StatefulWidget {
  final String? title;

  const SelectableTextDemo({Key? key, this.title}) : super(key: key);

  @override
  _SelectableTextDemoState createState() => _SelectableTextDemoState();
}

class _SelectableTextDemoState extends State<SelectableTextDemo> {
  final message = """
2022 年 6 月在 Flutter 3.0 版本中 Google 官方正式将渲染器 Impeller 从独立仓库中合入 Flutter Engine 主干进行迭代，这是 2021 年 Flutter 团队推动重新实现 Flutter 渲染后端以来，首次正式明确了 Impeller 未来代替 Skia 作为 Flutter 主渲染方案的定位。Impeller 的出现是 Flutter 团队用以彻底解决 SkSL（Skia Shading Language） 引入的 Jank 问题所做的重要尝试。官方首次注意到 Flutter 的 Jank 问题是在 2015 年，当时推出的最重要的优化是对 Dart 代码使用 AOT 编译优化执行效率。在 Impeller出现之前，Flutter 对渲染性能的优化大多停留在 Skia 上层，如渲染线程优先级的提升，在着色器编译过久的情况下切换 CPU 绘制等策略性优化。

Jank 类型分为两种：首次运行卡顿(Early-onset Jank)和非首次运行卡顿， Early-onset Jank 的本质是运行时着色器的编译行为阻塞了 Flutter Raster 线程对渲染指令的提交。在 Native 应用中，开发者通常会基于 UIkit 等系统级别的 UI 框架开发应用，极少需要自定义着色器，Core Animation 等 framework 使用的着色器在 OS 启动阶段就可以完成编译，着色器编译产物对所有的 app 而言全局共享，所以 Native 应用极少出现着色器编译引起的性能问题 ， 更常见的是用户逻辑对 UI 线程过度占用 。 官方为了优化 Early-onset Jank ，推出了SkSL 的 Warmup 方案，Warmup 本质是将部分性能敏感的 SkSL 生成时间前置到编译期，仍然需要在运行时将 SkSL 转换为 MSL 才能在 GPU 上执行。Warmup 方案需要在开发期间在真实设备上捕获 SkSL 导出配置文件 ， 在应用打包时通过编译参数可以将部分 SkSL 预置在应用中。此外由于 SkSL 创建过程中捕获了用户设备特定的参数，不同设备 Warmup 配置文件不能相互通用，这种方案带来的性能提升非常有限。  
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SelectableText(
                message,
                style: const TextStyle(fontSize: 16),
                onSelectionChanged: (selection, cause) {
                  debugPrint(selection.toString());
                  debugPrint(cause.toString());
                },
              ),
            ]
                .map((e) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: e,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
