//
//  NumberFormatDemo.dart
//  flutter_templet_project
//
//  Created by shang on 8/3/21 2:35 PM.
//  Copyright © 8/3/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// NumberFormat 工厂，对应 intl 非弃用构造
enum _FormatKind {
  custom,
  decimalPattern,
  decimalPatternDigits,
  percentPattern,
  decimalPercentPattern,
  scientificPattern,
  currency,
  simpleCurrency,
  compact,
  compactLong,
  compactCurrency,
  compactSimpleCurrency,
}

class NumberFormatDemo extends StatefulWidget {
  const NumberFormatDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<NumberFormatDemo> createState() => _NumberFormatDemoState();
}

class _NumberFormatDemoState extends State<NumberFormatDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  /// 工厂类型，原 Demo NumberFormat("#,##0.00", "en_US")
  _FormatKind formatKind = _FormatKind.custom;
  /// 格式模式
  String? pattern = '#,##0.00';
  /// 语言区域
  String? locale = 'en_US';
  /// 货币代码
  String? name;
  /// 货币符号
  String? symbol;
  /// 自定义货币模式
  String? customPattern;
  /// 是否传入小数位数
  bool useDecimalDigits = false;
  /// 小数位数
  double decimalDigits = 2;
  /// 正数是否显示符号
  bool explicitSign = false;

  /// 预览可调输入，默认对齐 Eg. 1
  double sampleValue = 123456789.75;

  /// 原 handleNumber 的 Eg. 1–5
  final examples = <(String, num)>[
    ('Eg. 1', 123456789.75),
    ('Eg. 2', .715),
    ('Eg. 3', 12345678975 / 100),
    ('Eg. 4', int.parse('12345678975') / 100),
    ('Eg. 5', double.parse('123456789.75')),
  ];

  bool get showPattern => formatKind == _FormatKind.custom;

  bool get showDecimalDigits =>
      formatKind == _FormatKind.decimalPatternDigits ||
      formatKind == _FormatKind.decimalPercentPattern ||
      formatKind == _FormatKind.currency ||
      formatKind == _FormatKind.simpleCurrency ||
      formatKind == _FormatKind.compactCurrency ||
      formatKind == _FormatKind.compactSimpleCurrency;

  bool get showName =>
      formatKind == _FormatKind.currency ||
      formatKind == _FormatKind.simpleCurrency ||
      formatKind == _FormatKind.compactCurrency ||
      formatKind == _FormatKind.compactSimpleCurrency;

  bool get showSymbol => formatKind == _FormatKind.currency || formatKind == _FormatKind.compactCurrency;

  bool get showCustomPattern => formatKind == _FormatKind.currency;

  bool get showExplicitSign => formatKind == _FormatKind.compact || formatKind == _FormatKind.compactLong;

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
          final previewHeight = (constraints.maxHeight * 0.42).clamp(280.0, 400.0);
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
                            NLangEnum.en: 'intl NumberFormat',
                            NLangEnum.zh: 'intl NumberFormat',
                          },
                          items: [
                            {
                              NLangEnum.en:
                                  'The original demo used NumberFormat("#,##0.00", "en_US") on 123456789.75, .715, 12345678975 / 100, int.parse and double.parse.',
                              NLangEnum.zh:
                                  '原 Demo 为 NumberFormat("#,##0.00", "en_US")，示例值为 123456789.75、.715、12345678975 / 100，以及 int.parse / double.parse。',
                            },
                            {
                              NLangEnum.en:
                                  'Switch factories for decimal, percent, scientific, currency and compact. Locale null uses Intl.defaultLocale. Pattern null uses the basic format.',
                              NLangEnum.zh:
                                  '可切换 decimal、percent、scientific、currency、compact 等工厂。locale 为 null 时用 Intl.defaultLocale。pattern 为 null 时用基础格式。',
                            },
                            {
                              NLangEnum.en:
                                  'currency exposes name, symbol, decimalDigits and customPattern. compact / compactLong expose explicitSign. Deprecated currencyPattern is omitted.',
                              NLangEnum.zh:
                                  'currency 含 name、symbol、decimalDigits、customPattern。compact / compactLong 含 explicitSign。已弃用的 currencyPattern 不展示。',
                            },
                          ],
                        ),
                        buildConstructCard(),
                        buildValueCard(),
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
    final format = numberFormatOf();
    final lines = [
      ...examples.map((e) => '${e.$1}: ${format.format(e.$2)}'),
      'sample: ${format.format(sampleValue)}',
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border(
          bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.65)),
        ),
      ),
      child: SizedBox(
        height: previewHeight,
        width: double.infinity,
        child: ClipRect(
          child: ColoredBox(
            color: scheme.surface,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              children: [
                Text(
                  ctorLabelOf(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: scheme.onSurface,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 8),
                ...lines.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: SelectableText(
                      e,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface,
                        fontFamily: 'monospace',
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'factory · pattern · locale · name · symbol · decimalDigits',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'factory',
            child: buildChoiceChips(
              values: _FormatKind.values,
              isSelected: (e) => formatKind == e,
              labelOf: nameOfKind,
              onChanged: onFormatKind,
            ),
          ),
          if (showPattern)
            buildField(
              label: 'pattern',
              showTopGap: true,
              child: buildChoiceChips(
                values: const <String?>['#,##0.00', '###.0#', null],
                isSelected: (e) => pattern == e,
                labelOf: (e) => e ?? 'null',
                onChanged: onPattern,
              ),
            ),
          buildField(
            label: 'locale',
            showTopGap: true,
            child: buildChoiceChips(
              values: const <String?>['en_US', 'zh_CN', null],
              isSelected: (e) => locale == e,
              labelOf: (e) => e ?? 'null',
              onChanged: onLocale,
            ),
          ),
          if (showName)
            buildField(
              label: 'name',
              showTopGap: true,
              child: buildChoiceChips(
                values: const <String?>['USD', 'CNY', 'EUR', 'JPY', null],
                isSelected: (e) => name == e,
                labelOf: (e) => e ?? 'null',
                onChanged: onName,
              ),
            ),
          if (showSymbol)
            buildField(
              label: 'symbol',
              showTopGap: true,
              child: buildChoiceChips(
                values: const <String?>[r'$', '€', '¥', null],
                isSelected: (e) => symbol == e,
                labelOf: (e) => e ?? 'null',
                onChanged: onSymbol,
              ),
            ),
          if (showCustomPattern)
            buildField(
              label: 'customPattern',
              showTopGap: true,
              child: buildChoiceChips(
                values: const <String?>['¤#,##0.00', '¤#,##0', null],
                isSelected: (e) => customPattern == e,
                labelOf: (e) => e ?? 'null',
                onChanged: onCustomPattern,
              ),
            ),
          if (showDecimalDigits)
            buildSwitch(
              title: 'decimalDigits',
              value: useDecimalDigits,
              onChanged: onUseDecimalDigits,
            ),
          if (showDecimalDigits && useDecimalDigits)
            buildSlider(
              label: 'decimalDigits',
              value: decimalDigits,
              min: 0,
              max: 8,
              onChanged: onDecimalDigits,
            ),
          if (showExplicitSign)
            buildSwitch(
              title: 'explicitSign',
              value: explicitSign,
              onChanged: onExplicitSign,
            ),
        ],
      ),
    );
  }

  Widget buildValueCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_rounded),
      title: '输入',
      subtitle: 'NumberFormat.format',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSlider(
            label: 'value',
            value: sampleValue,
            min: 0,
            max: 123456789.75,
            onChanged: onSampleValue,
            fractionDigits: 2,
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
    int? fractionDigits,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final digits = fractionDigits;
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
      inactiveColor: Colors.black12,
      trailingBuilder: digits == null
          ? null
          : (context, v) {
              return Text(
                v.toStringAsFixed(digits),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              );
            },
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

  String nameOfKind(_FormatKind kind) {
    switch (kind) {
      case _FormatKind.custom:
        return 'NumberFormat';
      case _FormatKind.decimalPattern:
        return 'decimalPattern';
      case _FormatKind.decimalPatternDigits:
        return 'decimalPatternDigits';
      case _FormatKind.percentPattern:
        return 'percentPattern';
      case _FormatKind.decimalPercentPattern:
        return 'decimalPercentPattern';
      case _FormatKind.scientificPattern:
        return 'scientificPattern';
      case _FormatKind.currency:
        return 'currency';
      case _FormatKind.simpleCurrency:
        return 'simpleCurrency';
      case _FormatKind.compact:
        return 'compact';
      case _FormatKind.compactLong:
        return 'compactLong';
      case _FormatKind.compactCurrency:
        return 'compactCurrency';
      case _FormatKind.compactSimpleCurrency:
        return 'compactSimpleCurrency';
    }
  }

  String quoteOf(String? value) {
    return value == null ? 'null' : '"$value"';
  }

  String ctorLabelOf() {
    final loc = quoteOf(locale);
    final pat = quoteOf(pattern);
    final digits = useDecimalDigits ? '${decimalDigits.round()}' : 'null';
    final named = quoteOf(name);
    final sym = quoteOf(symbol);
    final custom = quoteOf(customPattern);
    switch (formatKind) {
      case _FormatKind.custom:
        return 'NumberFormat($pat, $loc)';
      case _FormatKind.decimalPattern:
        return 'NumberFormat.decimalPattern($loc)';
      case _FormatKind.decimalPatternDigits:
        return 'NumberFormat.decimalPatternDigits(locale: $loc, decimalDigits: $digits)';
      case _FormatKind.percentPattern:
        return 'NumberFormat.percentPattern($loc)';
      case _FormatKind.decimalPercentPattern:
        return 'NumberFormat.decimalPercentPattern(locale: $loc, decimalDigits: $digits)';
      case _FormatKind.scientificPattern:
        return 'NumberFormat.scientificPattern($loc)';
      case _FormatKind.currency:
        return 'NumberFormat.currency(locale: $loc, name: $named, symbol: $sym, decimalDigits: $digits, customPattern: $custom)';
      case _FormatKind.simpleCurrency:
        return 'NumberFormat.simpleCurrency(locale: $loc, name: $named, decimalDigits: $digits)';
      case _FormatKind.compact:
        return 'NumberFormat.compact(locale: $loc, explicitSign: $explicitSign)';
      case _FormatKind.compactLong:
        return 'NumberFormat.compactLong(locale: $loc, explicitSign: $explicitSign)';
      case _FormatKind.compactCurrency:
        return 'NumberFormat.compactCurrency(locale: $loc, name: $named, symbol: $sym, decimalDigits: $digits)';
      case _FormatKind.compactSimpleCurrency:
        return 'NumberFormat.compactSimpleCurrency(locale: $loc, name: $named, decimalDigits: $digits)';
    }
  }

  int? decimalDigitsOf() {
    return useDecimalDigits ? decimalDigits.round() : null;
  }

  NumberFormat numberFormatOf() {
    switch (formatKind) {
      case _FormatKind.custom:
        return NumberFormat(pattern, locale);
      case _FormatKind.decimalPattern:
        return NumberFormat.decimalPattern(locale);
      case _FormatKind.decimalPatternDigits:
        return NumberFormat.decimalPatternDigits(locale: locale, decimalDigits: decimalDigitsOf());
      case _FormatKind.percentPattern:
        return NumberFormat.percentPattern(locale);
      case _FormatKind.decimalPercentPattern:
        return NumberFormat.decimalPercentPattern(locale: locale, decimalDigits: decimalDigitsOf());
      case _FormatKind.scientificPattern:
        return NumberFormat.scientificPattern(locale);
      case _FormatKind.currency:
        return NumberFormat.currency(
          locale: locale,
          name: name,
          symbol: symbol,
          decimalDigits: decimalDigitsOf(),
          customPattern: customPattern,
        );
      case _FormatKind.simpleCurrency:
        return NumberFormat.simpleCurrency(locale: locale, name: name, decimalDigits: decimalDigitsOf());
      case _FormatKind.compact:
        return NumberFormat.compact(locale: locale, explicitSign: explicitSign);
      case _FormatKind.compactLong:
        return NumberFormat.compactLong(locale: locale, explicitSign: explicitSign);
      case _FormatKind.compactCurrency:
        return NumberFormat.compactCurrency(
          locale: locale,
          name: name,
          symbol: symbol,
          decimalDigits: decimalDigitsOf(),
        );
      case _FormatKind.compactSimpleCurrency:
        return NumberFormat.compactSimpleCurrency(locale: locale, name: name, decimalDigits: decimalDigitsOf());
    }
  }

  void onFormatKind(_FormatKind value) {
    formatKind = value;
    setState(() {});
  }

  void onPattern(String? value) {
    pattern = value;
    setState(() {});
  }

  void onLocale(String? value) {
    locale = value;
    setState(() {});
  }

  void onName(String? value) {
    name = value;
    setState(() {});
  }

  void onSymbol(String? value) {
    symbol = value;
    setState(() {});
  }

  void onCustomPattern(String? value) {
    customPattern = value;
    setState(() {});
  }

  void onUseDecimalDigits(bool value) {
    useDecimalDigits = value;
    setState(() {});
  }

  void onDecimalDigits(double value) {
    decimalDigits = value;
    setState(() {});
  }

  void onExplicitSign(bool value) {
    explicitSign = value;
    setState(() {});
  }

  void onSampleValue(double value) {
    sampleValue = value;
    setState(() {});
  }

  void onReset() {
    formatKind = _FormatKind.custom;
    pattern = '#,##0.00';
    locale = 'en_US';
    name = null;
    symbol = null;
    customPattern = null;
    useDecimalDigits = false;
    decimalDigits = 2;
    explicitSign = false;
    sampleValue = 123456789.75;
    setState(() {});
  }
}
