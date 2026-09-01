//
//  ListTilePage.dart
//  flutter_templet_project
//
//  Created by shang on 2026/8/31.
//  Copyright © 2026/8/31 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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

/// ListTile 家族构造
enum _TileKind {
  gallery(label: 'gallery'),
  listTile(label: 'ListTile'),
  switchTile(label: 'Switch'),
  switchAdaptive(label: 'Switch.adaptive'),
  checkbox(label: 'Checkbox'),
  checkboxAdaptive(label: 'Checkbox.adaptive'),
  radio(label: 'Radio'),
  radioAdaptive(label: 'Radio.adaptive'),
  slider(label: 'Slider'),
  cupertino(label: 'Cupertino');
  const _TileKind({required this.label});
  final String label;
}

class ListTilePage extends StatefulWidget {
  const ListTilePage({
    super.key,
    this.title,
    this.arguments,
  });

  final String? title;
  final Map<String, dynamic>? arguments;

  @override
  State<ListTilePage> createState() => _ListTilePageState();
}

class _ListTilePageState extends State<ListTilePage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

  final scrollController = ScrollController();
  final focusNode = FocusNode();

  /// 最近事件
  String lastEvent = '—';
  /// 构造方式
  _TileKind kind = _TileKind.gallery;
  /// 标题
  String titleText = '标题';
  /// 是否显示副标题
  bool useSubtitle = true;
  /// 副标题
  String subtitleText = '副标题';
  /// 三行
  bool isThreeLine = false;
  /// 紧凑
  bool? dense;
  /// 选中
  bool selected = false;
  /// 是否启用
  bool enabled = true;
  /// 是否传入 onChanged / onTap
  bool useOnChanged = true;
  /// 左侧图标
  bool useSecondary = true;
  /// ListTile trailing
  bool useTrailing = true;
  /// 自动聚焦
  bool autofocus = false;
  /// 是否传入 focusNode
  bool useFocusNode = false;
  /// 是否传入 contentPadding
  bool usePadding = false;
  /// 水平内边距
  double padH = 16;
  /// 垂直内边距
  double padV = 0;
  /// 形状
  ShapeKind shapeKind = ShapeKind.none;
  /// 圆角
  double shapeRadius = 12;
  /// 控件位置
  ListTileControlAffinity? controlAffinity;
  /// 标题对齐
  ListTileTitleAlignment? titleAlignment;
  /// 视觉密度
  VisualDensity? visualDensity;
  /// 点击目标
  MaterialTapTargetSize? materialTapTargetSize;
  /// 反馈
  bool? enableFeedback;
  /// ListTile 样式
  ListTileStyle? listTileStyle;
  /// 背景色
  Color? tileColor;
  /// 选中背景色
  Color? selectedTileColor;
  /// 激活色
  Color? activeColor;
  /// 悬停色
  Color? hoverColor;
  /// 开关值
  bool switchValue = true;
  /// 拖动手势
  DragStartBehavior dragStartBehavior = DragStartBehavior.start;
  /// adaptive 是否应用 Cupertino 主题
  bool? applyCupertinoTheme;
  /// 勾选值
  bool? checkboxValue = true;
  /// 三态
  bool tristate = false;
  /// 错误态
  bool isError = false;
  /// 勾选缩放
  double checkboxScaleFactor = 1;
  /// 勾选色
  Color? checkColor;
  /// 单选组
  String? radioGroup = 'A';
  /// 允许取消选中
  bool toggleable = false;
  /// Cupertino 单选勾
  bool useCupertinoCheckmarkStyle = false;
  /// 滑条值
  double sliderValue = 0.6;
  /// 滑条最小
  double sliderMin = 0;
  /// 滑条最大
  double sliderMax = 1;
  /// 是否显示数值
  bool showValue = true;
  /// 滑条宽度比例
  double sliderWidthFactor = 0.5;
  /// Cupertino 是否 notched
  bool cupertinoNotched = false;
  /// Cupertino additionalInfo
  bool useAdditionalInfo = true;

  @override
  void dispose() {
    scrollController.dispose();
    focusNode.dispose();
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
              title: Text(widget.title ?? '$widget'),
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
                        NLangEnum.en: 'SwitchListTile family',
                        NLangEnum.zh: 'SwitchListTile 家族',
                      },
                      items: [
                        {
                          NLangEnum.en:
                              'ListTile, SwitchListTile / .adaptive, CheckboxListTile / .adaptive, RadioListTile / .adaptive, NSliderListTile, CupertinoListTile.',
                          NLangEnum.zh:
                              '统一展示 ListTile、SwitchListTile / .adaptive、CheckboxListTile / .adaptive、RadioListTile / .adaptive、NSliderListTile、CupertinoListTile。',
                        },
                      ],
                    ),
                    buildTileCard(),
                    if (kind != _TileKind.listTile) buildControlCard(),
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
    final previewHeight = switch (kind) {
      _TileKind.gallery => 360.0,
      _TileKind.radio || _TileKind.radioAdaptive => 168.0,
      _TileKind.cupertino => 148.0,
      _ => isThreeLine ? 108.0 : 88.0,
    };
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
              height: previewHeight,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.65)),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.shadow.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: kind == _TileKind.gallery
                      ? SingleChildScrollView(child: buildGallery())
                      : Align(
                          alignment: Alignment.center,
                          child: buildPlayground(),
                        ),
                ),
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

  Widget buildGallery() {
    final tiles = [
      buildListTile(),
      buildSwitchTile(adaptive: false),
      buildSwitchTile(adaptive: true),
      buildCheckboxTile(adaptive: false),
      buildCheckboxTile(adaptive: true),
      ...buildRadioTiles(adaptive: false),
      buildSliderTile(),
      buildCupertinoTile(),
    ];
    return Column(
      children: [
        for (var i = 0; i < tiles.length; i++) ...[
          tiles[i],
          if (i != tiles.length - 1) const Divider(height: 1),
        ],
      ],
    );
  }

  Widget buildPlayground() {
    return switch (kind) {
      _TileKind.gallery => buildGallery(),
      _TileKind.listTile => buildListTile(),
      _TileKind.switchTile => buildSwitchTile(adaptive: false),
      _TileKind.switchAdaptive => buildSwitchTile(adaptive: true),
      _TileKind.checkbox => buildCheckboxTile(adaptive: false),
      _TileKind.checkboxAdaptive => buildCheckboxTile(adaptive: true),
      _TileKind.radio => Column(mainAxisSize: MainAxisSize.min, children: buildRadioTiles(adaptive: false)),
      _TileKind.radioAdaptive => Column(mainAxisSize: MainAxisSize.min, children: buildRadioTiles(adaptive: true)),
      _TileKind.slider => buildSliderTile(),
      _TileKind.cupertino => buildCupertinoTile(),
    };
  }

  Widget buildListTile() {
    final subtitle = (!useSubtitle && !isThreeLine)
        ? null
        : Text(isThreeLine ? '$subtitleText\n第三行' : subtitleText);
    return ListTile(
      leading: useSecondary ? const Icon(Icons.notifications_outlined) : null,
      title: Text(titleText),
      subtitle: subtitle,
      trailing: useTrailing ? const Icon(Icons.chevron_right) : null,
      isThreeLine: isThreeLine,
      dense: dense,
      visualDensity: visualDensity,
      shape: shapeKind.shape(roundedRadius: shapeRadius),
      style: listTileStyle,
      contentPadding: usePadding ? EdgeInsets.symmetric(horizontal: padH, vertical: padV) : null,
      enabled: enabled,
      onTap: useOnChanged && enabled ? () => onTap('ListTile') : null,
      onLongPress: useOnChanged && enabled ? () => onMark('onLongPress') : null,
      selected: selected,
      hoverColor: hoverColor,
      focusNode: useFocusNode ? focusNode : null,
      autofocus: autofocus,
      tileColor: tileColor,
      selectedTileColor: selectedTileColor,
      enableFeedback: enableFeedback,
      titleAlignment: titleAlignment,
    );
  }

  Widget buildSwitchTile({required bool adaptive}) {
    final title = Text(kind == _TileKind.gallery
        ? (adaptive ? 'SwitchListTile.adaptive' : 'SwitchListTile')
        : titleText);
    final subtitle = (!useSubtitle && !isThreeLine)
        ? null
        : Text(isThreeLine ? '$subtitleText\n第三行' : subtitleText);
    final onChanged = enabled && useOnChanged ? (v) => onMark('Switch $v', () => switchValue = v) : null;
    if (adaptive) {
      return SwitchListTile.adaptive(
        value: switchValue,
        onChanged: onChanged,
        activeColor: activeColor,
        dragStartBehavior: dragStartBehavior,
        materialTapTargetSize: materialTapTargetSize,
        focusNode: useFocusNode ? focusNode : null,
        autofocus: autofocus,
        applyCupertinoTheme: applyCupertinoTheme,
        tileColor: tileColor,
        title: title,
        subtitle: subtitle,
        isThreeLine: isThreeLine,
        dense: dense,
        contentPadding: usePadding ? EdgeInsets.symmetric(horizontal: padH, vertical: padV) : null,
        secondary: useSecondary ? const Icon(Icons.notifications_outlined) : null,
        selected: selected,
        controlAffinity: controlAffinity,
        shape: shapeKind.shape(roundedRadius: shapeRadius),
        selectedTileColor: selectedTileColor,
        visualDensity: visualDensity,
        enableFeedback: enableFeedback,
        hoverColor: hoverColor,
      );
    }
    return SwitchListTile(
      value: switchValue,
      onChanged: onChanged,
      activeColor: activeColor,
      dragStartBehavior: dragStartBehavior,
      materialTapTargetSize: materialTapTargetSize,
      focusNode: useFocusNode ? focusNode : null,
      autofocus: autofocus,
      tileColor: tileColor,
      title: title,
      subtitle: subtitle,
      isThreeLine: isThreeLine,
      dense: dense,
      contentPadding: usePadding ? EdgeInsets.symmetric(horizontal: padH, vertical: padV) : null,
      secondary: useSecondary ? const Icon(Icons.notifications_outlined) : null,
      selected: selected,
      controlAffinity: controlAffinity,
      shape: shapeKind.shape(roundedRadius: shapeRadius),
      selectedTileColor: selectedTileColor,
      visualDensity: visualDensity,
      enableFeedback: enableFeedback,
      hoverColor: hoverColor,
    );
  }

  Widget buildCheckboxTile({required bool adaptive}) {
    final title = Text(kind == _TileKind.gallery
        ? (adaptive ? 'CheckboxListTile.adaptive' : 'CheckboxListTile')
        : titleText);
    final subtitle = (!useSubtitle && !isThreeLine)
        ? null
        : Text(isThreeLine ? '$subtitleText\n第三行' : subtitleText);
    final onChanged = enabled && useOnChanged ? (v) => onMark('Checkbox $v', () => checkboxValue = v) : null;
    if (adaptive) {
      return CheckboxListTile.adaptive(
        value: checkboxValue,
        onChanged: onChanged,
        activeColor: activeColor,
        checkColor: checkColor,
        hoverColor: hoverColor,
        materialTapTargetSize: materialTapTargetSize,
        visualDensity: visualDensity,
        focusNode: useFocusNode ? focusNode : null,
        autofocus: autofocus,
        shape: shapeKind.shape(roundedRadius: shapeRadius),
        isError: isError,
        enabled: enabled,
        tileColor: tileColor,
        title: title,
        subtitle: subtitle,
        isThreeLine: isThreeLine,
        dense: dense,
        secondary: useSecondary ? const Icon(Icons.notifications_outlined) : null,
        selected: selected,
        controlAffinity: controlAffinity,
        contentPadding: usePadding ? EdgeInsets.symmetric(horizontal: padH, vertical: padV) : null,
        tristate: tristate,
        selectedTileColor: selectedTileColor,
        enableFeedback: enableFeedback,
        checkboxScaleFactor: checkboxScaleFactor,
      );
    }
    return CheckboxListTile(
      value: checkboxValue,
      onChanged: onChanged,
      activeColor: activeColor,
      checkColor: checkColor,
      hoverColor: hoverColor,
      materialTapTargetSize: materialTapTargetSize,
      visualDensity: visualDensity,
      focusNode: useFocusNode ? focusNode : null,
      autofocus: autofocus,
      shape: shapeKind.shape(roundedRadius: shapeRadius),
      isError: isError,
      enabled: enabled,
      tileColor: tileColor,
      title: title,
      subtitle: subtitle,
      isThreeLine: isThreeLine,
      dense: dense,
      secondary: useSecondary ? const Icon(Icons.notifications_outlined) : null,
      selected: selected,
      controlAffinity: controlAffinity,
      contentPadding: usePadding ? EdgeInsets.symmetric(horizontal: padH, vertical: padV) : null,
      tristate: tristate,
      selectedTileColor: selectedTileColor,
      enableFeedback: enableFeedback,
      checkboxScaleFactor: checkboxScaleFactor,
    );
  }

  List<Widget> buildRadioTiles({required bool adaptive}) {
    const options = ['A', 'B'];
    final subtitle = (!useSubtitle && !isThreeLine)
        ? null
        : Text(isThreeLine ? '$subtitleText\n第三行' : subtitleText);
    final onChanged = enabled && useOnChanged ? (v) => onMark('Radio $v', () => radioGroup = v) : null;
    return options.map((e) {
      final title = kind == _TileKind.gallery || kind == _TileKind.radio || kind == _TileKind.radioAdaptive
          ? 'RadioListTile $e'
          : titleText;
      if (adaptive) {
        return RadioListTile<String>.adaptive(
          value: e,
          groupValue: radioGroup,
          onChanged: onChanged,
          toggleable: toggleable,
          activeColor: activeColor,
          hoverColor: hoverColor,
          materialTapTargetSize: materialTapTargetSize,
          title: Text(title),
          subtitle: subtitle,
          isThreeLine: isThreeLine,
          dense: dense,
          secondary: useSecondary ? const Icon(Icons.notifications_outlined) : null,
          selected: selected && radioGroup == e,
          controlAffinity: controlAffinity,
          autofocus: autofocus && e == 'A',
          contentPadding: usePadding ? EdgeInsets.symmetric(horizontal: padH, vertical: padV) : null,
          shape: shapeKind.shape(roundedRadius: shapeRadius),
          tileColor: tileColor,
          selectedTileColor: selectedTileColor,
          visualDensity: visualDensity,
          focusNode: useFocusNode && e == 'A' ? focusNode : null,
          enableFeedback: enableFeedback,
          useCupertinoCheckmarkStyle: useCupertinoCheckmarkStyle,
        );
      }
      return RadioListTile<String>(
        value: e,
        groupValue: radioGroup,
        onChanged: onChanged,
        toggleable: toggleable,
        activeColor: activeColor,
        hoverColor: hoverColor,
        materialTapTargetSize: materialTapTargetSize,
        title: Text(title),
        subtitle: subtitle,
        isThreeLine: isThreeLine,
        dense: dense,
        secondary: useSecondary ? const Icon(Icons.notifications_outlined) : null,
        selected: selected && radioGroup == e,
        controlAffinity: controlAffinity,
        autofocus: autofocus && e == 'A',
        contentPadding: usePadding ? EdgeInsets.symmetric(horizontal: padH, vertical: padV) : null,
        shape: shapeKind.shape(roundedRadius: shapeRadius),
        tileColor: tileColor,
        selectedTileColor: selectedTileColor,
        visualDensity: visualDensity,
        focusNode: useFocusNode && e == 'A' ? focusNode : null,
        enableFeedback: enableFeedback,
      );
    }).toList();
  }

  Widget buildSliderTile() {
    final lo = sliderMin <= sliderMax ? sliderMin : sliderMax;
    final hi = sliderMax >= sliderMin ? sliderMax : sliderMin;
    final subtitle = (!useSubtitle && !isThreeLine)
        ? null
        : Text(isThreeLine ? '$subtitleText\n第三行' : subtitleText);
    return NSliderListTile(
      value: sliderValue.clamp(lo, hi),
      onChanged: enabled && useOnChanged ? (v) => onMark('Slider ${v.toStringAsFixed(2)}', () => sliderValue = v) : null,
      min: lo,
      max: hi,
      activeColor: activeColor,
      tileColor: tileColor,
      title: Text(kind == _TileKind.gallery ? 'NSliderListTile' : titleText),
      subtitle: subtitle,
      secondary: useSecondary ? const Icon(Icons.notifications_outlined) : null,
      showValue: showValue,
      sliderWidthFactor: sliderWidthFactor,
      isThreeLine: isThreeLine,
      dense: dense,
      contentPadding: usePadding ? EdgeInsets.symmetric(horizontal: padH, vertical: padV) : null,
      selected: selected,
      shape: shapeKind.shape(roundedRadius: shapeRadius),
      selectedTileColor: selectedTileColor,
      visualDensity: visualDensity,
      enableFeedback: enableFeedback,
      hoverColor: hoverColor,
      titleAlignment: titleAlignment,
    );
  }

  Widget buildCupertinoTile() {
    final title = Text(kind == _TileKind.gallery ? 'CupertinoListTile' : titleText);
    final subtitle = (!useSubtitle && !isThreeLine)
        ? null
        : Text(isThreeLine ? '$subtitleText\n第三行' : subtitleText);
    final leading = useSecondary ? const Icon(CupertinoIcons.bell) : null;
    final trailing = useTrailing ? const CupertinoListTileChevron() : null;
    final info = useAdditionalInfo ? const Text('Info') : null;
    final padding = usePadding ? EdgeInsets.symmetric(horizontal: padH, vertical: padV) : null;
    final tile = cupertinoNotched
        ? CupertinoListTile.notched(
            title: title,
            subtitle: subtitle,
            additionalInfo: info,
            leading: leading,
            trailing: trailing,
            onTap: useOnChanged && enabled ? () => onTap('CupertinoListTile') : null,
            backgroundColor: tileColor,
            padding: padding,
          )
        : CupertinoListTile(
            title: title,
            subtitle: subtitle,
            additionalInfo: info,
            leading: leading,
            trailing: trailing,
            onTap: useOnChanged && enabled ? () => onTap('CupertinoListTile') : null,
            backgroundColor: tileColor,
            padding: padding,
          );
    return CupertinoTheme(
      data: CupertinoThemeData(brightness: theme.brightness),
      child: tile,
    );
  }

  Widget buildTileCard() {
    final showListStyle = kind == _TileKind.listTile || kind == _TileKind.gallery;
    return NDecorationCard(
      icon: const Icon(Icons.tune_outlined),
      title: '属性',
      subtitle: 'kind · title · dense · selected · shape',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceChipListItem(
            title: const Text('构造'),
            values: _TileKind.values,
            value: kind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('kind ${e.label}', () => kind = e),
          ),
          NChoiceChipListItem(
            title: const Text('title'),
            values: const ['标题', '消息通知', '同步'],
            value: titleText,
            labelOf: (e) => e,
            onChanged: (e) => onMark('title $e', () => titleText = e),
          ),
          NSwitchListTile(
            title: const Text('subtitle'),
            value: useSubtitle,
            onChanged: (v) => onMark('subtitle ${v ? 'on' : 'null'}', () => useSubtitle = v),
          ),
          if (useSubtitle || isThreeLine) ...[
            NChoiceChipListItem(
              title: const Text('subtitle 文案'),
              values: const ['副标题', '补充说明', '第二行文字较长时的效果'],
              value: subtitleText,
              labelOf: (e) => e,
              onChanged: (e) => onMark('subtitleText $e', () => subtitleText = e),
            ),
          ],
          NSwitchListTile(
            title: const Text('isThreeLine'),
            value: isThreeLine,
            onChanged: (v) => onMark('isThreeLine $v', () {
              isThreeLine = v;
              if (v) {
                useSubtitle = true;
              }
            }),
          ),
          NChoiceChipListItem(
            title: const Text('dense'),
            values: const [null, true, false],
            value: dense,
            labelOf: (e) => e == null ? '默' : '$e',
            onChanged: (e) => onMark('dense ${e ?? 'null'}', () => dense = e),
          ),
          NSwitchListTile(
            title: const Text('selected'),
            value: selected,
            onChanged: (v) => onMark('selected $v', () => selected = v),
          ),
          NSwitchListTile(
            title: const Text('enabled'),
            value: enabled,
            onChanged: (v) => onMark('enabled $v', () => enabled = v),
          ),
          NSwitchListTile(
            title: const Text('onChanged / onTap'),
            value: useOnChanged,
            onChanged: (v) => onMark('onChanged ${v ? 'on' : 'null'}', () => useOnChanged = v),
          ),
          NSwitchListTile(
            title: const Text('secondary / leading'),
            value: useSecondary,
            onChanged: (v) => onMark('secondary ${v ? 'on' : 'null'}', () => useSecondary = v),
          ),
          if (kind == _TileKind.listTile || kind == _TileKind.cupertino || kind == _TileKind.gallery)
            NSwitchListTile(
              title: const Text('trailing'),
              value: useTrailing,
              onChanged: (v) => onMark('trailing ${v ? 'on' : 'null'}', () => useTrailing = v),
            ),
          NSwitchListTile(
            title: const Text('contentPadding'),
            value: usePadding,
            onChanged: (v) => onMark('contentPadding ${v ? 'on' : 'null'}', () => usePadding = v),
          ),
          if (usePadding) ...[
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('paddingH'),
              min: 0,
              max: 32,
              value: padH.clamp(0, 32),
              onChanged: (v) => onMark('paddingH ${v.round()}', () => padH = v),
              activeColor: theme.colorScheme.primary,
            ),
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('paddingV'),
              min: 0,
              max: 16,
              value: padV.clamp(0, 16),
              onChanged: (v) => onMark('paddingV ${v.round()}', () => padV = v),
              activeColor: theme.colorScheme.primary,
            ),
          ],
          NChoiceChipListItem(
            title: const Text('shape'),
            values: ShapeKind.values,
            value: shapeKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('shape ${e.label}', () {
              shapeKind = e;
              if (e == ShapeKind.rounded) {
                shapeRadius = e.radius;
              }
            }),
          ),
          if (shapeKind == ShapeKind.rounded)
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('shapeRadius'),
              min: 0,
              max: 28,
              value: shapeRadius.clamp(0, 28),
              onChanged: (v) => onMark('shapeRadius ${v.round()}', () => shapeRadius = v),
              activeColor: theme.colorScheme.primary,
            ),
          if (kind != _TileKind.cupertino) ...[
            if (kind != _TileKind.listTile && kind != _TileKind.slider) ...[
              NChoiceChipListItem(
                title: const Text('controlAffinity'),
                values: [null, ...ListTileControlAffinity.values],
                value: controlAffinity,
                labelOf: (e) => e?.name ?? '默',
                onChanged: (e) => onMark('controlAffinity ${e?.name ?? 'null'}', () => controlAffinity = e),
              ),
            ],
            if (kind == _TileKind.listTile || kind == _TileKind.slider || kind == _TileKind.gallery) ...[
              NChoiceChipListItem(
                title: const Text('titleAlignment'),
                values: [null, ...ListTileTitleAlignment.values],
                value: titleAlignment,
                labelOf: (e) => e?.name ?? '默',
                onChanged: (e) => onMark('titleAlignment ${e?.name ?? 'null'}', () => titleAlignment = e),
              ),
            ],
            NChoiceChipListItem(
              title: const Text('visualDensity'),
              values: const [null, VisualDensity.standard, VisualDensity.comfortable, VisualDensity.compact],
              value: visualDensity,
              labelOf: (e) => switch (e) {
                null => '默',
                VisualDensity.standard => 'standard',
                VisualDensity.comfortable => 'comfortable',
                VisualDensity.compact => 'compact',
                _ => '$e',
              },
              onChanged: (e) => onMark(
                'visualDensity ${switch (e) {
                  null => '默',
                  VisualDensity.standard => 'standard',
                  VisualDensity.comfortable => 'comfortable',
                  VisualDensity.compact => 'compact',
                  _ => '$e',
                }}',
                () => visualDensity = e,
              ),
            ),
            NChoiceChipListItem(
              title: const Text('enableFeedback'),
              values: const [null, true, false],
              value: enableFeedback,
              labelOf: (e) => e == null ? '默' : '$e',
              onChanged: (e) => onMark('enableFeedback ${e ?? 'null'}', () => enableFeedback = e),
            ),
          ],
          if (showListStyle) ...[
            NChoiceChipListItem(
              title: const Text('style'),
              values: [null, ...ListTileStyle.values],
              value: listTileStyle,
              labelOf: (e) => e?.name ?? '默',
              onChanged: (e) => onMark('style ${e?.name ?? 'null'}', () => listTileStyle = e),
            ),
          ],
          NSwitchListTile(
            title: const Text('autofocus'),
            value: autofocus,
            onChanged: (v) => onMark('autofocus $v', () => autofocus = v),
          ),
          NSwitchListTile(
            title: const Text('focusNode'),
            value: useFocusNode,
            onChanged: (v) => onMark('focusNode ${v ? 'on' : 'null'}', () => useFocusNode = v),
          ),
          NChoiceColorListItem(
            title: const Text('tileColor'),
            value: tileColor,
            onChanged: (e) => onMark('tileColor', () => tileColor = e),
          ),
          NChoiceColorListItem(
            title: const Text('selectedTileColor'),
            value: selectedTileColor,
            onChanged: (e) => onMark('selectedTileColor', () => selectedTileColor = e),
          ),
          if (kind != _TileKind.listTile && kind != _TileKind.cupertino)
            NChoiceColorListItem(
              title: const Text('activeColor'),
              value: activeColor,
              onChanged: (e) => onMark('activeColor', () => activeColor = e),
            ),
          if (kind != _TileKind.cupertino)
            NChoiceColorListItem(
              title: const Text('hoverColor'),
              value: hoverColor,
              onChanged: (e) => onMark('hoverColor', () => hoverColor = e),
            ),
        ],
      ),
    );
  }

  Widget buildControlCard() {
    final showSwitch = kind == _TileKind.switchTile || kind == _TileKind.switchAdaptive || kind == _TileKind.gallery;
    final showCheckbox = kind == _TileKind.checkbox || kind == _TileKind.checkboxAdaptive || kind == _TileKind.gallery;
    final showRadio = kind == _TileKind.radio || kind == _TileKind.radioAdaptive || kind == _TileKind.gallery;
    final showSlider = kind == _TileKind.slider || kind == _TileKind.gallery;
    return NDecorationCard(
      icon: const Icon(Icons.toggle_on_outlined),
      title: '控件',
      subtitle: 'Switch  Checkbox  Radio  Slider  Cupertino',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showSwitch) ...[
            NSwitchListTile(
              title: const Text('Switch.value'),
              value: switchValue,
              onChanged: (v) => onMark('switch $v', () => switchValue = v),
            ),
            NChoiceChipListItem(
              title: const Text('dragStartBehavior'),
              values: DragStartBehavior.values,
              value: dragStartBehavior,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('dragStartBehavior ${e.name}', () => dragStartBehavior = e),
            ),
            if (kind == _TileKind.switchAdaptive || kind == _TileKind.gallery) ...[
              NChoiceChipListItem(
                title: const Text('applyCupertinoTheme'),
                values: const [null, true, false],
                value: applyCupertinoTheme,
                labelOf: (e) => e == null ? '默' : '$e',
                onChanged: (e) => onMark('applyCupertinoTheme ${e ?? 'null'}', () => applyCupertinoTheme = e),
              ),
            ],
            NChoiceChipListItem(
              title: const Text('materialTapTargetSize'),
              values: const [null, MaterialTapTargetSize.padded, MaterialTapTargetSize.shrinkWrap],
              value: materialTapTargetSize,
              labelOf: (e) => e?.name ?? '默',
              onChanged: (e) => onMark('materialTapTargetSize ${e?.name ?? 'null'}', () => materialTapTargetSize = e),
            ),
          ],
          if (showCheckbox) ...[
            NChoiceChipListItem(
              title: const Text('Checkbox.value'),
              values: tristate ? const [null, true, false] : const [true, false],
              value: checkboxValue,
              labelOf: (e) => e == null ? 'null' : '$e',
              onChanged: (e) => onMark('checkbox $e', () => checkboxValue = e),
            ),
            NSwitchListTile(
              title: const Text('tristate'),
              value: tristate,
              onChanged: (v) => onMark('tristate $v', () {
                tristate = v;
                if (!v && checkboxValue == null) {
                  checkboxValue = false;
                }
              }),
            ),
            NSwitchListTile(
              title: const Text('isError'),
              value: isError,
              onChanged: (v) => onMark('isError $v', () => isError = v),
            ),
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('checkboxScaleFactor'),
              min: 0.6,
              max: 1.6,
              value: checkboxScaleFactor.clamp(0.6, 1.6),
              onChanged: (v) => onMark('checkboxScaleFactor ${v.toStringAsFixed(2)}', () => checkboxScaleFactor = v),
              activeColor: theme.colorScheme.primary,
            ),
            NChoiceColorListItem(
              title: const Text('checkColor'),
              value: checkColor,
              onChanged: (e) => onMark('checkColor', () => checkColor = e),
            ),
          ],
          if (showRadio) ...[
            NChoiceChipListItem(
              title: const Text('groupValue'),
              values: const [null, 'A', 'B'],
              value: radioGroup,
              labelOf: (e) => e ?? 'null',
              onChanged: (e) => onMark('radio $e', () => radioGroup = e),
            ),
            NSwitchListTile(
              title: const Text('toggleable'),
              value: toggleable,
              onChanged: (v) => onMark('toggleable $v', () => toggleable = v),
            ),
            if (kind == _TileKind.radioAdaptive || kind == _TileKind.gallery)
              NSwitchListTile(
                title: const Text('useCupertinoCheckmarkStyle'),
                value: useCupertinoCheckmarkStyle,
                onChanged: (v) => onMark('useCupertinoCheckmarkStyle $v', () => useCupertinoCheckmarkStyle = v),
              ),
          ],
          if (showSlider) ...[
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('value'),
              min: sliderMin,
              max: sliderMax,
              value: sliderValue.clamp(sliderMin, sliderMax),
              onChanged: (v) => onMark('slider ${v.toStringAsFixed(2)}', () => sliderValue = v),
              activeColor: theme.colorScheme.primary,
            ),
            NSwitchListTile(
              title: const Text('showValue'),
              value: showValue,
              onChanged: (v) => onMark('showValue $v', () => showValue = v),
            ),
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('sliderWidthFactor'),
              min: 0.2,
              max: 1,
              value: sliderWidthFactor.clamp(0.2, 1),
              onChanged: (v) => onMark('sliderWidthFactor ${v.toStringAsFixed(2)}', () => sliderWidthFactor = v),
              activeColor: theme.colorScheme.primary,
            ),
          ],
          if (kind == _TileKind.cupertino || kind == _TileKind.gallery) ...[
            NSwitchListTile(
              title: const Text('notched'),
              value: cupertinoNotched,
              onChanged: (v) => onMark('notched $v', () => cupertinoNotched = v),
            ),
            NSwitchListTile(
              title: const Text('additionalInfo'),
              value: useAdditionalInfo,
              onChanged: (v) => onMark('additionalInfo ${v ? 'on' : 'null'}', () => useAdditionalInfo = v),
            ),
          ],
        ],
      ),
    );
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onTap(String name) {
    onMark('onTap $name');
    SnackUtil.show('onTap $name');
  }

  void onReset() {
    lastEvent = '—';
    kind = _TileKind.gallery;
    titleText = '标题';
    useSubtitle = true;
    subtitleText = '副标题';
    isThreeLine = false;
    dense = null;
    selected = false;
    enabled = true;
    useOnChanged = true;
    useSecondary = true;
    useTrailing = true;
    autofocus = false;
    useFocusNode = false;
    usePadding = false;
    padH = 16;
    padV = 0;
    shapeKind = ShapeKind.none;
    shapeRadius = 12;
    controlAffinity = null;
    titleAlignment = null;
    visualDensity = null;
    materialTapTargetSize = null;
    enableFeedback = null;
    listTileStyle = null;
    tileColor = null;
    selectedTileColor = null;
    activeColor = null;
    hoverColor = null;
    switchValue = true;
    dragStartBehavior = DragStartBehavior.start;
    applyCupertinoTheme = null;
    checkboxValue = true;
    tristate = false;
    isError = false;
    checkboxScaleFactor = 1;
    checkColor = null;
    radioGroup = 'A';
    toggleable = false;
    useCupertinoCheckmarkStyle = false;
    sliderValue = 0.6;
    sliderMin = 0;
    sliderMax = 1;
    showValue = true;
    sliderWidthFactor = 0.5;
    cupertinoNotched = false;
    useAdditionalInfo = true;
    setState(() {});
  }
}
