import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

class MaterialDemo extends StatefulWidget {
  const MaterialDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MaterialDemo> createState() => _MaterialDemoState();
}

class _MaterialDemoState extends State<MaterialDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  late final theme = Theme.of(context);

  final scrollController = ScrollController();

  /// 最近事件
  String lastEvent = '—';
  /// 材质类型
  MaterialType type = MaterialType.canvas;
  /// 海拔阴影
  double elevation = 10;
  /// 填充色
  Color? color = Colors.red;
  /// 阴影色
  Color? shadowColor = Colors.blue;
  /// 表面色调
  Color? surfaceTintColor;
  /// 是否传入 textStyle
  bool useTextStyle = false;
  /// 文字字号
  double textFontSize = 14;
  /// 文字颜色
  Color? textColor;
  /// 是否传入 borderRadius
  bool useBorderRadius = false;
  /// 圆角半径
  double borderRadius = 8;
  /// 外形
  ShapeKind shapeKind = ShapeKind.none;
  /// 外形圆角
  double shapeRadius = 8;
  /// 边框画在前景
  bool borderOnForeground = true;
  /// 裁剪
  ClipKind clipKind = ClipKind.none;
  /// 动画时长（毫秒）
  double animMs = 200;

  bool get isCircle => type == MaterialType.circle;

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
                        NLangEnum.en: 'Widget Material',
                        NLangEnum.zh: '组件 Material',
                      },
                      items: [
                        {
                          NLangEnum.en: 'Left tile and right TextButton are the original children. circle forbids shape / borderRadius.',
                          NLangEnum.zh: '左侧色块与右侧 TextButton 是原内容。circle 下 shape / borderRadius 必须为 null。',
                        },
                      ],
                    ),
                    buildSurfaceCard(),
                    buildShapeCard(),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 140,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: buildMaterial(
                      child: InkWell(
                        onTap: () => onTap('InkWell ${type.name}'),
                        child: Container(
                          alignment: Alignment.center,
                          height: 60,
                          width: 70,
                          decoration: BoxDecoration(border: Border.all()),
                          child: Text(type.name),
                        ),
                      ),
                    ),
                  ),
                  buildMaterial(
                    child: TextButton(
                      onPressed: () => onTap('ElevatedButton'),
                      child: const Text('ElevatedButton'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'lastEvent: $lastEvent',
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMaterial({required Widget child}) {
    return Material(
      type: type,
      elevation: elevation,
      color: color,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      textStyle: useTextStyle ? TextStyle(fontSize: textFontSize, color: textColor) : null,
      borderRadius: (isCircle || shapeKind != ShapeKind.none || !useBorderRadius)
          ? null
          : BorderRadius.circular(borderRadius),
      shape: buildShape(),
      borderOnForeground: borderOnForeground,
      clipBehavior: switch (clipKind) {
        ClipKind.hardEdge => Clip.hardEdge,
        ClipKind.antiAlias => Clip.antiAlias,
        ClipKind.antiAliasWithSaveLayer => Clip.antiAliasWithSaveLayer,
        ClipKind.nil || ClipKind.none => Clip.none,
      },
      animationDuration: Duration(milliseconds: animMs.round()),
      child: child,
    );
  }

  ShapeBorder? buildShape() {
    if (isCircle) {
      return null;
    }
    return switch (shapeKind) {
      ShapeKind.none => null,
      ShapeKind.rounded => RoundedRectangleBorder(borderRadius: BorderRadius.circular(shapeRadius)),
      ShapeKind.stadium => const StadiumBorder(),
    };
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.layers_outlined),
      title: '表面',
      subtitle: 'type  elevation  color  shadowColor  surfaceTintColor',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('type'),
          buildChoiceChips(
            values: MaterialType.values,
            value: type,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('type ${e.name}', () {
              type = e;
              if (e == MaterialType.circle) {
                shapeKind = ShapeKind.none;
                useBorderRadius = false;
              }
            }),
          ),
          buildSlider(
            label: 'elevation',
            value: elevation,
            min: 0,
            max: 24,
            onChanged: (v) => onMark('elevation ${v.toStringAsFixed(1)}', () => elevation = v),
          ),
          buildColorRow('color', color, (v) => color = v),
          buildColorRow('shadowColor', shadowColor, (v) => shadowColor = v),
          buildColorRow('surfaceTintColor', surfaceTintColor, (v) => surfaceTintColor = v),
        ],
      ),
    );
  }

  Widget buildShapeCard() {
    return NDecorationCard(
      icon: const Icon(Icons.rounded_corner_outlined),
      title: '形状',
      subtitle: 'shape  borderRadius  clipBehavior  borderOnForeground  textStyle  animationDuration',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCircle) ...[
            const Text('shape'),
            buildChoiceChips(
              values: ShapeKind.values,
              value: shapeKind,
              labelOf: (e) => e == ShapeKind.none ? 'null' : e.name,
              onChanged: (e) => onMark('shape ${e == ShapeKind.none ? 'null' : e.name}', () {
                shapeKind = e;
                if (e != ShapeKind.none) {
                  useBorderRadius = false;
                }
              }),
            ),
            if (shapeKind == ShapeKind.rounded)
              buildSlider(
                label: 'shapeRadius',
                value: shapeRadius,
                min: 0,
                max: 32,
                onChanged: (v) => onMark('shapeRadius ${v.round()}', () => shapeRadius = v),
              ),
            if (shapeKind == ShapeKind.none) ...[
              buildSwitch(
                title: 'borderRadius',
                value: useBorderRadius,
                onChanged: (v) => onMark('borderRadius ${v ? 'on' : 'null'}', () => useBorderRadius = v),
              ),
              if (useBorderRadius)
                buildSlider(
                  label: 'borderRadius',
                  value: borderRadius,
                  min: 0,
                  max: 32,
                  onChanged: (v) => onMark('borderRadius ${v.round()}', () => borderRadius = v),
                ),
            ],
          ] else
            Text(
              'circle 下 shape / borderRadius 必须为 null',
              style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
            ),
          const Text('clipBehavior'),
          buildChoiceChips(
            values: ClipKind.values.where((e) => e != ClipKind.nil).toList(),
            value: clipKind == ClipKind.nil ? ClipKind.none : clipKind,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('clipBehavior ${e.name}', () => clipKind = e),
          ),
          buildSwitch(
            title: 'borderOnForeground',
            value: borderOnForeground,
            onChanged: (v) => onMark('borderOnForeground $v', () => borderOnForeground = v),
          ),
          buildSwitch(
            title: 'textStyle',
            value: useTextStyle,
            onChanged: (v) => onMark('textStyle ${v ? 'on' : 'null'}', () => useTextStyle = v),
          ),
          if (useTextStyle) ...[
            buildSlider(
              label: 'fontSize',
              value: textFontSize,
              min: 10,
              max: 22,
              onChanged: (v) => onMark('textStyle.fontSize ${v.toStringAsFixed(1)}', () => textFontSize = v),
            ),
            buildColorRow('textStyle.color', textColor, (v) => textColor = v),
          ],
          buildSlider(
            label: 'animationDuration',
            value: animMs,
            min: 0,
            max: 1000,
            durationLabel: true,
            onChanged: (v) => onMark('animationDuration ${v.round()}ms', () => animMs = v),
          ),
        ],
      ),
    );
  }

  Widget buildColorRow(String label, Color? value, ValueChanged<Color?> assign) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        buildColorDots(
          value: value,
          onChanged: (v) => onMark('$label ${v ?? 'null'}', () => assign(v)),
        ),
      ],
    );
  }

  Widget buildChoiceChips<T>({
    required List<T> values,
    required T value,
    required String Function(T) labelOf,
    required ValueChanged<T> onChanged,
  }) {
    final scheme = theme.colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((e) {
        final selected = e == value;
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
        return GestureDetector(
          onTap: () => onChanged(e),
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: e ?? scheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? scheme.primary : scheme.outlineVariant,
                width: selected ? 2 : 1,
              ),
            ),
            child: switch ((e, selected)) {
              (null, _) => Text('默', style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
              (final Color c, true) => Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: ThemeData.estimateBrightnessForColor(c) == Brightness.dark ? Colors.white : Colors.black87,
                ),
              _ => null,
            },
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
      valueBuilder: durationLabel
          ? (context, v) {
              final ms = v.round();
              final text = ms < 1000
                  ? '${ms}ms'
                  : '${(ms / 1000).toStringAsFixed(ms % 1000 == 0 ? 0 : 1)}s';
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

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    setState(() {});
  }

  void onReset() {
    lastEvent = '—';
    type = MaterialType.canvas;
    elevation = 10;
    color = Colors.red;
    shadowColor = Colors.blue;
    surfaceTintColor = null;
    useTextStyle = false;
    textFontSize = 14;
    textColor = null;
    useBorderRadius = false;
    borderRadius = 8;
    shapeKind = ShapeKind.none;
    shapeRadius = 8;
    borderOnForeground = true;
    clipKind = ClipKind.none;
    animMs = 200;
    setState(() {});
  }

  void onTap(String event) {
    DLog.d(event);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(event), duration: const Duration(milliseconds: 800)),
    );
    onMark(event);
  }
}
