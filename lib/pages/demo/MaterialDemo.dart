import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/basicWidget/n_style_card.dart';
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

  final scrollController = ScrollController();

  String lastEvent = '—';
  MaterialType type = MaterialType.canvas;
  double elevation = 10;
  Color? color = Colors.red;
  Color? shadowColor = Colors.blue;
  Color? surfaceTintColor;
  bool useTextStyle = false;
  double textFontSize = 14;
  Color? textColor;
  bool useBorderRadius = false;
  double borderRadius = 8;
  ShapeKind shapeKind = ShapeKind.none;
  double shapeRadius = 8;
  bool borderOnForeground = true;
  ClipKind clipKind = ClipKind.none;
  double animMs = 200;

  bool get isCircle => type == MaterialType.circle;

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
      textStyle: useTextStyle
          ? TextStyle(
              fontSize: textFontSize,
              color: textColor,
            )
          : null,
      borderRadius: buildBorderRadius(),
      shape: buildShape(),
      borderOnForeground: borderOnForeground,
      clipBehavior: clipOf(),
      animationDuration: Duration(milliseconds: animMs.round()),
      child: child,
    );
  }

  BorderRadius? buildBorderRadius() {
    if (isCircle || shapeKind != ShapeKind.none || !useBorderRadius) {
      return null;
    }
    return BorderRadius.circular(borderRadius);
  }

  ShapeBorder? buildShape() {
    if (isCircle) {
      return null;
    }
    switch (shapeKind) {
      case ShapeKind.none:
        return null;
      case ShapeKind.rounded:
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(shapeRadius));
      case ShapeKind.stadium:
        return const StadiumBorder();
    }
  }

  Clip clipOf() {
    return switch (clipKind) {
      ClipKind.hardEdge => Clip.hardEdge,
      ClipKind.antiAlias => Clip.antiAlias,
      ClipKind.antiAliasWithSaveLayer => Clip.antiAliasWithSaveLayer,
      ClipKind.nil || ClipKind.none => Clip.none,
    };
  }

  Widget buildSurfaceCard() {
    return NStyleCard(
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
            onChanged: onType,
          ),
          buildSlider(
            label: 'elevation',
            value: elevation,
            min: 0,
            max: 24,
            onChanged: (v) => onMark('elevation ${v.toStringAsFixed(1)}', () => elevation = v),
          ),
          buildColorRow('color', color, (v) => onMark('color ${v ?? 'null'}', () => color = v)),
          buildColorRow('shadowColor', shadowColor, (v) => onMark('shadowColor ${v ?? 'null'}', () => shadowColor = v)),
          buildColorRow('surfaceTintColor', surfaceTintColor, (v) => onMark('surfaceTintColor ${v ?? 'null'}', () => surfaceTintColor = v)),
        ],
      ),
    );
  }

  Widget buildShapeCard() {
    final clipValues = ClipKind.values.where((e) => e != ClipKind.nil).toList();
    return NStyleCard(
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
              onChanged: onShapeKind,
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          const Text('clipBehavior'),
          buildChoiceChips(
            values: clipValues,
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
            buildColorRow('color', textColor, (v) => onMark('textStyle.color ${v ?? 'null'}', () => textColor = v)),
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

  Widget buildColorRow(String label, Color? value, ValueChanged<Color?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        buildColorDots(value: value, onChanged: onChanged),
      ],
    );
  }

  Widget buildChoiceChips<T>({
    required List<T> values,
    required T value,
    required String Function(T) labelOf,
    required ValueChanged<T> onChanged,
  }) {
    final scheme = Theme.of(context).colorScheme;
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
    final scheme = Theme.of(context).colorScheme;
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
            child: e == null
                ? Text('默', style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600))
                : selected
                    ? Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: ThemeData.estimateBrightnessForColor(e) == Brightness.dark ? Colors.white : Colors.black87,
                      )
                    : null,
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
      value: value.clamp(min, max),
      onChanged: onChanged,
      activeColor: scheme.primary,
      inactiveColor: Colors.black12,
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
    lastEvent = event;
    DLog.d(event);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(event), duration: const Duration(milliseconds: 800)),
    );
    setState(() {});
  }

  void onType(MaterialType value) {
    type = value;
    if (value == MaterialType.circle) {
      shapeKind = ShapeKind.none;
      useBorderRadius = false;
    }
    lastEvent = 'type ${value.name}';
    setState(() {});
  }

  void onShapeKind(ShapeKind value) {
    shapeKind = value;
    if (value != ShapeKind.none) {
      useBorderRadius = false;
    }
    lastEvent = 'shape ${value == ShapeKind.none ? 'null' : value.name}';
    setState(() {});
  }
}
