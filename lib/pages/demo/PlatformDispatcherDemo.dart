//
//  PlatformDispatcherDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/13 15:49.
//  Copyright © 2025/3/13 shang. All rights reserved.
//

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/n_screen_manager.dart';
import 'package:get/get.dart';

/// WidgetsBindingObserver 可接的 PlatformDispatcher 通知
enum _ListenKind {
  metrics(label: 'metrics', callback: 'didChangeMetrics'),
  brightness(label: 'brightness', callback: 'didChangePlatformBrightness'),
  textScale(label: 'textScale', callback: 'didChangeTextScaleFactor'),
  locales(label: 'locales', callback: 'didChangeLocales'),
  accessibility(label: 'accessibility', callback: 'didChangeAccessibilityFeatures'),
  lifecycle(label: 'lifecycle', callback: 'didChangeAppLifecycleState'),
  viewFocus(label: 'viewFocus', callback: 'didChangeViewFocus'),
  memory(label: 'memory', callback: 'didHaveMemoryPressure'),
  platformConfig(label: 'platformConfig', callback: 'onPlatformConfigurationChanged'),
  systemFont(label: 'systemFont', callback: 'onSystemFontFamilyChanged');

  const _ListenKind({required this.label, required this.callback});
  final String label;
  final String callback;
}

class PlatformDispatcherDemo extends StatefulWidget {
  const PlatformDispatcherDemo({
    super.key,
    this.title,
    this.arguments,
  });

  final String? title;
  final Map<String, dynamic>? arguments;

  @override
  State<PlatformDispatcherDemo> createState() => _PlatformDispatcherDemoState();
}

class _PlatformDispatcherDemoState extends State<PlatformDispatcherDemo> with WidgetsBindingObserver {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  late final theme = Theme.of(context);

  final scrollController = ScrollController();
  final propertyScrollController = ScrollController();
  /// 各通知是否监听
  final listen = <_ListenKind, bool>{for (final e in _ListenKind.values) e: true};
  /// 事件日志
  final events = <String>[];
  /// 最近事件
  String lastEvent = '—';
  VoidCallback? _prevPlatformConfig;
  VoidCallback? _prevSystemFont;

  PlatformDispatcher get dispatcher => WidgetsBinding.instance.platformDispatcher;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    NScreenManager.addListener(onScreenMetrics);
    _prevPlatformConfig = dispatcher.onPlatformConfigurationChanged;
    dispatcher.onPlatformConfigurationChanged = () {
      _prevPlatformConfig?.call();
      onDispatcherEvent(_ListenKind.platformConfig);
    };
    _prevSystemFont = dispatcher.onSystemFontFamilyChanged;
    dispatcher.onSystemFontFamilyChanged = () {
      _prevSystemFont?.call();
      onDispatcherEvent(_ListenKind.systemFont);
    };
  }

  @override
  void dispose() {
    NScreenManager.removeListener(onScreenMetrics);
    dispatcher.onPlatformConfigurationChanged = _prevPlatformConfig;
    dispatcher.onSystemFontFamilyChanged = _prevSystemFont;
    WidgetsBinding.instance.removeObserver(this);
    propertyScrollController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: hideApp
          ? null
          : AppBar(
              title: Text(widget.title ?? "$widget"),
              actions: [
                TextButton(
                  onPressed: onPrint,
                  child: Text('打印', style: TextStyle(color: scheme.onPrimary)),
                ),
                TextButton(
                  onPressed: onReset,
                  child: Text('重置', style: TextStyle(color: scheme.onPrimary)),
                ),
              ],
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final scheme = theme.colorScheme;
    return ColoredBox(
      color: scheme.surfaceContainerLowest,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final previewHeight = (constraints.maxHeight * 0.42).clamp(220.0, 360.0);
          return Column(
            children: [
              buildPreview(previewHeight),
              Expanded(
                child: Scrollbar(
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      children: [
                        const NDescriptionCard(
                          initialLang: NLangEnum.zh,
                          title: {
                            NLangEnum.en: 'Description',
                            NLangEnum.zh: '说明',
                          },
                          subtitle: {
                            NLangEnum.en: 'dart:ui PlatformDispatcher',
                            NLangEnum.zh: 'dart:ui PlatformDispatcher',
                          },
                          items: [
                            {
                              NLangEnum.en:
                                  'Register WidgetsBindingObserver plus unused dispatcher callbacks. Do not overwrite onBeginFrame / onPointerDataPacket.',
                              NLangEnum.zh:
                                  '用 WidgetsBindingObserver 接可用通知；另接未被 Framework 占用的 dispatcher 回调。不要覆盖 onBeginFrame / onPointerDataPacket。',
                            },
                            {
                              NLangEnum.en:
                                  'Change system dark mode, text size, language, or rotate the device to see preview and the event log update.',
                              NLangEnum.zh: '改系统深浅色、字体大小、语言，或旋转设备，预览和事件日志会更新。',
                            },
                          ],
                        ),
                        buildListenCard(),
                        buildPropertyCard(),
                        buildLogCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildPreview(double previewHeight) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final view = dispatcher.views.isEmpty ? null : dispatcher.views.first;
    final mq = view == null ? null : MediaQueryData.fromView(view);
    final bg = isDark ? const Color(0xFF181818) : const Color(0xFFF6F6F6);
    final fg = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
    final scale = dispatcher.textScaleFactor;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border(
          bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.65)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: previewHeight,
            width: double.infinity,
            child: ClipRect(
              child: ColoredBox(
                color: bg,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DefaultTextStyle(
                    style: TextStyle(color: fg, fontSize: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isDark ? '系统深色' : '系统浅色',
                          style: TextStyle(fontSize: 13 * scale, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Aa 字号 ×${scale.toStringAsFixed(2)}  ${timeLabelOf()}',
                          style: TextStyle(fontSize: 16 * scale),
                        ),
                        Text(
                          'locale ${dispatcher.locale}  views ${dispatcher.views.length}',
                          style: TextStyle(fontSize: 12 * scale, color: fg.withValues(alpha: 0.7)),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: accessibilityLabelsOf().map((e) {
                            return Chip(
                              visualDensity: VisualDensity.compact,
                              label: Text(e, style: const TextStyle(fontSize: 11)),
                            );
                          }).toList(),
                        ),
                        if (mq != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            '${mq.size.toStringAsFixed(separator: '×')}  dpr ${mq.devicePixelRatio}',
                            style: TextStyle(fontSize: 12 * scale),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text(
              lastEvent,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListenCard() {
    return NDecorationCard(
      icon: const Icon(Icons.sensors_rounded),
      title: '监听',
      subtitle: 'WidgetsBindingObserver · unused dispatcher callbacks',
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              children: [
                OutlinedButton(onPressed: () => onListenAll(true), child: const Text('全开')),
                OutlinedButton(onPressed: () => onListenAll(false), child: const Text('全关')),
              ],
            ),
          ),
          ..._ListenKind.values.map((e) {
            return NSwitchListTile(
              title: Text('${e.label}  ${e.callback}'),
              value: listen[e] ?? true,
              onChanged: (v) => onListen(e, v),
            );
          }),
        ],
      ),
    );
  }

  Widget buildLogCard() {
    return NDecorationCard(
      icon: const Icon(Icons.receipt_long_rounded),
      title: '事件',
      subtitle: '最近 20 条',
      child: events.isEmpty
          ? const Text('尚无回调。改系统深浅色 / 字体大小 / 旋转设备试试。')
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: events.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(e, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                );
              }).toList(),
            ),
    );
  }

  Widget buildPropertyCard() {
    final view = dispatcher.views.isEmpty ? null : dispatcher.views.first;
    final mq = view == null ? null : MediaQueryData.fromView(view);
    final features = dispatcher.accessibilityFeatures;
    final rows = <(String, String, String)>[
      ('platformBrightness', '${dispatcher.platformBrightness}', '系统明暗，无偏好时默认 light'),
      ('textScaleFactor', dispatcher.textScaleFactor.toStringAsFixed(2), '系统文字缩放'),
      ('locale', '${dispatcher.locale}', '主语言；列表空时为 und'),
      ('locales', dispatcher.locales.join(', '), '系统语言列表，按下标优先级'),
      ('alwaysUse24HourFormat', '${dispatcher.alwaysUse24HourFormat}', '是否强制 24 小时制'),
      ('systemFontFamily', '${dispatcher.systemFontFamily}', '系统字体族，可能为 null'),
      ('semanticsEnabled', '${dispatcher.semanticsEnabled}', '读屏等是否要求更新语义树'),
      ('nativeSpellCheckServiceDefined', '${dispatcher.nativeSpellCheckServiceDefined}', '平台是否提供拼写检查'),
      ('supportsShowingSystemContextMenu', '${dispatcher.supportsShowingSystemContextMenu}', '能否弹出系统文本选择菜单'),
      ('brieflyShowPassword', '${dispatcher.brieflyShowPassword}', '密码框打字时是否短暂显示字符'),
      ('defaultRouteName', dispatcher.defaultRouteName, '启动路由，未指定为 /'),
      ('initialLifecycleState', dispatcher.initialLifecycleState, 'isolate 启动时缓冲的生命周期，首次读取后不再更新'),
      ('implicitView', '${dispatcher.implicitView}', '单屏隐式 view，可能为 null'),
      ('views', '${dispatcher.views.length}', '引擎提供的 FlutterView 数量'),
      ('displays', '${dispatcher.displays.length}', '显示器数量，平台可能隐瞒副屏'),
      ('frameNumber', '${dispatcher.frameData.frameNumber}', '当前帧号，单调递增'),
      if (mq != null) ...[
        ('size', mq.size.toStringAsFixed(fractionDigits: 1, separator: '×'), 'views.first 逻辑尺寸'),
        ('devicePixelRatio', '${mq.devicePixelRatio}', '物理像素 / 逻辑像素'),
        ('padding', '${mq.padding}', '被系统 UI 挡住、可滚动区域要避开的边'),
        ('viewPadding', '${mq.viewPadding}', '不论键盘是否弹出的安全区'),
        ('viewInsets', '${mq.viewInsets}', '键盘等遮挡'),
      ],
      ('accessibleNavigation', '${features.accessibleNavigation}', 'TalkBack / VoiceOver 正在改交互模型'),
      ('invertColors', '${features.invertColors}', '系统反色'),
      ('disableAnimations', '${features.disableAnimations}', '请求关闭或简化动画'),
      ('boldText', '${features.boldText}', '粗体文本（iOS、Android API 31+）'),
      ('reduceMotion', '${features.reduceMotion}', '减少视差（仅 iOS）'),
      ('highContrast', '${features.highContrast}', '高对比（仅 iOS）'),
      ('onOffSwitchLabels', '${features.onOffSwitchLabels}', '开关上显示 on/off（仅 iOS）'),
    ];
    const nameW = 200.0;
    const valueW = 200.0;
    const commentW = 280.0;
    final scheme = theme.colorScheme;
    Widget cell(String text, {bool header = false, bool mono = true, double width = 0, bool trailingGap = false}) {
      return SizedBox(
        width: width,
        child: Padding(
          padding: EdgeInsets.only(right: trailingGap ? 8 : 0, top: 6, bottom: 6),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: header || !mono ? null : 'monospace',
              fontSize: 12,
              fontWeight: header ? FontWeight.w700 : FontWeight.w400,
              color: header ? scheme.primary : scheme.onSurface,
            ),
          ),
        ),
      );
    }

    return NDecorationCard(
      icon: const Icon(Icons.data_object_rounded),
      title: '属性',
      subtitle: 'PlatformDispatcher + views.first',
      child: Scrollbar(
        controller: propertyScrollController,
        thumbVisibility: true,
        notificationPredicate: (n) => n.depth == 0,
        child: SingleChildScrollView(
          controller: propertyScrollController,
          scrollDirection: Axis.horizontal,
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            columnWidths: const {
              0: FixedColumnWidth(nameW),
              1: FixedColumnWidth(valueW),
              2: FixedColumnWidth(commentW),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: scheme.outlineVariant),
                  ),
                ),
                children: [
                  cell('属性', header: true, width: nameW, trailingGap: true),
                  cell('值', header: true, width: valueW, trailingGap: true),
                  cell('注释', header: true, mono: false, width: commentW),
                ],
              ),
              ...rows.map((e) {
                return TableRow(
                  children: [
                    cell(e.$1, width: nameW, trailingGap: true),
                    cell(e.$2, width: valueW, trailingGap: true),
                    cell(e.$3, mono: false, width: commentW),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }


  List<String> accessibilityLabelsOf() {
    final f = dispatcher.accessibilityFeatures;
    return [
      if (f.accessibleNavigation) 'accessibleNavigation',
      if (f.invertColors) 'invertColors',
      if (f.disableAnimations) 'disableAnimations',
      if (f.boldText) 'boldText',
      if (f.reduceMotion) 'reduceMotion',
      if (f.highContrast) 'highContrast',
      if (f.onOffSwitchLabels) 'onOffSwitchLabels',
      if (dispatcher.semanticsEnabled) 'semanticsEnabled',
    ];
  }

  String timeLabelOf() {
    final n = DateTime.now();
    final m = n.minute.toString().padLeft(2, '0');
    if (dispatcher.alwaysUse24HourFormat) {
      return '${n.hour.toString().padLeft(2, '0')}:$m';
    }
    final h12 = n.hour % 12 == 0 ? 12 : n.hour % 12;
    return '$h12:$m ${n.hour >= 12 ? 'PM' : 'AM'}';
  }

  void onDispatcherEvent(_ListenKind kind) {
    if (listen[kind] != true) {
      return;
    }
    onLog(kind.callback);
  }

  void onLog(String name) {
    if (!mounted) {
      return;
    }
    final n = DateTime.now();
    final stamp =
        '${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')}:${n.second.toString().padLeft(2, '0')}';
    lastEvent = '$stamp  $name';
    events.insert(0, lastEvent);
    if (events.length > 20) {
      events.removeLast();
    }
    DLog.d(lastEvent);
    setState(() {});
  }

  void onListen(_ListenKind kind, bool value) {
    listen[kind] = value;
    setState(() {});
  }

  void onListenAll(bool value) {
    for (final e in _ListenKind.values) {
      listen[e] = value;
    }
    setState(() {});
  }

  void onReset() {
    for (final e in _ListenKind.values) {
      listen[e] = true;
    }
    events.clear();
    lastEvent = '—';
    setState(() {});
  }

  void onScreenMetrics() {
    onDispatcherEvent(_ListenKind.metrics);
  }

  void onPrint() {
    final keyView = dispatcher.views.first;
    final mediaQueryData = MediaQueryData.fromView(keyView);
    DLog.d([
      dispatcher.views,
      dispatcher.implicitView,
      mediaQueryData.toJson().formatedString(),
    ].asMap());
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    onDispatcherEvent(_ListenKind.brightness);
  }

  @override
  void didChangeTextScaleFactor() {
    super.didChangeTextScaleFactor();
    onDispatcherEvent(_ListenKind.textScale);
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    onDispatcherEvent(_ListenKind.locales);
  }

  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    onDispatcherEvent(_ListenKind.accessibility);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (listen[_ListenKind.lifecycle] != true) {
      return;
    }
    onLog('${_ListenKind.lifecycle.callback} $state');
  }

  @override
  void didChangeViewFocus(ViewFocusEvent event) {
    super.didChangeViewFocus(event);
    if (listen[_ListenKind.viewFocus] != true) {
      return;
    }
    onLog('${_ListenKind.viewFocus.callback} view=${event.viewId} ${event.state}');
  }

  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
    onDispatcherEvent(_ListenKind.memory);
  }
}
