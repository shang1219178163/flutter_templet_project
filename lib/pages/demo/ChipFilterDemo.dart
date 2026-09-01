//
//  ChipFilterDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/7/21 6:13 PM.
//  Copyright © 12/7/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

/// FilterChip 构造方式
enum _ChipKind { flat, elevated }

class _ActorFilterEntry {
  const _ActorFilterEntry(this.name, this.initials);
  final String name;
  final String initials;
}

class ChipFilterDemo extends StatefulWidget {
  const ChipFilterDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<ChipFilterDemo> createState() => _ChipFilterDemoState();
}

class _ChipFilterDemoState extends State<ChipFilterDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

  final scrollController = ScrollController();

  static const _entrys = [
    _ActorFilterEntry('Aaron Burr', 'AB'),
    _ActorFilterEntry('Alexander Hamilton', 'AH'),
    _ActorFilterEntry('Eliza Hamilton', 'EH'),
    _ActorFilterEntry('James Madison', 'JM'),
  ];

  /// 已选中的演员
  final _filters = <_ActorFilterEntry>[];

  /// 构造方式
  _ChipKind kind = _ChipKind.flat;
  /// 是否显示头像
  bool useAvatar = true;
  /// 是否显示删除按钮
  bool useDelete = false;
  /// 是否可用
  bool enabled = true;
  /// 是否自动聚焦
  bool autofocus = false;
  /// 是否显示 tooltip
  bool useTooltip = false;
  /// 是否传入 padding
  bool usePadding = false;
  /// 是否传入 labelPadding
  bool useLabelPadding = false;
  /// 是否传入 elevation
  bool useElevation = false;
  /// 是否传入 pressElevation
  bool usePressElevation = false;
  /// 是否传入边框
  bool useSide = false;
  /// 是否传入 labelStyle
  bool useLabelStyle = false;
  /// 是否传入 iconTheme
  bool useIconTheme = false;
  /// 是否传入 avatarBoxConstraints
  bool useAvatarConstraints = false;
  /// 是否传入 deleteIconBoxConstraints
  bool useDeleteConstraints = false;
  /// 是否传入 animationStyle
  bool useAnimationStyle = false;
  /// 是否显示勾选标记
  bool? showCheckmark;
  /// 裁剪
  Clip clipBehavior = Clip.none;
  /// 外形
  ShapeKind shapeKind = ShapeKind.none;
  /// 外形圆角
  double shapeRadius = 8;
  /// 内边距
  double padding = 8;
  /// 标签内边距
  double labelPadding = 8;
  /// 海拔阴影
  double elevation = 0;
  /// 按下海拔
  double pressElevation = 8;
  /// 边框宽度
  double sideWidth = 1;
  /// 标签字号
  double labelFontSize = 14;
  /// 图标尺寸
  double iconThemeSize = 18;
  /// 头像约束
  double avatarConstraint = 32;
  /// 删除图标约束
  double deleteConstraint = 18;
  /// 动画时长（毫秒）
  double animMs = 195;
  /// 背景色
  Color? backgroundColor;
  /// 选中色
  Color? selectedColor;
  /// 禁用色
  Color? disabledColor;
  /// Chip 主题色
  Color? chipColor;
  /// 阴影色
  Color? shadowColor;
  /// 表面色调
  Color? surfaceTintColor;
  /// 选中阴影色
  Color? selectedShadowColor;
  /// 勾选标记色
  Color? checkmarkColor;
  /// 删除图标色
  Color? deleteIconColor;
  /// 边框色
  Color? sideColor;
  /// 标签文字色
  Color? labelColor;
  /// 图标色
  Color? iconThemeColor;
  /// 视觉密度
  VisualDensity? visualDensity;
  /// 点击目标尺寸
  MaterialTapTargetSize? materialTapTargetSize;
  /// 头像边框形状
  ShapeKind avatarBorderKind = ShapeKind.none;
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final previewHeight = (constraints.maxHeight * 0.38).clamp(220.0, 320.0);
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
                          NLangEnum.en: 'Widget FilterChip',
                          NLangEnum.zh: '组件 FilterChip',
                        },
                        items: [
                          {
                            NLangEnum.en: 'Pin a live preview while you tune every FilterChip constructor argument.',
                            NLangEnum.zh: '上方固定预览，下方调节 FilterChip 全部构造参数并即时生效。',
                          },
                          {
                            NLangEnum.en:
                                'onSelected toggles filters. Switch to FilterChip.elevated for the raised variant.',
                            NLangEnum.zh: 'onSelected 切换筛选。可切换 FilterChip.elevated 凸起样式。',
                          },
                        ],
                      ),
                      buildContentCard(),
                      buildSurfaceCard(),
                      buildSizeCard(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildPreview(double previewHeight) {
    final scheme = theme.colorScheme;
    final lookFor = _filters.map((e) => e.name).join(', ');
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
            child: ColoredBox(
              color: Colors.lightGreen,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: _entrys.map(buildFilterChip).toList(),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text(
              [
                lastEvent,
                'Look for: ${lookFor.isEmpty ? '—' : lookFor}',
              ].join('  ·  '),
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

  Widget buildFilterChip(_ActorFilterEntry actor) {
    final selected = _filters.any((e) => e.name == actor.name);
    final key = ValueKey('chip-$kind-${actor.name}');
    if (kind == _ChipKind.elevated) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: FilterChip.elevated(
          key: key,
          avatar: buildAvatar(actor),
          label: Text(actor.name),
          labelStyle: buildLabelStyle(),
          labelPadding: useLabelPadding ? EdgeInsets.all(labelPadding) : null,
          selected: selected,
          onSelected: enabled ? (v) => onChipSelected(actor, v) : null,
          deleteIcon: useDelete ? const Icon(Icons.cancel) : null,
          onDeleted: useDelete ? () => onChipDeleted(actor) : null,
          deleteIconColor: deleteIconColor,
          deleteButtonTooltipMessage: useDelete ? '删除 ${actor.name}' : null,
          pressElevation: usePressElevation ? pressElevation : null,
          disabledColor: disabledColor,
          selectedColor: selectedColor,
          tooltip: useTooltip ? actor.name : null,
          side: buildSide(),
          shape: buildShape(),
          clipBehavior: clipBehavior,
          autofocus: autofocus,
          color: chipColor == null ? null : WidgetStateProperty.all(chipColor),
          backgroundColor: backgroundColor,
          padding: usePadding ? EdgeInsets.all(padding) : null,
          visualDensity: visualDensity,
          materialTapTargetSize: materialTapTargetSize,
          elevation: useElevation ? elevation : null,
          shadowColor: shadowColor,
          surfaceTintColor: surfaceTintColor,
          iconTheme: buildIconTheme(),
          selectedShadowColor: selectedShadowColor,
          showCheckmark: showCheckmark,
          checkmarkColor: checkmarkColor,
          avatarBorder: buildAvatarBorder(),
          avatarBoxConstraints:
              useAvatarConstraints ? BoxConstraints.tightFor(width: avatarConstraint, height: avatarConstraint) : null,
          deleteIconBoxConstraints:
              useDeleteConstraints ? BoxConstraints.tightFor(width: deleteConstraint, height: deleteConstraint) : null,
          chipAnimationStyle: buildAnimationStyle(),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FilterChip(
        key: key,
        avatar: buildAvatar(actor),
        label: Text(actor.name),
        labelStyle: buildLabelStyle(),
        labelPadding: useLabelPadding ? EdgeInsets.all(labelPadding) : null,
        selected: selected,
        onSelected: enabled ? (v) => onChipSelected(actor, v) : null,
        deleteIcon: useDelete ? const Icon(Icons.cancel) : null,
        onDeleted: useDelete ? () => onChipDeleted(actor) : null,
        deleteIconColor: deleteIconColor,
        deleteButtonTooltipMessage: useDelete ? '删除 ${actor.name}' : null,
        pressElevation: usePressElevation ? pressElevation : null,
        disabledColor: disabledColor,
        selectedColor: selectedColor,
        tooltip: useTooltip ? actor.name : null,
        side: buildSide(),
        shape: buildShape(),
        clipBehavior: clipBehavior,
        autofocus: autofocus,
        color: chipColor == null ? null : WidgetStateProperty.all(chipColor),
        backgroundColor: backgroundColor,
        padding: usePadding ? EdgeInsets.all(padding) : null,
        visualDensity: visualDensity,
        materialTapTargetSize: materialTapTargetSize,
        elevation: useElevation ? elevation : null,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        iconTheme: buildIconTheme(),
        selectedShadowColor: selectedShadowColor,
        showCheckmark: showCheckmark,
        checkmarkColor: checkmarkColor,
        avatarBorder: buildAvatarBorder(),
        avatarBoxConstraints:
            useAvatarConstraints ? BoxConstraints.tightFor(width: avatarConstraint, height: avatarConstraint) : null,
        deleteIconBoxConstraints:
            useDeleteConstraints ? BoxConstraints.tightFor(width: deleteConstraint, height: deleteConstraint) : null,
        chipAnimationStyle: buildAnimationStyle(),
      ),
    );
  }

  Widget? buildAvatar(_ActorFilterEntry actor) {
    if (!useAvatar) {
      return null;
    }
    return CircleAvatar(child: Text(actor.initials));
  }

  TextStyle? buildLabelStyle() {
    if (!useLabelStyle) {
      return null;
    }
    return TextStyle(fontSize: labelFontSize, color: labelColor);
  }

  BorderSide? buildSide() {
    if (!useSide) {
      return null;
    }
    return BorderSide(color: sideColor ?? Colors.black54, width: sideWidth);
  }

  OutlinedBorder? buildShape() => switch (shapeKind) {
        ShapeKind.none => null,
        ShapeKind.rounded => RoundedRectangleBorder(borderRadius: BorderRadius.circular(shapeRadius)),
        ShapeKind.stadium => const StadiumBorder(),
      };

  ShapeBorder buildAvatarBorder() => switch (avatarBorderKind) {
        ShapeKind.rounded => RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        _ => const CircleBorder(),
      };

  IconThemeData? buildIconTheme() {
    if (!useIconTheme) {
      return null;
    }
    return IconThemeData(size: iconThemeSize, color: iconThemeColor);
  }

  ChipAnimationStyle? buildAnimationStyle() {
    if (!useAnimationStyle) {
      return null;
    }
    final style = AnimationStyle(duration: Duration(milliseconds: animMs.round()));
    return ChipAnimationStyle(
      enableAnimation: style,
      selectAnimation: style,
      avatarDrawerAnimation: style,
      deleteDrawerAnimation: style,
    );
  }

  Widget buildContentCard() {
    return NDecorationCard(
      icon: const Icon(Icons.person_outline_rounded),
      title: '构造与内容',
      subtitle: 'constructor · avatar · delete · checkmark · animation',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'constructor',
            child: buildChoiceChips(
              values: _ChipKind.values,
              isSelected: (e) => kind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('constructor ${e.name}', () => kind = e),
            ),
          ),
          buildSwitch(
            title: 'avatar',
            value: useAvatar,
            onChanged: (v) => onMark('avatar ${v ? 'on' : 'null'}', () => useAvatar = v),
          ),
          if (useAvatar)
            buildField(
              label: 'avatarBorder',
              showTopGap: true,
              child: buildChoiceChips(
                values: const [ShapeKind.none, ShapeKind.rounded],
                isSelected: (e) => avatarBorderKind == e,
                labelOf: (e) => e == ShapeKind.none ? 'circle' : e.name,
                onChanged: (e) => onMark('avatarBorder ${e == ShapeKind.none ? 'circle' : e.name}', () => avatarBorderKind = e),
              ),
            ),
          buildSwitch(
            title: 'onDeleted',
            value: useDelete,
            onChanged: (v) => onMark('onDeleted ${v ? 'on' : 'null'}', () => useDelete = v),
          ),
          if (useDelete)
            buildField(
              label: 'deleteIconColor',
              showTopGap: true,
              child: buildColorDots(
                value: deleteIconColor,
                onChanged: (e) => onMark('deleteIconColor ${e ?? 'null'}', () => deleteIconColor = e),
              ),
            ),
          buildSwitch(
            title: 'tooltip',
            value: useTooltip,
            onChanged: (v) => onMark('tooltip ${v ? 'on' : 'null'}', () => useTooltip = v),
          ),
          buildSwitch(
            title: 'onSelected',
            value: enabled,
            onChanged: (v) => onMark('onSelected ${v ? 'on' : 'null'}', () => enabled = v),
          ),
          buildField(
            label: 'showCheckmark',
            showTopGap: true,
            child: buildChoiceChips(
              values: const <bool?>[null, true, false],
              isSelected: (e) => showCheckmark == e,
              labelOf: (e) => e == null ? '默' : '$e',
              onChanged: (e) => onMark('showCheckmark ${e ?? 'null'}', () => showCheckmark = e),
            ),
          ),
          buildField(
            label: 'checkmarkColor',
            showTopGap: true,
            child: buildColorDots(
              value: checkmarkColor,
              onChanged: (e) => onMark('checkmarkColor ${e ?? 'null'}', () => checkmarkColor = e),
            ),
          ),
          buildSwitch(
            title: 'autofocus',
            value: autofocus,
            onChanged: (v) => onMark('autofocus $v', () => autofocus = v),
          ),
          buildSwitch(
            title: 'chipAnimationStyle',
            value: useAnimationStyle,
            onChanged: (v) => onMark('chipAnimationStyle ${v ? 'on' : 'null'}', () => useAnimationStyle = v),
          ),
          if (useAnimationStyle)
            buildSlider(
              label: 'animation.duration',
              value: animMs,
              min: 50,
              max: 800,
              onChanged: (v) => onMark('animation.duration ${v.round()}ms', () => animMs = v),
              durationLabel: true,
            ),
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.palette_outlined),
      title: '表面',
      subtitle: 'color · shape · side · clipBehavior',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'backgroundColor',
            child: buildColorDots(
              value: backgroundColor,
              onChanged: (e) => onMark('backgroundColor ${e ?? 'null'}', () => backgroundColor = e),
            ),
          ),
          buildField(
            label: 'selectedColor',
            showTopGap: true,
            child: buildColorDots(
              value: selectedColor,
              onChanged: (e) => onMark('selectedColor ${e ?? 'null'}', () => selectedColor = e),
            ),
          ),
          if (!enabled)
            buildField(
              label: 'disabledColor',
              showTopGap: true,
              child: buildColorDots(
                value: disabledColor,
                onChanged: (e) => onMark('disabledColor ${e ?? 'null'}', () => disabledColor = e),
              ),
            ),
          buildField(
            label: 'color',
            showTopGap: true,
            child: buildColorDots(
              value: chipColor,
              onChanged: (e) => onMark('color ${e ?? 'null'}', () => chipColor = e),
            ),
          ),
          buildField(
            label: 'shadowColor',
            showTopGap: true,
            child: buildColorDots(
              value: shadowColor,
              onChanged: (e) => onMark('shadowColor ${e ?? 'null'}', () => shadowColor = e),
            ),
          ),
          buildField(
            label: 'surfaceTintColor',
            showTopGap: true,
            child: buildColorDots(
              value: surfaceTintColor,
              onChanged: (e) => onMark('surfaceTintColor ${e ?? 'null'}', () => surfaceTintColor = e),
            ),
          ),
          buildField(
            label: 'selectedShadowColor',
            showTopGap: true,
            child: buildColorDots(
              value: selectedShadowColor,
              onChanged: (e) => onMark('selectedShadowColor ${e ?? 'null'}', () => selectedShadowColor = e),
            ),
          ),
          buildField(
            label: 'shape',
            showTopGap: true,
            child: buildChoiceChips(
              values: ShapeKind.values,
              isSelected: (e) => shapeKind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('shape ${e.name}', () => shapeKind = e),
            ),
          ),
          if (shapeKind == ShapeKind.rounded)
            buildSlider(
              label: 'shape.radius',
              value: shapeRadius,
              min: 0,
              max: 24,
              onChanged: (v) => onMark('shape.radius ${v.toStringAsFixed(1)}', () => shapeRadius = v),
            ),
          buildSwitch(
            title: 'side',
            value: useSide,
            onChanged: (v) => onMark('side ${v ? 'on' : 'null'}', () => useSide = v),
          ),
          if (useSide) ...[
            buildField(
              label: 'side.color',
              showTopGap: true,
              child: buildColorDots(
                value: sideColor,
                onChanged: (e) => onMark('side.color ${e ?? 'null'}', () => sideColor = e),
              ),
            ),
            buildSlider(
              label: 'side.width',
              value: sideWidth,
              min: 0.5,
              max: 4,
              onChanged: (v) => onMark('side.width ${v.toStringAsFixed(1)}', () => sideWidth = v),
            ),
          ],
          buildField(
            label: 'clipBehavior',
            showTopGap: true,
            child: buildChoiceChips(
              values: Clip.values,
              isSelected: (e) => clipBehavior == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('clipBehavior ${e.name}', () => clipBehavior = e),
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
      subtitle: 'padding · elevation · density',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(
            title: 'padding',
            value: usePadding,
            onChanged: (v) => onMark('padding ${v ? 'on' : 'null'}', () => usePadding = v),
          ),
          if (usePadding)
            buildSlider(
              label: 'padding',
              value: padding,
              min: 0,
              max: 16,
              onChanged: (v) => onMark('padding ${v.toStringAsFixed(1)}', () => padding = v),
            ),
          buildSwitch(
            title: 'labelPadding',
            value: useLabelPadding,
            onChanged: (v) => onMark('labelPadding ${v ? 'on' : 'null'}', () => useLabelPadding = v),
          ),
          if (useLabelPadding)
            buildSlider(
              label: 'labelPadding',
              value: labelPadding,
              min: 0,
              max: 16,
              onChanged: (v) => onMark('labelPadding ${v.toStringAsFixed(1)}', () => labelPadding = v),
            ),
          buildSwitch(
            title: 'labelStyle',
            value: useLabelStyle,
            onChanged: (v) => onMark('labelStyle ${v ? 'on' : 'null'}', () => useLabelStyle = v),
          ),
          if (useLabelStyle) ...[
            buildSlider(
              label: 'labelStyle.fontSize',
              value: labelFontSize,
              min: 10,
              max: 22,
              onChanged: (v) => onMark('labelStyle.fontSize ${v.toStringAsFixed(1)}', () => labelFontSize = v),
            ),
            buildField(
              label: 'labelStyle.color',
              showTopGap: true,
              child: buildColorDots(
                value: labelColor,
                onChanged: (e) => onMark('labelStyle.color ${e ?? 'null'}', () => labelColor = e),
              ),
            ),
          ],
          buildSwitch(
            title: 'elevation',
            value: useElevation,
            onChanged: (v) => onMark('elevation ${v ? 'on' : 'null'}', () => useElevation = v),
          ),
          if (useElevation)
            buildSlider(
              label: 'elevation',
              value: elevation,
              min: 0,
              max: 12,
              onChanged: (v) => onMark('elevation ${v.toStringAsFixed(1)}', () => elevation = v),
            ),
          buildSwitch(
            title: 'pressElevation',
            value: usePressElevation,
            onChanged: (v) => onMark('pressElevation ${v ? 'on' : 'null'}', () => usePressElevation = v),
          ),
          if (usePressElevation)
            buildSlider(
              label: 'pressElevation',
              value: pressElevation,
              min: 0,
              max: 16,
              onChanged: (v) => onMark('pressElevation ${v.toStringAsFixed(1)}', () => pressElevation = v),
            ),
          buildField(
            label: 'visualDensity',
            showTopGap: true,
            child: buildChoiceChips(
              values: const <VisualDensity?>[
                null,
                VisualDensity.standard,
                VisualDensity.comfortable,
                VisualDensity.compact
              ],
              isSelected: (e) => visualDensity == e,
              labelOf: nameOfDensity,
              onChanged: (e) => onMark('visualDensity ${nameOfDensity(e)}', () => visualDensity = e),
            ),
          ),
          buildField(
            label: 'materialTapTargetSize',
            showTopGap: true,
            child: buildChoiceChips(
              values: const <MaterialTapTargetSize?>[
                null,
                MaterialTapTargetSize.padded,
                MaterialTapTargetSize.shrinkWrap
              ],
              isSelected: (e) => materialTapTargetSize == e,
              labelOf: (e) => e?.name ?? '默',
              onChanged: (e) => onMark('materialTapTargetSize ${e?.name ?? 'null'}', () => materialTapTargetSize = e),
            ),
          ),
          buildSwitch(
            title: 'avatarBoxConstraints',
            value: useAvatarConstraints,
            onChanged: (v) => onMark('avatarBoxConstraints ${v ? 'on' : 'null'}', () => useAvatarConstraints = v),
          ),
          if (useAvatarConstraints)
            buildSlider(
              label: 'avatarBoxConstraints',
              value: avatarConstraint,
              min: 16,
              max: 48,
              onChanged: (v) => onMark('avatarBoxConstraints ${v.toStringAsFixed(1)}', () => avatarConstraint = v),
            ),
          buildSwitch(
            title: 'deleteIconBoxConstraints',
            value: useDeleteConstraints,
            onChanged: (v) => onMark('deleteIconBoxConstraints ${v ? 'on' : 'null'}', () => useDeleteConstraints = v),
          ),
          if (useDeleteConstraints)
            buildSlider(
              label: 'deleteIconBoxConstraints',
              value: deleteConstraint,
              min: 12,
              max: 40,
              onChanged: (v) => onMark('deleteIconBoxConstraints ${v.toStringAsFixed(1)}', () => deleteConstraint = v),
            ),
          buildSwitch(
            title: 'iconTheme',
            value: useIconTheme,
            onChanged: (v) => onMark('iconTheme ${v ? 'on' : 'null'}', () => useIconTheme = v),
          ),
          if (useIconTheme) ...[
            buildSlider(
              label: 'iconTheme.size',
              value: iconThemeSize,
              min: 12,
              max: 28,
              onChanged: (v) => onMark('iconTheme.size ${v.toStringAsFixed(1)}', () => iconThemeSize = v),
            ),
            buildField(
              label: 'iconTheme.color',
              showTopGap: true,
              child: buildColorDots(
                value: iconThemeColor,
                onChanged: (e) => onMark('iconTheme.color ${e ?? 'null'}', () => iconThemeColor = e),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildField({
    required String label,
    required Widget child,
    bool showTopGap = false,
  }) {
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

  String nameOfDensity(VisualDensity? value) => switch (value) {
        null => '默',
        _ when value == VisualDensity.standard => 'standard',
        _ when value == VisualDensity.comfortable => 'comfortable',
        _ when value == VisualDensity.compact => 'compact',
        _ => '$value',
      };

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    setState(() {});
  }

  void onChipSelected(_ActorFilterEntry actor, bool value) {
    if (value) {
      _filters.add(actor);
    } else {
      _filters.removeWhere((e) => e.name == actor.name);
    }
    lastEvent = 'onSelected ${actor.name} $value';
    DLog.d(lastEvent);
    setState(() {});
    final scheme = theme.colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(lastEvent),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void onChipDeleted(_ActorFilterEntry actor) {
    lastEvent = 'onDeleted ${actor.name}';
    DLog.d(lastEvent);
    setState(() {});
    final scheme = theme.colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(lastEvent),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void onReset() {
    _filters.clear();
    kind = _ChipKind.flat;
    useAvatar = true;
    useDelete = false;
    enabled = true;
    autofocus = false;
    useTooltip = false;
    usePadding = false;
    useLabelPadding = false;
    useElevation = false;
    usePressElevation = false;
    useSide = false;
    useLabelStyle = false;
    useIconTheme = false;
    useAvatarConstraints = false;
    useDeleteConstraints = false;
    useAnimationStyle = false;
    showCheckmark = null;
    clipBehavior = Clip.none;
    shapeKind = ShapeKind.none;
    shapeRadius = 8;
    padding = 8;
    labelPadding = 8;
    elevation = 0;
    pressElevation = 8;
    sideWidth = 1;
    labelFontSize = 14;
    iconThemeSize = 18;
    avatarConstraint = 32;
    deleteConstraint = 18;
    animMs = 195;
    backgroundColor = null;
    selectedColor = null;
    disabledColor = null;
    chipColor = null;
    shadowColor = null;
    surfaceTintColor = null;
    selectedShadowColor = null;
    checkmarkColor = null;
    deleteIconColor = null;
    sideColor = null;
    labelColor = null;
    iconThemeColor = null;
    visualDensity = null;
    materialTapTargetSize = null;
    avatarBorderKind = ShapeKind.none;
    lastEvent = '—';
    setState(() {});
  }
}
