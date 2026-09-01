import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_color_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/snack_util.dart';
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
    final baseStyle = theme.textTheme.bodyMedium!;
    return Material(
      type: type,
      elevation: elevation,
      color: color,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      textStyle: useTextStyle
          ? baseStyle.copyWith(fontSize: textFontSize, color: textColor)
          : baseStyle,
      borderRadius: (isCircle || shapeKind != ShapeKind.none || !useBorderRadius)
          ? null
          : BorderRadius.circular(borderRadius),
      shape: isCircle ? null : shapeKind.shape(roundedRadius: shapeRadius),
      borderOnForeground: borderOnForeground,
      clipBehavior: clipKind.clip,
      animationDuration: Duration(milliseconds: animMs.round()),
      child: child,
    );
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.layers_outlined),
      title: '表面',
      subtitle: 'type  elevation  color  shadowColor  surfaceTintColor',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceChipListItem<MaterialType>(
            title: const Text('type'),
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
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('elevation'),
            min: 0,
            max: 24,
            value: elevation.clamp(0, 24),
            onChanged: (v) => onMark('elevation ${v.toStringAsFixed(1)}', () => elevation = v),
            activeColor: theme.colorScheme.primary,
          ),
          NChoiceColorListItem(
            title: const Text('color'),
            value: color,
            onChanged: (v) => onMark('color ${v ?? 'null'}', () => color = v),
          ),
          NChoiceColorListItem(
            title: const Text('shadowColor'),
            value: shadowColor,
            onChanged: (v) => onMark('shadowColor ${v ?? 'null'}', () => shadowColor = v),
          ),
          NChoiceColorListItem(
            title: const Text('surfaceTintColor'),
            value: surfaceTintColor,
            onChanged: (v) => onMark('surfaceTintColor ${v ?? 'null'}', () => surfaceTintColor = v),
          ),
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
            NChoiceChipListItem<ShapeKind>(
              title: const Text('shape'),
              values: ShapeKind.values,
              value: shapeKind,
              labelOf: (e) => e.label,
              onChanged: (e) => onMark('shape ${e == ShapeKind.none ? 'null' : e.name}', () {
                shapeKind = e;
                if (e != ShapeKind.none) {
                  useBorderRadius = false;
                }
              }),
            ),
            if (shapeKind == ShapeKind.rounded)
              NSliderListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('shapeRadius'),
                min: 0,
                max: 32,
                value: shapeRadius.clamp(0, 32),
                onChanged: (v) => onMark('shapeRadius ${v.round()}', () => shapeRadius = v),
                activeColor: theme.colorScheme.primary,
              ),
            if (shapeKind == ShapeKind.none) ...[
              NSwitchListTile(
                title: const Text('borderRadius'),
                value: useBorderRadius,
                onChanged: (v) => onMark('borderRadius ${v ? 'on' : 'null'}', () => useBorderRadius = v),
              ),
              if (useBorderRadius)
                NSliderListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('borderRadius'),
                  min: 0,
                  max: 32,
                  value: borderRadius.clamp(0, 32),
                  onChanged: (v) => onMark('borderRadius ${v.round()}', () => borderRadius = v),
                  activeColor: theme.colorScheme.primary,
                ),
            ],
          ] else
            Text(
              'circle 下 shape / borderRadius 必须为 null',
              style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
            ),
          NChoiceChipListItem<ClipKind>(
            title: const Text('clipBehavior'),
            values: ClipKind.values,
            value: clipKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('clipBehavior ${e.label}', () => clipKind = e),
          ),
          NSwitchListTile(
            title: const Text('borderOnForeground'),
            value: borderOnForeground,
            onChanged: (v) => onMark('borderOnForeground $v', () => borderOnForeground = v),
          ),
          NSwitchListTile(
            title: const Text('textStyle'),
            value: useTextStyle,
            onChanged: (v) => onMark('textStyle ${v ? 'on' : 'null'}', () => useTextStyle = v),
          ),
          if (useTextStyle) ...[
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('fontSize'),
              min: 10,
              max: 22,
              value: textFontSize.clamp(10, 22),
              onChanged: (v) => onMark('textStyle.fontSize ${v.toStringAsFixed(1)}', () => textFontSize = v),
              activeColor: theme.colorScheme.primary,
            ),
            NChoiceColorListItem(
              title: const Text('textStyle.color'),
              value: textColor,
              onChanged: (v) => onMark('textStyle.color ${v ?? 'null'}', () => textColor = v),
            ),
          ],
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('animationDuration'),
            min: 0,
            max: 1000,
            value: animMs.clamp(0, 1000),
            onChanged: (v) => onMark('animationDuration ${v.round()}ms', () => animMs = v),
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
    SnackUtil.show(event);
    onMark(event);
  }
}
