import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_flexible_cell.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

/// prefix 传值方式
enum _PrefixKind { widgetDefault, hidden, logo }

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
  _PrefixKind prefixKind = _PrefixKind.widgetDefault;
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
                    decoration: buildDecoration(),
                    prefix: buildPrefix(),
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

  Decoration? buildDecoration() {
    if (!useDecoration) {
      return null;
    }
    return BoxDecoration(
      color: backgroundColor ?? Colors.orange,
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    );
  }

  Widget? buildPrefix() {
    return switch (prefixKind) {
      _PrefixKind.widgetDefault => null,
      _PrefixKind.hidden => const SizedBox.shrink(),
      _PrefixKind.logo => const Padding(
          padding: EdgeInsets.only(right: 6),
          child: FlutterLogo(size: 16),
        ),
    };
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
          buildField(
            label: 'prefix',
            child: buildChoiceChips(
              values: _PrefixKind.values,
              isSelected: (e) => prefixKind == e,
              labelOf: (e) => switch (e) {
                _PrefixKind.widgetDefault => 'null / 默认图标',
                _PrefixKind.hidden => 'SizedBox.shrink',
                _PrefixKind.logo => 'FlutterLogo',
              },
              onChanged: (e) => onMark('prefix ${e.name}', () => prefixKind = e),
            ),
          ),
          buildSwitch(title: 'suffix 后缀图标', value: useSuffix, onChanged: (v) => onMark('suffix $v', () => useSuffix = v)),
          buildSwitch(title: 'decoration 自定义装饰', value: useDecoration, onChanged: (v) => onMark('decoration $v', () => useDecoration = v)),
          if (useDecoration)
            buildField(
              label: 'backgroundColor',
              child: buildColorDots(
                value: backgroundColor,
                onChanged: (v) => onMark('backgroundColor ${v ?? 'null'}', () => backgroundColor = v),
              ),
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
          buildSlider(label: 'padding H', value: padH, min: 0, max: 32, onChanged: (v) => onMark('paddingH ${v.round()}', () => padH = v)),
          buildSlider(label: 'padding V', value: padV, min: 0, max: 24, onChanged: (v) => onMark('paddingV ${v.round()}', () => padV = v)),
          buildSlider(label: 'minWidth', value: minWidth, min: 0, max: 200, onChanged: onMinWidth),
          buildSlider(label: 'maxWidth', value: maxWidth, min: 80, max: 400, onChanged: onMaxWidth),
          buildSlider(label: 'fontSize', value: fontSize, min: 12, max: 22, onChanged: (v) => onMark('fontSize ${v.round()}', () => fontSize = v)),
          buildSlider(
            label: 'maxLines',
            value: maxLines.toDouble(),
            min: 1,
            max: 8,
            onChanged: (v) => onMark('maxLines ${v.round()}', () => maxLines = v.round().clamp(1, 8)),
          ),
          buildSlider(
            label: 'itemCount',
            value: itemCount.toDouble(),
            min: 1,
            max: 3,
            onChanged: (v) => onMark('itemCount ${v.round()}', () => itemCount = v.round().clamp(1, 3)),
          ),
          if (useDecoration)
            buildSlider(label: 'borderRadius', value: borderRadius, min: 0, max: 28, onChanged: (v) => onMark('borderRadius ${v.round()}', () => borderRadius = v)),
        ],
      ),
    );
  }

  Widget buildField({
    required String label,
    required Widget child,
  }) {
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
    final scheme = theme.colorScheme;
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
    final scheme = theme.colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppColor.colorOptions.map((e) {
        final selected = value == e;
        Widget? mark;
        if (e == null) {
          mark = Text(
            '默',
            style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
          );
        } else if (selected) {
          mark = Icon(
            Icons.check_rounded,
            size: 16,
            color: ThemeData.estimateBrightnessForColor(e) == Brightness.dark ? Colors.white : Colors.black87,
          );
        }
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
              child: mark,
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
  }) {
    final scheme = theme.colorScheme;
    return NSliderListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      min: min,
      max: max,
      value: value.clamp(min, max),
      onChanged: onChanged,
      activeColor: scheme.primary,
    );
  }

  Widget buildSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
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
    onSnack('Flexible 行 onTap');
  }

  void onTapOutlined() {
    DLog.d('OutlinedButton');
    onSnack('OutlinedButton');
  }

  void onSnack(String message) {
    lastEvent = message;
    final scheme = theme.colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    setState(() {});
  }

  void onReset() {
    prefixKind = _PrefixKind.widgetDefault;
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
