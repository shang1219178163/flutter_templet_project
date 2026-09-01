//
//  CalendarDatePickerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/7/21 6:02 PM.
//  Copyright © 12/7/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// 原 Demo 周五周六不可选
bool _predicateOriginal(DateTime val) => val.weekday != 5 && val.weekday != 6;

/// 仅工作日可选
bool _predicateWeekend(DateTime val) => val.weekday != DateTime.saturday && val.weekday != DateTime.sunday;

/// selectableDayPredicate 预设
enum _PredicateKind {
  none(label: 'none', predicate: null),
  original(label: 'original', predicate: _predicateOriginal),
  weekend(label: 'weekend', predicate: _predicateWeekend);

  const _PredicateKind({required this.label, required this.predicate});

  /// Chip 文案
  final String label;

  /// 可选日谓词；[none] 为 null
  final SelectableDayPredicate? predicate;
}

/// initialDate 预设
enum _InitialKind {
  today(label: 'today'),
  none(label: 'none'),
  first(label: 'first'),
  last(label: 'last');

  const _InitialKind({required this.label});

  /// Chip 文案
  final String label;

  /// 构造 initialDate；边界与谓词由页面注入
  DateTime? date({
    required DateTime firstDate,
    required DateTime lastDate,
    SelectableDayPredicate? predicate,
  }) {
    return switch (this) {
      _InitialKind.none => null,
      _InitialKind.today => _selectableOrNull(
          DateTime.now(),
          firstDate: firstDate,
          lastDate: lastDate,
          predicate: predicate,
        ),
      _InitialKind.first => _selectableOrNull(
          firstDate,
          firstDate: firstDate,
          lastDate: lastDate,
          predicate: predicate,
        ),
      _InitialKind.last => _selectableOrNull(
          lastDate,
          firstDate: firstDate,
          lastDate: lastDate,
          predicate: predicate,
        ),
    };
  }

  /// 将 [raw] 钳到 [firstDate]～[lastDate]，并满足 [predicate]（若有）
  DateTime? _selectableOrNull(
    DateTime raw, {
    required DateTime firstDate,
    required DateTime lastDate,
    SelectableDayPredicate? predicate,
  }) {
    var d = DateUtils.dateOnly(raw);
    if (d.isBefore(firstDate)) {
      d = firstDate;
    }
    if (d.isAfter(lastDate)) {
      d = lastDate;
    }
    if (predicate == null) {
      return d;
    }
    for (var i = 0; i < 60; i++) {
      final next = d.add(Duration(days: i));
      if (next.isAfter(lastDate)) {
        break;
      }
      if (predicate(next)) {
        return DateUtils.dateOnly(next);
      }
    }
    for (var i = 1; i < 60; i++) {
      final prev = d.subtract(Duration(days: i));
      if (prev.isBefore(firstDate)) {
        break;
      }
      if (predicate(prev)) {
        return DateUtils.dateOnly(prev);
      }
    }
    return null;
  }
}

/// currentDate 预设
enum _CurrentKind {
  defaults(label: 'defaults'),
  today(label: 'today'),
  first(label: 'first'),
  last(label: 'last');

  const _CurrentKind({required this.label});

  /// Chip 文案
  final String label;

  /// 构造 currentDate；边界由页面注入
  DateTime? date({
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    return switch (this) {
      _CurrentKind.defaults => null,
      _CurrentKind.today => DateTime.now(),
      _CurrentKind.first => firstDate,
      _CurrentKind.last => lastDate,
    };
  }
}

class CalendarDatePickerDemo extends StatefulWidget {
  const CalendarDatePickerDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<CalendarDatePickerDemo> createState() => _CalendarDatePickerDemoState();
}

class _CalendarDatePickerDemoState extends State<CalendarDatePickerDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

  final scrollController = ScrollController();

  /// 原 Demo DateTime(2020, 6, 0) / DateTime(2030, 7, 0) / now / 周五周六不可选
  int firstYear = 2020;
  int firstMonth = 6;
  int lastYear = 2030;
  int lastMonth = 7;
  _InitialKind initialKind = _InitialKind.today;
  _CurrentKind currentKind = _CurrentKind.defaults;
  DatePickerMode initialCalendarMode = DatePickerMode.day;
  _PredicateKind predicateKind = _PredicateKind.original;
  int pickerEpoch = 0;
  DateTime selectedDate = DateTime.now();
  String lastEvent = '—';

  DateTime get firstDate => DateTime(firstYear, firstMonth, 0);

  DateTime get lastDate => DateTime(lastYear, lastMonth, 0);

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final previewHeight = (constraints.maxHeight * 0.5).clamp(380.0, 560.0);
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
                            NLangEnum.en: 'Widget CalendarDatePicker',
                            NLangEnum.zh: '组件 CalendarDatePicker',
                          },
                          items: [
                            {
                              NLangEnum.en:
                                  'Original range is DateTime(2020, 6, 0) … DateTime(2030, 7, 0). Friday and Saturday are disabled.',
                              NLangEnum.zh: '原范围是 DateTime(2020, 6, 0) 到 DateTime(2030, 7, 0)。周五、周六不可选。',
                            },
                            {
                              NLangEnum.en:
                                  'Changing initialDate or initialCalendarMode rebuilds the picker via a new Key. The button is the original showDatePicker.',
                              NLangEnum.zh: '改 initialDate 或 initialCalendarMode 会换 Key 重建。下方按钮是原来的 showDatePicker。',
                            },
                          ],
                        ),
                        buildConstructCard(),
                        buildBehaviorCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildPreview(double previewHeight) {
    final scheme = theme.colorScheme;
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
            child: ClipRect(
              child: ColoredBox(
                color: scheme.surface,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildCalendarDatePicker(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: ElevatedButton(
                          onPressed: () => onSelectDate(context),
                          child: Text("${selectedDate.toLocal()}".substring(0, 10)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text(
              lastEvent,
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

  Widget buildCalendarDatePicker() {
    return CalendarDatePicker(
      key: ValueKey(pickerEpoch),
      initialDate: initialKind.date(
        firstDate: firstDate,
        lastDate: lastDate,
        predicate: predicateKind.predicate,
      ),
      firstDate: firstDate,
      lastDate: lastDate,
      currentDate: currentKind.date(firstDate: firstDate, lastDate: lastDate),
      initialCalendarMode: initialCalendarMode,
      selectableDayPredicate: predicateKind.predicate,
      onDateChanged: onDateChanged,
      onDisplayedMonthChanged: onDisplayedMonthChanged,
    );
  }

  void bumpPicker() {
    pickerEpoch += 1;
  }

  void ensureRange() {
    if (lastDate.isBefore(firstDate)) {
      lastYear = firstYear;
      lastMonth = firstMonth;
    }
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'initialDate · firstDate · lastDate · currentDate · initialCalendarMode',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceChipListItem<_InitialKind>(
            title: const Text('initialDate'),
            values: _InitialKind.values,
            value: initialKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('initialDate ${e.label}', () {
              initialKind = e;
              bumpPicker();
            }),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem<_CurrentKind>(
            title: const Text('currentDate'),
            values: _CurrentKind.values,
            value: currentKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('currentDate ${e.label}', () => currentKind = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem<DatePickerMode>(
            title: const Text('initialCalendarMode'),
            values: DatePickerMode.values,
            value: initialCalendarMode,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('initialCalendarMode ${e.name}', () {
              initialCalendarMode = e;
              bumpPicker();
            }),
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('firstDate.year'),
            min: 2015,
            max: 2028,
            value: firstYear.toDouble().clamp(2015, 2028),
            onChanged: (v) => onMark('firstDate.year ${v.round()}', () {
              firstYear = v.round();
              ensureRange();
              bumpPicker();
            }),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('firstDate.month'),
            min: 1,
            max: 12,
            value: firstMonth.toDouble().clamp(1, 12),
            onChanged: (v) => onMark('firstDate.month ${v.round()}', () {
              firstMonth = v.round();
              ensureRange();
              bumpPicker();
            }),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('lastDate.year'),
            min: 2020,
            max: 2040,
            value: lastYear.toDouble().clamp(2020, 2040),
            onChanged: (v) => onMark('lastDate.year ${v.round()}', () {
              lastYear = v.round();
              ensureRange();
              bumpPicker();
            }),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('lastDate.month'),
            min: 1,
            max: 12,
            value: lastMonth.toDouble().clamp(1, 12),
            onChanged: (v) => onMark('lastDate.month ${v.round()}', () {
              lastMonth = v.round();
              ensureRange();
              bumpPicker();
            }),
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_rounded),
      title: '行为',
      subtitle: 'selectableDayPredicate · onDateChanged · onDisplayedMonthChanged',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceChipListItem<_PredicateKind>(
            title: const Text('selectableDayPredicate'),
            values: _PredicateKind.values,
            value: predicateKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('selectableDayPredicate ${e.label}', () {
              predicateKind = e;
              bumpPicker();
            }),
          ),
        ],
      ),
    );
  }

  void onDateChanged(DateTime value) {
    onMark('onDateChanged ${DateUtils.dateOnly(value)}', () => selectedDate = value);
  }

  void onDisplayedMonthChanged(DateTime value) {
    onMark('onDisplayedMonthChanged ${value.year}-${value.month.toString().padLeft(2, '0')}');
  }

  Future<void> onSelectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      onMark('onSelectDate ${DateUtils.dateOnly(picked)}', () => selectedDate = picked);
    }
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onReset() {
    firstYear = 2020;
    firstMonth = 6;
    lastYear = 2030;
    lastMonth = 7;
    initialKind = _InitialKind.today;
    currentKind = _CurrentKind.defaults;
    initialCalendarMode = DatePickerMode.day;
    predicateKind = _PredicateKind.original;
    selectedDate = DateTime.now();
    lastEvent = '—';
    bumpPicker();
    setState(() {});
  }
}
