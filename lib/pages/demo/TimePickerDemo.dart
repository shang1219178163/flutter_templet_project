//
//  TimePickerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/8/21 3:33 PM.
//  Copyright © 12/8/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

class TimePickerDemo extends StatefulWidget {
  const TimePickerDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<TimePickerDemo> createState() => _TimePickerDemoState();
}

class _TimePickerDemoState extends State<TimePickerDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  /// 最近事件
  String lastEvent = '—';
  /// 初始时
  int hour = 7;
  /// 初始分
  int minute = 15;
  /// 进入方式
  TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial;
  /// 方向
  Orientation? orientation;
  /// 点击遮罩是否关闭
  bool barrierDismissible = true;
  /// 遮罩色
  Color? barrierColor;
  /// 是否传入 barrierLabel
  bool useBarrierLabel = false;
  /// 是否用根 Navigator
  bool useRootNavigator = true;
  /// builder 强制 24 小时制
  bool use24Hour = false;
  /// 是否传入 onEntryModeChanged
  bool useOnEntryModeChanged = true;
  /// 是否传入 routeSettings
  bool useRouteSettings = false;
  /// 是否传入 anchorPoint
  bool useAnchorPoint = false;
  /// 锚点 X
  double anchorX = 0;
  /// 锚点 Y
  double anchorY = 0;
  /// 是否传入 cancelText
  bool useCancelText = false;
  /// 是否传入 confirmText
  bool useConfirmText = false;
  /// 是否传入 helpText
  bool useHelpText = false;
  /// 是否传入 errorInvalidText
  bool useErrorInvalidText = false;
  /// 是否传入 hourLabelText
  bool useHourLabelText = false;
  /// 是否传入 minuteLabelText
  bool useMinuteLabelText = false;

  TimeOfDay get initialTime => TimeOfDay(hour: hour, minute: minute);

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
    return Column(
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
                      NLangEnum.en: 'showTimePicker',
                      NLangEnum.zh: 'showTimePicker',
                    },
                    items: [
                      {
                        NLangEnum.en: 'SELECT TIME and Selected time are the original children. initialTime defaults to 7:15.',
                        NLangEnum.zh: 'SELECT TIME 和 Selected time 是原内容。initialTime 默认 7:15。',
                      },
                    ],
                  ),
                  buildPropCard(),
                ],
              ),
            ),
          ),
        ),
      ],
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
            ElevatedButton(
              onPressed: onSelectTime,
              child: const Text('SELECT TIME'),
            ),
            const SizedBox(height: 8),
            Text('Selected time: ${initialTime.format(context)}'),
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

  Widget buildPropCard() {
    return NDecorationCard(
      icon: const Icon(Icons.schedule),
      title: '属性',
      subtitle: 'initialTime  initialEntryMode  orientation  barrier  builder  onEntryModeChanged',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSlider(
            label: 'initialTime.hour',
            value: hour.toDouble(),
            min: 0,
            max: 23,
            onChanged: (v) => onMark('hour ${v.round()}', () => hour = v.round()),
          ),
          buildSlider(
            label: 'initialTime.minute',
            value: minute.toDouble(),
            min: 0,
            max: 59,
            onChanged: (v) => onMark('minute ${v.round()}', () => minute = v.round()),
          ),
          buildChipRow(
            label: 'initialEntryMode',
            values: TimePickerEntryMode.values,
            value: initialEntryMode,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('initialEntryMode ${e.name}', () => initialEntryMode = e),
          ),
          buildChipRow(
            label: 'orientation',
            values: [null, ...Orientation.values],
            value: orientation,
            labelOf: (e) => e?.name ?? '默',
            onChanged: (e) => onMark('orientation ${e?.name ?? 'null'}', () => orientation = e),
          ),
          buildSwitch(
            title: 'barrierDismissible',
            value: barrierDismissible,
            onChanged: (v) => onMark('barrierDismissible $v', () => barrierDismissible = v),
          ),
          buildColorRow(
            'barrierColor',
            barrierColor,
            (v) => onMark('barrierColor ${v ?? 'null'}', () => barrierColor = v),
          ),
          buildSwitch(
            title: 'barrierLabel',
            value: useBarrierLabel,
            onChanged: (v) => onMark('barrierLabel ${v ? 'dismiss' : 'null'}', () => useBarrierLabel = v),
          ),
          buildSwitch(
            title: 'useRootNavigator',
            value: useRootNavigator,
            onChanged: (v) => onMark('useRootNavigator $v', () => useRootNavigator = v),
          ),
          buildSwitch(
            title: 'builder 24h',
            value: use24Hour,
            onChanged: (v) => onMark('builder ${v ? '24h' : 'null'}', () => use24Hour = v),
          ),
          buildSwitch(
            title: 'onEntryModeChanged',
            value: useOnEntryModeChanged,
            onChanged: (v) => onMark('onEntryModeChanged ${v ? 'on' : 'null'}', () => useOnEntryModeChanged = v),
          ),
          buildSwitch(
            title: 'routeSettings',
            value: useRouteSettings,
            onChanged: (v) => onMark('routeSettings ${v ? 'on' : 'null'}', () => useRouteSettings = v),
          ),
          buildSwitch(
            title: 'anchorPoint',
            value: useAnchorPoint,
            onChanged: (v) => onMark('anchorPoint ${v ? 'on' : 'null'}', () => useAnchorPoint = v),
          ),
          if (useAnchorPoint) ...[
            buildSlider(
              label: 'anchorPoint.dx',
              value: anchorX,
              min: 0,
              max: 400,
              onChanged: (v) => onMark('anchorPoint.dx ${v.round()}', () => anchorX = v),
            ),
            buildSlider(
              label: 'anchorPoint.dy',
              value: anchorY,
              min: 0,
              max: 800,
              onChanged: (v) => onMark('anchorPoint.dy ${v.round()}', () => anchorY = v),
            ),
          ],
          buildSwitch(
            title: 'cancelText',
            value: useCancelText,
            onChanged: (v) => onMark('cancelText ${v ? '取消' : 'null'}', () => useCancelText = v),
          ),
          buildSwitch(
            title: 'confirmText',
            value: useConfirmText,
            onChanged: (v) => onMark('confirmText ${v ? '确定' : 'null'}', () => useConfirmText = v),
          ),
          buildSwitch(
            title: 'helpText',
            value: useHelpText,
            onChanged: (v) => onMark('helpText ${v ? '选择时间' : 'null'}', () => useHelpText = v),
          ),
          buildSwitch(
            title: 'errorInvalidText',
            value: useErrorInvalidText,
            onChanged: (v) => onMark('errorInvalidText ${v ? '无效时间' : 'null'}', () => useErrorInvalidText = v),
          ),
          buildSwitch(
            title: 'hourLabelText',
            value: useHourLabelText,
            onChanged: (v) => onMark('hourLabelText ${v ? '时' : 'null'}', () => useHourLabelText = v),
          ),
          buildSwitch(
            title: 'minuteLabelText',
            value: useMinuteLabelText,
            onChanged: (v) => onMark('minuteLabelText ${v ? '分' : 'null'}', () => useMinuteLabelText = v),
          ),
        ],
      ),
    );
  }

  Widget onBuilder(context, child) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
      child: child ?? const SizedBox.shrink(),
    );
  }

  Future<void> onSelectTime() async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: use24Hour ? onBuilder : null,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: useBarrierLabel ? 'dismiss' : null,
      useRootNavigator: useRootNavigator,
      initialEntryMode: initialEntryMode,
      cancelText: useCancelText ? '取消' : null,
      confirmText: useConfirmText ? '确定' : null,
      helpText: useHelpText ? '选择时间' : null,
      errorInvalidText: useErrorInvalidText ? '无效时间' : null,
      hourLabelText: useHourLabelText ? '时' : null,
      minuteLabelText: useMinuteLabelText ? '分' : null,
      routeSettings: useRouteSettings ? const RouteSettings(name: 'timePicker') : null,
      onEntryModeChanged: useOnEntryModeChanged ? onEntryModeChanged : null,
      anchorPoint: useAnchorPoint ? Offset(anchorX, anchorY) : null,
      orientation: orientation,
    );
    if (!mounted) {
      return;
    }
    if (newTime == null) {
      onMark('showTimePicker null');
      return;
    }
    onMark('showTimePicker ${newTime.format(context)}', () {
      hour = newTime.hour;
      minute = newTime.minute;
    });
  }

  void onEntryModeChanged(TimePickerEntryMode mode) {
    onMark('onEntryModeChanged ${mode.name}');
  }

  Widget buildChipRow<T>({
    required String label,
    required List<T> values,
    required T value,
    required String Function(T) labelOf,
    required ValueChanged<T> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        buildChoiceChips(values: values, value: value, labelOf: labelOf, onChanged: onChanged),
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

  Widget buildColorRow(String label, Color? value, ValueChanged<Color?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        buildColorDots(value: value, onChanged: onChanged),
      ],
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
  }) {
    final theme = Theme.of(context);
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
    DLog.d(event);
    setState(() {});
  }

  void onReset() {
    lastEvent = '—';
    hour = 7;
    minute = 15;
    initialEntryMode = TimePickerEntryMode.dial;
    orientation = null;
    barrierDismissible = true;
    barrierColor = null;
    useBarrierLabel = false;
    useRootNavigator = true;
    use24Hour = false;
    useOnEntryModeChanged = true;
    useRouteSettings = false;
    useAnchorPoint = false;
    anchorX = 0;
    anchorY = 0;
    useCancelText = false;
    useConfirmText = false;
    useHelpText = false;
    useErrorInvalidText = false;
    useHourLabelText = false;
    useMinuteLabelText = false;
    setState(() {});
  }
}

