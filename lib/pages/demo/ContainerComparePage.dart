//
//  ContainerComparePage.dart
//  flutter_templet_project
//
//  Created by shang on 2026/7/24.
//  Copyright © 2026/7/24 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_container.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:get/get.dart';

/// 左侧 [NSliverContainer] 预览，右侧开关控制各属性
class ContainerComparePage extends StatefulWidget {
  const ContainerComparePage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ContainerComparePage> createState() => _ContainerComparePageState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<String, dynamic>?>('arguments', arguments));
  }
}

class _ContainerComparePageState extends State<ContainerComparePage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  ThemeData get theme => Theme.of(context);

  static const _labels = [
    'Item 0',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  bool enableMargin = true;
  bool enablePadding = true;
  bool enableDecoration = true;
  bool enableBorderRadius = true;
  bool enableForegroundDecoration = false;
  bool enableForegroundPadding = false;
  bool enableOpacity = false;
  bool enableIgnoring = false;
  bool enableOffstage = false;
  bool enableSafeArea = false;

  static const _margin = EdgeInsets.all(12);
  static const _padding = EdgeInsets.all(12);
  static const _foregroundPadding = EdgeInsets.all(16);
  static const _opacity = 0.4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: const Text('NSliverContainer 属性调试'),
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 5, child: buildPreview()),
          const VerticalDivider(width: 1),
          Expanded(flex: 6, child: buildControls()),
        ],
      ),
    );
  }

  Widget buildPreview() {
    return Column(
      children: [
        sideTitle('NSliverContainer'),
        Expanded(
          child: ColoredBox(
            color: Colors.grey.shade200,
            child: CustomScrollView(
              slivers: [
                NSliverContainer(
                  margin: enableMargin ? _margin : null,
                  padding: enablePadding ? _padding : null,
                  decoration: enableDecoration ? decoration : null,
                  foregroundDecoration: enableForegroundDecoration ? foregroundDecoration : null,
                  foregroundPadding: enableForegroundPadding ? _foregroundPadding : null,
                  opacity: enableOpacity ? _opacity : null,
                  ignoring: enableIgnoring ? true : null,
                  offstage: enableOffstage ? true : null,
                  safeArea: enableSafeArea,
                  safeAreaMinimum: enableSafeArea ? const EdgeInsets.all(8) : EdgeInsets.zero,
                  sliver: SliverList.list(
                    children: [
                      ListTile(
                        dense: true,
                        title: const Text('点我测 ignoring'),
                        subtitle: Text(
                          enableIgnoring ? '开关开：点击无效' : '开关关：可点击',
                          style: TextStyle(fontSize: 11, color: theme.colorScheme.primary),
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('ListTile onTap 触发'),
                              duration: Duration(milliseconds: 800),
                            ),
                          );
                        },
                      ),
                      ..._labels.map(item),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 48)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration get decoration => BoxDecoration(
        color: Colors.yellow,
        borderRadius: enableBorderRadius ? BorderRadius.circular(8) : null,
        border: Border.all(color: Colors.blue, width: 2),
      );

  BoxDecoration get foregroundDecoration => BoxDecoration(
        color: Colors.green.withValues(alpha: 0.5),
        borderRadius: enableBorderRadius ? BorderRadius.circular(50) : null,
        border: Border.all(color: Colors.green.shade700),
        image: const DecorationImage(
          image: AssetImage(Assets.imagesBgJiguang),
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
      );

  Widget buildControls() {
    return Column(
      children: [
        sideTitle('属性开关'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              switchTile(
                title: 'margin',
                subtitle: 'EdgeInsets.all(12)',
                value: enableMargin,
                onChanged: (v) => setState(() => enableMargin = v),
              ),
              switchTile(
                title: 'padding',
                subtitle: 'EdgeInsets.all(12)（并入 Decoration.padding）',
                value: enablePadding,
                onChanged: (v) => setState(() => enablePadding = v),
              ),
              switchTile(
                title: 'decoration',
                subtitle: 'BoxDecoration(color / border)',
                value: enableDecoration,
                onChanged: (v) => setState(() => enableDecoration = v),
              ),
              switchTile(
                title: 'decoration.borderRadius',
                subtitle: 'Radius.circular(16) — 只画圆角，不裁剪子项',
                value: enableBorderRadius,
                onChanged: enableDecoration ? (v) => setState(() => enableBorderRadius = v) : null,
              ),
              switchTile(
                title: 'foregroundDecoration',
                subtitle: '半透明色 + 图片叠层',
                value: enableForegroundDecoration,
                onChanged: (v) => setState(() => enableForegroundDecoration = v),
              ),
              switchTile(
                title: 'foregroundPadding',
                subtitle: 'EdgeInsets.all(16)（背景与前景之间）',
                value: enableForegroundPadding,
                onChanged: (v) => setState(() => enableForegroundPadding = v),
              ),
              switchTile(
                title: 'opacity',
                subtitle: '0.4 → SliverOpacity',
                value: enableOpacity,
                onChanged: (v) => setState(() => enableOpacity = v),
              ),
              switchTile(
                title: 'ignoring',
                subtitle: 'true → SliverIgnorePointer（左侧点「点我」验证）',
                value: enableIgnoring,
                onChanged: (v) => setState(() => enableIgnoring = v),
              ),
              switchTile(
                title: 'offstage',
                subtitle: 'true → SliverOffstage（整块消失）',
                value: enableOffstage,
                onChanged: (v) => setState(() => enableOffstage = v),
              ),
              switchTile(
                title: 'safeArea',
                subtitle: 'true + minimum: EdgeInsets.all(8)',
                value: enableSafeArea,
                onChanged: (v) => setState(() => enableSafeArea = v),
              ),
              const Divider(height: 24),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Text(
                  '受限说明（对比 Container）',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              ...limitationTiles(),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> limitationTiles() {
    const items = <(String, String)>[
      (
        'clipBehavior',
        '仅允许 Clip.none；传 antiAlias / hardEdge 等会 assert。'
            'Flutter 3.27 无官方 Sliver ClipPath，无法像 Container 裁剪子组件。',
      ),
      (
        'decoration.borderRadius',
        'DecoratedSliver 只绘制圆角背景/边框，不会 clip 子 Sliver。'
            '左侧开 borderRadius 后，子项仍可能画出圆角外。',
      ),
      (
        'color（顶层）',
        '无 Container.color；纯色请用 decoration: BoxDecoration(color: ...)。',
      ),
      (
        'alignment',
        '无对应 API。Sliver 沿主轴铺开，不能像 Container 用 Alignment 摆放 child。',
      ),
      (
        'transform / transformAlignment',
        '无对应 API；需要变换请在子 Box 上自行包 Transform，或改布局方案。',
      ),
      (
        'width / height / constraints',
        '尺寸由滚动约束与子 Sliver 决定，不能像 Container 定宽高或 BoxConstraints。',
      ),
      (
        'child → sliver',
        '必须是 Sliver（如 SliverList / SliverToBoxAdapter），不能直接塞普通 Widget。',
      ),
      (
        'padding 合并规则',
        '会与 decoration.padding 相加，行为对齐 Container；两边都设时注意别叠太厚。',
      ),
      (
        'foregroundPadding',
        'Container 无此属性；仅插在 background 与 foreground DecoratedSliver 之间。'
            '未开 foregroundDecoration 时视觉差不明显。',
      ),
      (
        'offstage',
        '会生效（不绘制、占位为 0），整块「消失」易被误判为坏了；调试时先关掉。',
      ),
      (
        'safeArea',
        '包的是 SliverSafeArea，受外层 MediaQuery / 刘海影响；'
            '在已有 SafeArea 的页面里再开可能双重留白。',
      ),
      (
        'ignoring',
        '只忽略指针，不影响绘制；需点左侧「点我测 ignoring」才能感知。',
      ),
      (
        'opacity',
        '走 SliverOpacity，整段 Sliver 一起透明；与半透明 decoration.color 叠加时更淡。',
      ),
      (
        '组装顺序',
        '内→外：padding → decoration → foregroundPadding → foreground → '
            'margin → opacity → ignoring → offstage → safeArea。'
            '与 Container 相近，但中间多了 foregroundPadding。',
      ),
    ];

    return [
      for (final (title, subtitle) in items)
        ListTile(
          dense: true,
          title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 11, height: 1.35, color: Colors.grey.shade700),
          ),
        ),
    ];
  }

  Widget sideTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: theme.colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget switchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return SwitchListTile(
      dense: true,
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget item(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Text(text, style: const TextStyle(fontSize: 15)),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('hideApp', hideApp));
    properties.add(DiagnosticsProperty<ThemeData>('theme', theme));
    properties.add(DiagnosticsProperty<bool>('enableMargin', enableMargin));
    properties.add(DiagnosticsProperty<bool>('enablePadding', enablePadding));
    properties.add(DiagnosticsProperty<bool>('enableDecoration', enableDecoration));
    properties.add(DiagnosticsProperty<bool>('enableBorderRadius', enableBorderRadius));
    properties.add(DiagnosticsProperty<bool>('enableForegroundDecoration', enableForegroundDecoration));
    properties.add(DiagnosticsProperty<bool>('enableForegroundPadding', enableForegroundPadding));
    properties.add(DiagnosticsProperty<bool>('enableOpacity', enableOpacity));
    properties.add(DiagnosticsProperty<bool>('enableIgnoring', enableIgnoring));
    properties.add(DiagnosticsProperty<bool>('enableOffstage', enableOffstage));
    properties.add(DiagnosticsProperty<bool>('enableSafeArea', enableSafeArea));
    properties.add(DiagnosticsProperty<BoxDecoration>('decoration', decoration));
    properties.add(DiagnosticsProperty<BoxDecoration>('foregroundDecoration', foregroundDecoration));
  }
}
