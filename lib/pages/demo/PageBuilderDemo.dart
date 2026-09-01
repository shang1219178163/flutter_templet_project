import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_color_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// transitionsBuilder 预设，对应 Material PageTransitionsBuilder
enum _TransitionKind {
  openUpwards(label: 'OpenUpwards'),
  zoom(label: 'Zoom'),
  cupertino(label: 'Cupertino'),
  fadeUpwards(label: 'FadeUpwards'),
  none(label: 'none'),
  predictiveBack(label: 'PredictiveBack'),
  ;
  const _TransitionKind({required this.label});
  final String label;
}

/// barrierLabel 预设
enum _BarrierLabelKind {
  nil(label: 'null', value: null),
  dismiss(label: 'dismiss', value: 'dismiss'),
  ;
  const _BarrierLabelKind({required this.label, required this.value});
  final String label;
  final String? value;
}

class PageBuilderDemo extends StatefulWidget {
  const PageBuilderDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<PageBuilderDemo> createState() => _PageBuilderDemoState();
}

class _PageBuilderDemoState extends State<PageBuilderDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

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
  bool? requestFocus;
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
    final scheme = theme.colorScheme;
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
    final scheme = theme.colorScheme;
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
                              'opaque false lets barrierColor show through a transparent next page. barrierDismissible pops on scrim tap.',
                          NLangEnum.zh: 'opaque 为 false 时下一页透明，才能看到 barrierColor。barrierDismissible 点遮罩可关闭。',
                        },
                      ],
                    ),
                    buildConstructCard(),
                    buildSurfaceCard(),
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
              transitionKind.label,
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
          NChoiceChipListItem<_TransitionKind>(
            title: const Text('transitionsBuilder'),
            values: _TransitionKind.values,
            value: transitionKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('transitionsBuilder ${e.label}', () => transitionKind = e),
          ),
          if (transitionKind == _TransitionKind.zoom) ...[
            NSwitchListTile(
              title: const Text('Zoom.allowSnapshotting'),
              value: zoomAllowSnapshotting,
              onChanged: (v) => onMark('Zoom.allowSnapshotting $v', () => zoomAllowSnapshotting = v),
            ),
            NSwitchListTile(
              title: const Text('Zoom.allowEnterRouteSnapshotting'),
              value: zoomAllowEnterRouteSnapshotting,
              onChanged: (v) => onMark('Zoom.allowEnterRouteSnapshotting $v', () => zoomAllowEnterRouteSnapshotting = v),
            ),
            const SizedBox(height: 8),
            NChoiceColorListItem(
              title: const Text('Zoom.backgroundColor'),
              value: zoomBackgroundColor,
              onChanged: (e) => onMark('Zoom.backgroundColor ${e ?? 'null'}', () => zoomBackgroundColor = e),
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
      subtitle: 'opaque · barrier · duration',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NSwitchListTile(title: const Text('opaque'), value: opaque, onChanged: (v) => onMark('opaque $v', () => opaque = v)),
          NSwitchListTile(
            title: const Text('barrierDismissible'),
            value: barrierDismissible,
            onChanged: (v) => onMark('barrierDismissible $v', () => barrierDismissible = v),
          ),
          const SizedBox(height: 8),
          NChoiceColorListItem(
            title: const Text('barrierColor'),
            value: barrierColor,
            onChanged: (e) => onMark('barrierColor ${e ?? 'null'}', () => barrierColor = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem<_BarrierLabelKind>(
            title: const Text('barrierLabel'),
            values: _BarrierLabelKind.values,
            value: barrierLabelKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('barrierLabel ${e.label}', () => barrierLabelKind = e),
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('transitionDuration'),
            min: 0,
            max: 2000,
            value: durationMs.clamp(0, 2000),
            onChanged: (v) => onMark('transitionDuration ${v.round()}ms', () => durationMs = v),
            activeColor: theme.colorScheme.primary,
            valueBuilder: (context, v) {
              final ms = v.round();
              final text = ms >= 1000 ? '${(ms / 1000).toStringAsFixed(ms % 1000 == 0 ? 0 : 1)}s' : '${ms}ms';
              return Text(
                text,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              );
            },
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('reverseTransitionDuration'),
            min: 0,
            max: 2000,
            value: reverseDurationMs.clamp(0, 2000),
            onChanged: (v) => onMark('reverseTransitionDuration ${v.round()}ms', () => reverseDurationMs = v),
            activeColor: theme.colorScheme.primary,
            valueBuilder: (context, v) {
              final ms = v.round();
              final text = ms >= 1000 ? '${(ms / 1000).toStringAsFixed(ms % 1000 == 0 ? 0 : 1)}s' : '${ms}ms';
              return Text(
                text,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              );
            },
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
          NSwitchListTile(
            title: const Text('maintainState'),
            value: maintainState,
            onChanged: (v) => onMark('maintainState $v', () => maintainState = v),
          ),
          NSwitchListTile(
            title: const Text('fullscreenDialog'),
            value: fullscreenDialog,
            onChanged: (v) => onMark('fullscreenDialog $v', () => fullscreenDialog = v),
          ),
          NSwitchListTile(
            title: const Text('allowSnapshotting'),
            value: allowSnapshotting,
            onChanged: (v) => onMark('allowSnapshotting $v', () => allowSnapshotting = v),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem<bool?>(
            title: const Text('requestFocus'),
            values: const [null, true, false],
            value: requestFocus,
            labelOf: (e) => e == null ? 'null' : '$e',
            onChanged: (e) => onMark('requestFocus $e', () => requestFocus = e),
          ),
          NSwitchListTile(title: const Text('settings'), value: useSettings, onChanged: (v) => onMark('settings $v', () => useSettings = v)),
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


  PageTransitionsBuilder? pageTransitionsBuilderOf() {
    return switch (transitionKind) {
      _TransitionKind.openUpwards => const OpenUpwardsPageTransitionsBuilder(),
      _TransitionKind.zoom => ZoomPageTransitionsBuilder(
          allowSnapshotting: zoomAllowSnapshotting,
          allowEnterRouteSnapshotting: zoomAllowEnterRouteSnapshotting,
          backgroundColor: zoomBackgroundColor,
        ),
      _TransitionKind.cupertino => const CupertinoPageTransitionsBuilder(),
      _TransitionKind.fadeUpwards => const FadeUpwardsPageTransitionsBuilder(),
      _TransitionKind.none => null,
      _TransitionKind.predictiveBack => const PredictiveBackPageTransitionsBuilder(),
    };
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
    lastEvent = 'push ${transitionKind.label}';
    DLog.d(lastEvent);
    setState(() {});
    final result = await Navigator.of(context).push(
      _PageBuilderRoute(
        pageTransitionsBuilder: pageTransitionsBuilderOf(),
        pageBuilder: (ctx, animation, secondaryAnimation) {
          return buildNextPage();
        },
        settings: settingsOf(),
        requestFocus: requestFocus,
        transitionDuration: Duration(milliseconds: durationMs.round()),
        reverseTransitionDuration: Duration(milliseconds: reverseDurationMs.round()),
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabelKind.value,
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

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
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
    requestFocus = null;
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
