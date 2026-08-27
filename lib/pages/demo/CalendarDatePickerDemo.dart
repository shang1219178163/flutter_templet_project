//
//  CalendarDatePickerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/7/21 6:02 PM.
//  Copyright © 12/7/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// selectableDayPredicate 预设
enum _PredicateKind { original, none, weekend }

/// initialDate 预设
enum _InitialKind { today, none, first, last }

/// currentDate 预设
enum _CurrentKind { defaults, today, first, last }

class CalendarDatePickerDemo extends StatefulWidget {
  const CalendarDatePickerDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<CalendarDatePickerDemo> createState() => _CalendarDatePickerDemoState();
}

class _CalendarDatePickerDemoState extends State<CalendarDatePickerDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

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
                                  'Changing initialDate or initialCalendarMode rebuilds the picker via a new Key. The button below is the original showDatePicker.',
                              NLangEnum.zh: '改 initialDate 或 initialCalendarMode 会换 Key 重建。下方按钮是原来的 showDatePicker。',
                            },
                            {
                              NLangEnum.en:
                                  'onDateChanged and onDisplayedMonthChanged show under the preview. CupertinoDatePicker was unused and is not in the panel.',
                              NLangEnum.zh: 'onDateChanged、onDisplayedMonthChanged 显示在预览下方。未使用的 CupertinoDatePicker 不进面板。',
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
    final theme = Theme.of(context);
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
      initialDate: initialDateOf(),
      firstDate: firstDate,
      lastDate: lastDate,
      currentDate: currentDateOf(),
      initialCalendarMode: initialCalendarMode,
      selectableDayPredicate: predicateOf(),
      onDateChanged: onDateChanged,
      onDisplayedMonthChanged: onDisplayedMonthChanged,
    );
  }

  DateTime? initialDateOf() {
    switch (initialKind) {
      case _InitialKind.none:
        return null;
      case _InitialKind.today:
        return selectableOrNull(DateTime.now());
      case _InitialKind.first:
        return selectableOrNull(firstDate);
      case _InitialKind.last:
        return selectableOrNull(lastDate);
    }
  }

  DateTime? currentDateOf() {
    switch (currentKind) {
      case _CurrentKind.defaults:
        return null;
      case _CurrentKind.today:
        return DateTime.now();
      case _CurrentKind.first:
        return firstDate;
      case _CurrentKind.last:
        return lastDate;
    }
  }

  SelectableDayPredicate? predicateOf() {
    switch (predicateKind) {
      case _PredicateKind.none:
        return null;
      case _PredicateKind.original:
        return (val) {
          if (val.weekday == 5 || val.weekday == 6) {
            return false;
          }
          return true;
        };
      case _PredicateKind.weekend:
        return (val) {
          if (val.weekday == DateTime.saturday || val.weekday == DateTime.sunday) {
            return false;
          }
          return true;
        };
    }
  }

  DateTime? selectableOrNull(DateTime raw) {
    var d = DateUtils.dateOnly(raw);
    if (d.isBefore(firstDate)) {
      d = firstDate;
    }
    if (d.isAfter(lastDate)) {
      d = lastDate;
    }
    final pred = predicateOf();
    if (pred == null) {
      return d;
    }
    for (var i = 0; i < 60; i++) {
      final next = d.add(Duration(days: i));
      if (next.isAfter(lastDate)) {
        break;
      }
      if (pred(next)) {
        return DateUtils.dateOnly(next);
      }
    }
    for (var i = 1; i < 60; i++) {
      final prev = d.subtract(Duration(days: i));
      if (prev.isBefore(firstDate)) {
        break;
      }
      if (pred(prev)) {
        return DateUtils.dateOnly(prev);
      }
    }
    return null;
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
          buildField(
            label: 'initialDate',
            child: buildChoiceChips(
              values: _InitialKind.values,
              isSelected: (e) => initialKind == e,
              labelOf: (e) => e.name,
              onChanged: onInitialKind,
            ),
          ),
          buildField(
            label: 'currentDate',
            showTopGap: true,
            child: buildChoiceChips(
              values: _CurrentKind.values,
              isSelected: (e) => currentKind == e,
              labelOf: (e) => e.name,
              onChanged: onCurrentKind,
            ),
          ),
          buildField(
            label: 'initialCalendarMode',
            showTopGap: true,
            child: buildChoiceChips(
              values: DatePickerMode.values,
              isSelected: (e) => initialCalendarMode == e,
              labelOf: (e) => e.name,
              onChanged: onInitialCalendarMode,
            ),
          ),
          buildSlider(
            label: 'firstDate.year',
            value: firstYear.toDouble(),
            min: 2015,
            max: 2028,
            onChanged: onFirstYear,
          ),
          buildSlider(
            label: 'firstDate.month',
            value: firstMonth.toDouble(),
            min: 1,
            max: 12,
            onChanged: onFirstMonth,
          ),
          buildSlider(
            label: 'lastDate.year',
            value: lastYear.toDouble(),
            min: 2020,
            max: 2040,
            onChanged: onLastYear,
          ),
          buildSlider(
            label: 'lastDate.month',
            value: lastMonth.toDouble(),
            min: 1,
            max: 12,
            onChanged: onLastMonth,
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
          buildField(
            label: 'selectableDayPredicate',
            child: buildChoiceChips(
              values: _PredicateKind.values,
              isSelected: (e) => predicateKind == e,
              labelOf: (e) => e.name,
              onChanged: onPredicateKind,
            ),
          ),
        ],
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
      value: value,
      onChanged: onChanged,
      activeColor: scheme.primary,
    );
  }

  void onInitialKind(_InitialKind value) {
    initialKind = value;
    bumpPicker();
    setState(() {});
  }

  void onCurrentKind(_CurrentKind value) {
    currentKind = value;
    setState(() {});
  }

  void onInitialCalendarMode(DatePickerMode value) {
    initialCalendarMode = value;
    bumpPicker();
    setState(() {});
  }

  void onFirstYear(double value) {
    firstYear = value.round();
    ensureRange();
    bumpPicker();
    setState(() {});
  }

  void onFirstMonth(double value) {
    firstMonth = value.round();
    ensureRange();
    bumpPicker();
    setState(() {});
  }

  void onLastYear(double value) {
    lastYear = value.round();
    ensureRange();
    bumpPicker();
    setState(() {});
  }

  void onLastMonth(double value) {
    lastMonth = value.round();
    ensureRange();
    bumpPicker();
    setState(() {});
  }

  void onPredicateKind(_PredicateKind value) {
    predicateKind = value;
    bumpPicker();
    setState(() {});
  }

  void onDateChanged(DateTime value) {
    selectedDate = value;
    lastEvent = 'onDateChanged ${DateUtils.dateOnly(value)}';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onDisplayedMonthChanged(DateTime value) {
    lastEvent = 'onDisplayedMonthChanged ${value.year}-${value.month.toString().padLeft(2, '0')}';
    DLog.d(lastEvent);
    setState(() {});
  }

  Future<void> onSelectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      lastEvent = 'onSelectDate ${DateUtils.dateOnly(picked)}';
      DLog.d(lastEvent);
      setState(() {});
    }
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
