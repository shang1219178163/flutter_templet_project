import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_color_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_flexible_cell.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/snack_util.dart';
import 'package:get/get.dart';

/// prefix 传值方式
enum _PrefixKind {
  none(
    label: 'none',
    widget: null,
  ),
  notice(
    label: 'Icon',
    widget: Padding(
      padding: EdgeInsets.only(right: 6),
      child: Icon(Icons.notifications_active),
    ),
  ),
  logo(
    label: 'FlutterLogo',
    widget: Padding(
      padding: EdgeInsets.only(right: 6),
      child: FlutterLogo(size: 16),
    ),
  );

  const _PrefixKind({
    required this.label,
    required this.widget,
  });

  /// Chip 文案
  final String label;

  /// 对应 prefix；[none] 为 null（走组件默认图标）
  final Widget? widget;
}

class AutoLayoutDemo extends StatefulWidget {
  AutoLayoutDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<AutoLayoutDemo> createState() => _AutoLayoutDemoState();
}

class _AutoLayoutDemoState extends State<AutoLayoutDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

  final scrollController = ScrollController();

  /// prefix 传值
  _PrefixKind prefixKind = _PrefixKind.none;

  /// 是否显示 suffix
  bool useSuffix = true;

  /// 是否自定义 decoration
  bool useDecoration = true;

  /// 水平内边距
  double padH = 16;

  /// 垂直内边距
  double padV = 7;

  /// 最小宽度
  double minWidth = 100;

  /// 最大宽度
  double maxWidth = 300;

  /// 圆角
  double borderRadius = 16;

  /// 字号
  double fontSize = 16;

  /// 预览条数
  int itemCount = 3;

  /// 最大行数
  int maxLines = 6;

  /// 背景色
  Color? backgroundColor = Colors.orange;

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
                        NLangEnum.en: 'Widget NFlexibleCell',
                        NLangEnum.zh: '组件 NFlexibleCell',
                      },
                      items: [
                        {
                          NLangEnum.en: 'NFlexibleCell shrinks to content within minWidth / maxWidth.',
                          NLangEnum.zh: 'NFlexibleCell 在 minWidth / maxWidth 内按内容自适应宽度。',
                        },
                        {
                          NLangEnum.en: 'prefix defaults to a bell icon when null; suffix is omitted when null.',
                          NLangEnum.zh: 'prefix 为 null 时用默认铃铛；suffix 为 null 时不显示。',
                        },
                      ],
                    ),
                    buildConstructCard(),
                    buildSizeCard(),
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 280),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 1; i <= itemCount; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: NFlexibleCell(
                    padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
                    constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
                    decoration: useDecoration
                        ? BoxDecoration(
                            color: backgroundColor ?? Colors.orange,
                            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                          )
                        : null,
                    prefix: prefixKind.widget,
                    suffix: buildSuffix(),
                    content: NText(
                      '自适应横向布局' * i,
                      textAlign: TextAlign.center,
                      fontSize: fontSize.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      maxLines: maxLines,
                    ),
                  ),
                ),
              buildOriginRow(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'constraints: ${minWidth.round()} – ${maxWidth.round()} · $lastEvent',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? buildSuffix() {
    if (!useSuffix) {
      return null;
    }
    return const Padding(
      padding: EdgeInsets.only(left: 6),
      child: Icon(
        Icons.notification_add,
        color: Colors.white,
        size: 16,
      ),
    );
  }

  Widget buildOriginRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const FlutterLogo(),
        Flexible(
          child: buildText(
            text: '自适应横向布局' * 10,
            onTap: onTapFlexibleText,
          ),
        ),
        OutlinedButton(
          onPressed: onTapOutlined,
          child: const Text('OutlinedButton'),
        ),
      ],
    );
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'prefix · suffix · decoration',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceChipListItem<_PrefixKind>(
            title: const Text('prefix'),
            values: _PrefixKind.values,
            value: prefixKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('prefix ${e.name}', () => prefixKind = e),
          ),
          NSwitchListTile(
              title: const Text('suffix 后缀图标'),
              value: useSuffix,
              onChanged: (v) => onMark('suffix $v', () => useSuffix = v)),
          NSwitchListTile(
              title: const Text('decoration 自定义装饰'),
              value: useDecoration,
              onChanged: (v) => onMark('decoration $v', () => useDecoration = v)),
          if (useDecoration)
            NChoiceColorListItem(
              title: const Text('backgroundColor'),
              value: backgroundColor,
              onChanged: (v) => onMark('backgroundColor ${v ?? 'null'}', () => backgroundColor = v),
            ),
        ],
      ),
    );
  }

  Widget buildSizeCard() {
    return NDecorationCard(
      icon: const Icon(Icons.straighten_rounded),
      title: '尺寸',
      subtitle: 'padding · constraints · fontSize · maxLines',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('padding H'),
            min: 0,
            max: 32,
            value: padH.clamp(0, 32),
            onChanged: (v) => onMark('paddingH ${v.round()}', () => padH = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('padding V'),
            min: 0,
            max: 24,
            value: padV.clamp(0, 24),
            onChanged: (v) => onMark('paddingV ${v.round()}', () => padV = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('minWidth'),
            min: 0,
            max: 200,
            value: minWidth.clamp(0, 200),
            onChanged: onMinWidth,
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('maxWidth'),
            min: 80,
            max: 400,
            value: maxWidth.clamp(80, 400),
            onChanged: onMaxWidth,
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('fontSize'),
            min: 12,
            max: 22,
            value: fontSize.clamp(12, 22),
            onChanged: (v) => onMark('fontSize ${v.round()}', () => fontSize = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('maxLines'),
            min: 1,
            max: 8,
            value: maxLines.toDouble().clamp(1, 8),
            onChanged: (v) => onMark('maxLines ${v.round()}', () => maxLines = v.round().clamp(1, 8)),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('itemCount'),
            min: 1,
            max: 3,
            value: itemCount.toDouble().clamp(1, 3),
            onChanged: (v) => onMark('itemCount ${v.round()}', () => itemCount = v.round().clamp(1, 3)),
            activeColor: theme.colorScheme.primary,
          ),
          if (useDecoration)
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('borderRadius'),
              min: 0,
              max: 28,
              value: borderRadius.clamp(0, 28),
              onChanged: (v) => onMark('borderRadius ${v.round()}', () => borderRadius = v),
              activeColor: theme.colorScheme.primary,
            ),
        ],
      ),
    );
  }

  Widget buildText({
    required String text,
    Color color = Colors.green,
    VoidCallback? onTap,
  }) {
    return buildTag(
      onTap: onTap,
      content: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: color),
      ),
      prefix: Padding(
        padding: const EdgeInsets.only(right: 4),
        child: FlutterLogo(
          size: 20,
          textColor: color,
        ),
      ),
      suffix: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Icon(
          Icons.arrow_forward_ios_sharp,
          size: 20,
          color: color,
        ),
      ),
    );
  }

  /// 原 Demo 的 Flexible 行
  Widget buildTag({
    required VoidCallback? onTap,
    Color color = Colors.green,
    Widget? prefix,
    required Widget content,
    Widget? suffix,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.all(Radius.circular(8.w)),
        ),
        constraints: const BoxConstraints(
          minWidth: 0,
          maxWidth: double.infinity,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            prefix ??
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.send,
                    size: 20,
                    color: color,
                  ),
                ),
            Flexible(
              child: content,
            ),
            if (suffix != null) suffix,
          ],
        ),
      ),
    );
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onMinWidth(double value) {
    onMark('minWidth ${value.round()}', () {
      minWidth = value;
      if (minWidth > maxWidth) {
        maxWidth = minWidth;
      }
    });
  }

  void onMaxWidth(double value) {
    onMark('maxWidth ${value.round()}', () {
      maxWidth = value;
      if (maxWidth < minWidth) {
        minWidth = maxWidth;
      }
    });
  }

  void onTapFlexibleText() {
    DLog.d('onTap');
    onMark('Flexible 行 onTap');
    SnackUtil.show('Flexible 行 onTap');
  }

  void onTapOutlined() {
    DLog.d('OutlinedButton');
    onMark('OutlinedButton');
    SnackUtil.show('OutlinedButton');
  }

  void onReset() {
    prefixKind = _PrefixKind.none;
    useSuffix = true;
    useDecoration = true;
    padH = 16;
    padV = 7;
    minWidth = 100;
    maxWidth = 300;
    borderRadius = 16;
    fontSize = 16;
    itemCount = 3;
    maxLines = 6;
    backgroundColor = Colors.orange;
    lastEvent = '—';
    setState(() {});
  }
}
