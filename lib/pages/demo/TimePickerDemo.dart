//
//  TimePickerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/8/21 3:33 PM.
//  Copyright © 12/8/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_color_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

class TimePickerDemo extends StatefulWidget {
  const TimePickerDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<TimePickerDemo> createState() => _TimePickerDemoState();
}

class _TimePickerDemoState extends State<TimePickerDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

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
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('initialTime.hour'),
            min: 0,
            max: 23,
            value: hour.toDouble().clamp(0, 23),
            onChanged: (v) => onMark('hour ${v.round()}', () => hour = v.round()),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('initialTime.minute'),
            min: 0,
            max: 59,
            value: minute.toDouble().clamp(0, 59),
            onChanged: (v) => onMark('minute ${v.round()}', () => minute = v.round()),
            activeColor: theme.colorScheme.primary,
          ),
          NChoiceChipListItem(
            title: const Text('initialEntryMode'),
            values: TimePickerEntryMode.values,
            value: initialEntryMode,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('initialEntryMode ${e.name}', () => initialEntryMode = e),
          ),
          NChoiceChipListItem(
            title: const Text('orientation'),
            values: [null, ...Orientation.values],
            value: orientation,
            labelOf: (e) => e?.name ?? '默',
            onChanged: (e) => onMark('orientation ${e?.name ?? 'null'}', () => orientation = e),
          ),
          NSwitchListItem(
            title: const Text('barrierDismissible'),
            value: barrierDismissible,
            onChanged: (v) => onMark('barrierDismissible $v', () => barrierDismissible = v),
          ),
          const SizedBox(height: 8),
          NChoiceColorListItem(
            title: const Text('barrierColor'),
            value: barrierColor,
            onChanged: (v) => onMark('barrierColor ${v ?? 'null'}', () => barrierColor = v),
          ),
          NSwitchListItem(
            title: const Text('barrierLabel'),
            value: useBarrierLabel,
            onChanged: (v) => onMark('barrierLabel ${v ? 'dismiss' : 'null'}', () => useBarrierLabel = v),
          ),
          NSwitchListItem(
            title: const Text('useRootNavigator'),
            value: useRootNavigator,
            onChanged: (v) => onMark('useRootNavigator $v', () => useRootNavigator = v),
          ),
          NSwitchListItem(
            title: const Text('builder 24h'),
            value: use24Hour,
            onChanged: (v) => onMark('builder ${v ? '24h' : 'null'}', () => use24Hour = v),
          ),
          NSwitchListItem(
            title: const Text('onEntryModeChanged'),
            value: useOnEntryModeChanged,
            onChanged: (v) => onMark('onEntryModeChanged ${v ? 'on' : 'null'}', () => useOnEntryModeChanged = v),
          ),
          NSwitchListItem(
            title: const Text('routeSettings'),
            value: useRouteSettings,
            onChanged: (v) => onMark('routeSettings ${v ? 'on' : 'null'}', () => useRouteSettings = v),
          ),
          NSwitchListItem(
            title: const Text('anchorPoint'),
            value: useAnchorPoint,
            onChanged: (v) => onMark('anchorPoint ${v ? 'on' : 'null'}', () => useAnchorPoint = v),
          ),
          if (useAnchorPoint) ...[
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('anchorPoint.dx'),
              min: 0,
              max: 400,
              value: anchorX.clamp(0, 400),
              onChanged: (v) => onMark('anchorPoint.dx ${v.round()}', () => anchorX = v),
              activeColor: theme.colorScheme.primary,
            ),
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('anchorPoint.dy'),
              min: 0,
              max: 800,
              value: anchorY.clamp(0, 800),
              onChanged: (v) => onMark('anchorPoint.dy ${v.round()}', () => anchorY = v),
              activeColor: theme.colorScheme.primary,
            ),
          ],
          NSwitchListItem(
            title: const Text('cancelText'),
            value: useCancelText,
            onChanged: (v) => onMark('cancelText ${v ? '取消' : 'null'}', () => useCancelText = v),
          ),
          NSwitchListItem(
            title: const Text('confirmText'),
            value: useConfirmText,
            onChanged: (v) => onMark('confirmText ${v ? '确定' : 'null'}', () => useConfirmText = v),
          ),
          NSwitchListItem(
            title: const Text('helpText'),
            value: useHelpText,
            onChanged: (v) => onMark('helpText ${v ? '选择时间' : 'null'}', () => useHelpText = v),
          ),
          NSwitchListItem(
            title: const Text('errorInvalidText'),
            value: useErrorInvalidText,
            onChanged: (v) => onMark('errorInvalidText ${v ? '无效时间' : 'null'}', () => useErrorInvalidText = v),
          ),
          NSwitchListItem(
            title: const Text('hourLabelText'),
            value: useHourLabelText,
            onChanged: (v) => onMark('hourLabelText ${v ? '时' : 'null'}', () => useHourLabelText = v),
          ),
          NSwitchListItem(
            title: const Text('minuteLabelText'),
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

