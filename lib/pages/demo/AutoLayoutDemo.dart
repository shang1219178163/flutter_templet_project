import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_flexible_cell.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
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

  final scrollController = ScrollController();

  _PrefixKind prefixKind = _PrefixKind.widgetDefault;
  bool useSuffix = true;
  bool useDecoration = true;

  double padH = 16;
  double padV = 7;
  double minWidth = 100;
  double maxWidth = 300;
  double borderRadius = 16;
  double fontSize = 16;
  int itemCount = 3;
  int maxLines = 6;
  Color? backgroundColor = Colors.orange;

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
                        {
                          NLangEnum.en: 'The bottom row keeps the original Flexible + OutlinedButton example.',
                          NLangEnum.zh: '下方保留原 Demo 的 Flexible + OutlinedButton 横向自适应示例。',
                        },
                      ],
                    ),
                    buildConstructCard(),
                    buildSizeCard(),
                    if (useDecoration) buildSurfaceCard(),
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
                  'constraints: ${minWidth.round()} – ${maxWidth.round()}',
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
    switch (prefixKind) {
      case _PrefixKind.widgetDefault:
        return null;
      case _PrefixKind.hidden:
        return const SizedBox.shrink();
      case _PrefixKind.logo:
        return const Padding(
          padding: EdgeInsets.only(right: 6),
          child: FlutterLogo(size: 16),
        );
    }
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
              labelOf: (e) {
                switch (e) {
                  case _PrefixKind.widgetDefault:
                    return 'null / 默认图标';
                  case _PrefixKind.hidden:
                    return 'SizedBox.shrink';
                  case _PrefixKind.logo:
                    return 'FlutterLogo';
                }
              },
              onChanged: onPrefixKind,
            ),
          ),
          buildSwitch(title: 'suffix 后缀图标', value: useSuffix, onChanged: onUseSuffix),
          buildSwitch(title: 'decoration 自定义装饰', value: useDecoration, onChanged: onUseDecoration),
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
        children: [
          buildSlider(label: 'padding H', value: padH, min: 0, max: 32, onChanged: onPadH),
          buildSlider(label: 'padding V', value: padV, min: 0, max: 24, onChanged: onPadV),
          buildSlider(label: 'minWidth', value: minWidth, min: 0, max: 200, onChanged: onMinWidth),
          buildSlider(label: 'maxWidth', value: maxWidth, min: 80, max: 400, onChanged: onMaxWidth),
          buildSlider(label: 'fontSize', value: fontSize, min: 12, max: 22, onChanged: onFontSize),
          buildSlider(label: 'maxLines', value: maxLines.toDouble(), min: 1, max: 8, onChanged: onMaxLines),
          buildSlider(label: 'itemCount', value: itemCount.toDouble(), min: 1, max: 3, onChanged: onItemCount),
          if (useDecoration)
            buildSlider(label: 'borderRadius', value: borderRadius, min: 0, max: 28, onChanged: onBorderRadius),
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.palette_outlined),
      title: '表面',
      subtitle: 'decoration color',
      child: buildField(
        label: 'backgroundColor',
        child: buildColorDots(value: backgroundColor, onChanged: onBackgroundColor),
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_rounded),
      title: '行为',
      subtitle: 'Flexible 行 onTap',
      child: Text(
        '点击预览中的绿色标签或 OutlinedButton，查看 SnackBar。',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 13.5,
            ),
      ),
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

  void onPrefixKind(_PrefixKind value) {
    prefixKind = value;
    setState(() {});
  }

  void onUseSuffix(bool value) {
    useSuffix = value;
    setState(() {});
  }

  void onUseDecoration(bool value) {
    useDecoration = value;
    setState(() {});
  }

  void onPadH(double value) {
    padH = value;
    setState(() {});
  }

  void onPadV(double value) {
    padV = value;
    setState(() {});
  }

  void onMinWidth(double value) {
    minWidth = value;
    if (minWidth > maxWidth) {
      maxWidth = minWidth;
    }
    setState(() {});
  }

  void onMaxWidth(double value) {
    maxWidth = value;
    if (maxWidth < minWidth) {
      minWidth = maxWidth;
    }
    setState(() {});
  }

  void onFontSize(double value) {
    fontSize = value;
    setState(() {});
  }

  void onMaxLines(double value) {
    maxLines = value.round().clamp(1, 8);
    setState(() {});
  }

  void onItemCount(double value) {
    itemCount = value.round().clamp(1, 3);
    setState(() {});
  }

  void onBorderRadius(double value) {
    borderRadius = value;
    setState(() {});
  }

  void onBackgroundColor(Color? value) {
    backgroundColor = value;
    setState(() {});
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
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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
    setState(() {});
  }
}
