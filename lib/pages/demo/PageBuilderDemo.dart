import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

/// transitionsBuilder 预设，对应 Material PageTransitionsBuilder
enum _TransitionKind { openUpwards, zoom, cupertino, fadeUpwards, none, predictiveBack }

/// requestFocus 三态
enum _Tri { nil, yes, no }

/// barrierLabel 预设
enum _BarrierLabelKind { nil, dismiss }

class PageBuilderDemo extends StatefulWidget {
  const PageBuilderDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<PageBuilderDemo> createState() => _PageBuilderDemoState();
}

class _PageBuilderDemoState extends State<PageBuilderDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  /// 转场类型，原 Demo 第一项 OpenUpwardsPageTransitionsBuilder
  _TransitionKind transitionKind = _TransitionKind.openUpwards;
  /// Zoom 转场是否允许快照
  bool zoomAllowSnapshotting = true;
  /// Zoom 进入路由是否允许快照
  bool zoomAllowEnterRouteSnapshotting = true;
  /// Zoom 转场背景色
  Color? zoomBackgroundColor;
  /// 正向动画时长（毫秒）
  double durationMs = 300;
  /// 反向动画时长（毫秒）
  double reverseDurationMs = 300;
  /// 是否不透明
  bool opaque = true;
  /// 点击遮罩可关闭
  bool barrierDismissible = false;
  /// 遮罩颜色
  Color? barrierColor;
  /// 遮罩语义标签
  _BarrierLabelKind barrierLabelKind = _BarrierLabelKind.nil;
  /// 离开后是否保持状态
  bool maintainState = true;
  /// 是否全屏对话框
  bool fullscreenDialog = false;
  /// 是否允许快照
  bool allowSnapshotting = true;
  /// 是否请求焦点
  _Tri requestFocusKind = _Tri.nil;
  /// 是否传入 RouteSettings
  bool useSettings = false;
  /// 最近事件
  String lastEvent = '—';

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: hideApp
          ? null
          : AppBar(
              title: Text(widget.title ?? "$widget"),
              actions: [
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
    final scheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: scheme.surfaceContainerLowest,
      child: Column(
        children: [
          buildPreview(),
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
                        NLangEnum.en: 'Widget PageRouteBuilder',
                        NLangEnum.zh: '组件 PageRouteBuilder',
                      },
                      items: [
                        {
                          NLangEnum.en:
                              'pageBuilder builds the next page. The original body Text(arguments) is shown after push.',
                          NLangEnum.zh: 'pageBuilder 负责下一页内容。点「打开下一页」后仍显示原来的 Text(arguments)。',
                        },
                        {
                          NLangEnum.en:
                              'transitionsBuilder maps to PageTransitionsBuilder. none is the default jump cut.',
                          NLangEnum.zh: 'transitionsBuilder 对应 Material 的 PageTransitionsBuilder。none 是默认无动画跳切。',
                        },
                        {
                          NLangEnum.en:
                              'opaque false lets barrierColor show through a transparent next page. barrierDismissible pops on scrim tap.',
                          NLangEnum.zh: 'opaque 为 false 时下一页透明，才能看到 barrierColor。barrierDismissible 点遮罩可关闭。',
                        },
                      ],
                    ),
                    buildConstructCard(),
                    buildSurfaceCard(),
                    buildDurationCard(),
                    buildBehaviorCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPreview() {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border(
          bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.65)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          children: [
            Text(
              nameOfKind(transitionKind),
              style: theme.textTheme.titleSmall?.copyWith(color: scheme.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              lastEvent,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: onOpenNext,
              child: const Text('打开下一页'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'transitionsBuilder',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'transitionsBuilder',
            child: buildChoiceChips(
              values: _TransitionKind.values,
              isSelected: (e) => transitionKind == e,
              labelOf: nameOfKind,
              onChanged: onTransitionKind,
            ),
          ),
          if (transitionKind == _TransitionKind.zoom) ...[
            buildSwitch(
              title: 'Zoom.allowSnapshotting',
              value: zoomAllowSnapshotting,
              onChanged: onZoomAllowSnapshotting,
            ),
            buildSwitch(
              title: 'Zoom.allowEnterRouteSnapshotting',
              value: zoomAllowEnterRouteSnapshotting,
              onChanged: onZoomAllowEnterRouteSnapshotting,
            ),
            buildField(
              label: 'Zoom.backgroundColor',
              showTopGap: true,
              child: buildColorDots(value: zoomBackgroundColor, onChanged: onZoomBackgroundColor),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.layers_rounded),
      title: '表面',
      subtitle: 'opaque · barrierDismissible · barrierColor · barrierLabel',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(title: 'opaque', value: opaque, onChanged: onOpaque),
          buildSwitch(
            title: 'barrierDismissible',
            value: barrierDismissible,
            onChanged: onBarrierDismissible,
          ),
          buildField(
            label: 'barrierColor',
            showTopGap: true,
            child: buildColorDots(value: barrierColor, onChanged: onBarrierColor),
          ),
          buildField(
            label: 'barrierLabel',
            showTopGap: true,
            child: buildChoiceChips(
              values: _BarrierLabelKind.values,
              isSelected: (e) => barrierLabelKind == e,
              labelOf: (e) {
                switch (e) {
                  case _BarrierLabelKind.nil:
                    return 'null';
                  case _BarrierLabelKind.dismiss:
                    return 'dismiss';
                }
              },
              onChanged: onBarrierLabelKind,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDurationCard() {
    return NDecorationCard(
      icon: const Icon(Icons.timer_outlined),
      title: '时长',
      subtitle: 'transitionDuration · reverseTransitionDuration',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSlider(
            label: 'transitionDuration',
            value: durationMs,
            min: 0,
            max: 2000,
            onChanged: onDurationMs,
            durationLabel: true,
          ),
          buildSlider(
            label: 'reverseTransitionDuration',
            value: reverseDurationMs,
            min: 0,
            max: 2000,
            onChanged: onReverseDurationMs,
            durationLabel: true,
          ),
        ],
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_rounded),
      title: '行为',
      subtitle: 'maintainState · fullscreenDialog · allowSnapshotting · requestFocus · settings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(title: 'maintainState', value: maintainState, onChanged: onMaintainState),
          buildSwitch(
            title: 'fullscreenDialog',
            value: fullscreenDialog,
            onChanged: onFullscreenDialog,
          ),
          buildSwitch(
            title: 'allowSnapshotting',
            value: allowSnapshotting,
            onChanged: onAllowSnapshotting,
          ),
          buildField(
            label: 'requestFocus',
            showTopGap: true,
            child: buildChoiceChips(
              values: _Tri.values,
              isSelected: (e) => requestFocusKind == e,
              labelOf: (e) {
                switch (e) {
                  case _Tri.nil:
                    return 'null';
                  case _Tri.yes:
                    return 'true';
                  case _Tri.no:
                    return 'false';
                }
              },
              onChanged: onRequestFocusKind,
            ),
          ),
          buildSwitch(title: 'settings', value: useSettings, onChanged: onUseSettings),
        ],
      ),
    );
  }

  Widget buildNextPage() {
    return Builder(
      builder: (ctx) {
        final arguments = ModalRoute.of(ctx)?.settings.arguments;
        return Scaffold(
          backgroundColor: opaque ? null : Colors.transparent,
          appBar: AppBar(
            title: const Text('下一页'),
          ),
          body: Text('$arguments'),
        );
      },
    );
  }

  Widget buildField({
    required String label,
    required Widget child,
    bool showTopGap = false,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTopGap) const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
              fontSize: 12.5,
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget buildChoiceChips<T>({
    required List<T> values,
    required bool Function(T value) isSelected,
    required String Function(T value) labelOf,
    required ValueChanged<T> onChanged,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((e) {
        final selected = isSelected(e);
        return ChoiceChip(
          label: Text(labelOf(e)),
          selected: selected,
          showCheckmark: false,
          selectedColor: scheme.primaryContainer,
          labelStyle: TextStyle(
            color: selected ? scheme.onPrimaryContainer : scheme.onSurface,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            fontFamily: 'monospace',
            fontSize: 12.5,
          ),
          side: BorderSide(
            color: selected ? scheme.primary.withValues(alpha: 0.35) : scheme.outlineVariant.withValues(alpha: 0.65),
          ),
          onSelected: (on) {
            if (on) {
              onChanged(e);
            }
          },
        );
      }).toList(),
    );
  }

  Widget buildColorDots({
    required Color? value,
    required ValueChanged<Color?> onChanged,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppColor.colorOptions.map((e) {
        final selected = value == e;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onChanged(e),
            customBorder: const CircleBorder(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: e ?? scheme.surfaceContainerHighest,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? scheme.primary : scheme.outlineVariant.withValues(alpha: 0.65),
                  width: selected ? 2 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: scheme.primary.withValues(alpha: 0.28),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: e == null
                  ? Text(
                      '默',
                      style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                    )
                  : selected
                      ? Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: ThemeData.estimateBrightnessForColor(e) == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                        )
                      : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    bool durationLabel = false,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return NSlider(
      leading: SizedBox(
        width: 108,
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurface,
            fontFamily: 'monospace',
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      min: min,
      max: max,
      value: value,
      onChanged: onChanged,
      activeColor: scheme.primary,
      trailingBuilder: durationLabel
          ? (context, v) {
              final ms = v.round();
              final text = ms >= 1000 ? '${(ms / 1000).toStringAsFixed(ms % 1000 == 0 ? 0 : 1)}s' : '${ms}ms';
              return Text(
                text,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              );
            }
          : null,
    );
  }

  Widget buildSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SwitchListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: scheme.onSurface,
          fontSize: 13.5,
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  String nameOfKind(_TransitionKind kind) {
    switch (kind) {
      case _TransitionKind.openUpwards:
        return 'OpenUpwards';
      case _TransitionKind.zoom:
        return 'Zoom';
      case _TransitionKind.cupertino:
        return 'Cupertino';
      case _TransitionKind.fadeUpwards:
        return 'FadeUpwards';
      case _TransitionKind.none:
        return 'none';
      case _TransitionKind.predictiveBack:
        return 'PredictiveBack';
    }
  }

  PageTransitionsBuilder? pageTransitionsBuilderOf() {
    switch (transitionKind) {
      case _TransitionKind.openUpwards:
        return const OpenUpwardsPageTransitionsBuilder();
      case _TransitionKind.zoom:
        return ZoomPageTransitionsBuilder(
          allowSnapshotting: zoomAllowSnapshotting,
          allowEnterRouteSnapshotting: zoomAllowEnterRouteSnapshotting,
          backgroundColor: zoomBackgroundColor,
        );
      case _TransitionKind.cupertino:
        return const CupertinoPageTransitionsBuilder();
      case _TransitionKind.fadeUpwards:
        return const FadeUpwardsPageTransitionsBuilder();
      case _TransitionKind.none:
        return null;
      case _TransitionKind.predictiveBack:
        return const PredictiveBackPageTransitionsBuilder();
    }
  }

  bool? requestFocusOf() {
    switch (requestFocusKind) {
      case _Tri.nil:
        return null;
      case _Tri.yes:
        return true;
      case _Tri.no:
        return false;
    }
  }

  String? barrierLabelOf() {
    switch (barrierLabelKind) {
      case _BarrierLabelKind.nil:
        return null;
      case _BarrierLabelKind.dismiss:
        return 'dismiss';
    }
  }

  RouteSettings settingsOf() {
    final arguments = ModalRoute.of(context)?.settings.arguments ?? {'from': 'PageBuilderDemo'};
    if (!useSettings) {
      return RouteSettings(arguments: arguments);
    }
    return RouteSettings(
      name: 'pageBuilderNext',
      arguments: arguments,
    );
  }

  Future<void> onOpenNext() async {
    lastEvent = 'push ${nameOfKind(transitionKind)}';
    DLog.d(lastEvent);
    setState(() {});
    final result = await Navigator.of(context).push(
      _PageBuilderRoute(
        pageTransitionsBuilder: pageTransitionsBuilderOf(),
        pageBuilder: (ctx, animation, secondaryAnimation) {
          return buildNextPage();
        },
        settings: settingsOf(),
        requestFocus: requestFocusOf(),
        transitionDuration: Duration(milliseconds: durationMs.round()),
        reverseTransitionDuration: Duration(milliseconds: reverseDurationMs.round()),
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabelOf(),
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        allowSnapshotting: allowSnapshotting,
      ),
    );
    lastEvent = 'pop result=$result';
    DLog.d(lastEvent);
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void onTransitionKind(_TransitionKind value) {
    transitionKind = value;
    setState(() {});
  }

  void onZoomAllowSnapshotting(bool value) {
    zoomAllowSnapshotting = value;
    setState(() {});
  }

  void onZoomAllowEnterRouteSnapshotting(bool value) {
    zoomAllowEnterRouteSnapshotting = value;
    setState(() {});
  }

  void onZoomBackgroundColor(Color? value) {
    zoomBackgroundColor = value;
    setState(() {});
  }

  void onDurationMs(double value) {
    durationMs = value;
    setState(() {});
  }

  void onReverseDurationMs(double value) {
    reverseDurationMs = value;
    setState(() {});
  }

  void onOpaque(bool value) {
    opaque = value;
    setState(() {});
  }

  void onBarrierDismissible(bool value) {
    barrierDismissible = value;
    setState(() {});
  }

  void onBarrierColor(Color? value) {
    barrierColor = value;
    setState(() {});
  }

  void onBarrierLabelKind(_BarrierLabelKind value) {
    barrierLabelKind = value;
    setState(() {});
  }

  void onMaintainState(bool value) {
    maintainState = value;
    setState(() {});
  }

  void onFullscreenDialog(bool value) {
    fullscreenDialog = value;
    setState(() {});
  }

  void onAllowSnapshotting(bool value) {
    allowSnapshotting = value;
    setState(() {});
  }

  void onRequestFocusKind(_Tri value) {
    requestFocusKind = value;
    setState(() {});
  }

  void onUseSettings(bool value) {
    useSettings = value;
    setState(() {});
  }

  void onReset() {
    transitionKind = _TransitionKind.openUpwards;
    zoomAllowSnapshotting = true;
    zoomAllowEnterRouteSnapshotting = true;
    zoomBackgroundColor = null;
    durationMs = 300;
    reverseDurationMs = 300;
    opaque = true;
    barrierDismissible = false;
    barrierColor = null;
    barrierLabelKind = _BarrierLabelKind.nil;
    maintainState = true;
    fullscreenDialog = false;
    allowSnapshotting = true;
    requestFocusKind = _Tri.nil;
    useSettings = false;
    lastEvent = '—';
    setState(() {});
  }
}

/// 用 PageTransitionsBuilder 驱动 PageRouteBuilder 转场
class _PageBuilderRoute<T> extends PageRouteBuilder<T> {
  _PageBuilderRoute({
    required this.pageTransitionsBuilder,
    required super.pageBuilder,
    super.settings,
    super.requestFocus,
    super.transitionDuration,
    super.reverseTransitionDuration,
    super.opaque,
    super.barrierDismissible,
    super.barrierColor,
    super.barrierLabel,
    super.maintainState,
    super.fullscreenDialog,
    super.allowSnapshotting,
  });

  final PageTransitionsBuilder? pageTransitionsBuilder;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final builder = pageTransitionsBuilder;
    if (builder == null) {
      return child;
    }
    return builder.buildTransitions(this, context, animation, secondaryAnimation, child);
  }
}
