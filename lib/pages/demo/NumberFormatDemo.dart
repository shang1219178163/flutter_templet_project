//
//  NumberFormatDemo.dart
//  flutter_templet_project
//
//  Created by shang on 8/3/21 2:35 PM.
//  Copyright © 8/3/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// NumberFormat 工厂，对应 intl 非弃用构造
enum _FormatKind {
  custom(label: 'NumberFormat'),
  decimalPattern(label: 'decimalPattern'),
  decimalPatternDigits(label: 'decimalPatternDigits'),
  percentPattern(label: 'percentPattern'),
  decimalPercentPattern(label: 'decimalPercentPattern'),
  scientificPattern(label: 'scientificPattern'),
  currency(label: 'currency'),
  simpleCurrency(label: 'simpleCurrency'),
  compact(label: 'compact'),
  compactLong(label: 'compactLong'),
  compactCurrency(label: 'compactCurrency'),
  compactSimpleCurrency(label: 'compactSimpleCurrency');
  const _FormatKind({required this.label});
  final String label;
  NumberFormat numberFormatOf({
    required String? pattern,
    required String? locale,
    required int? decimalDigits,
    required String? name,
    required String? symbol,
    required String? customPattern,
    required bool explicitSign,
  }) {
    switch (this) {
      case _FormatKind.custom:
        return NumberFormat(pattern, locale);
      case _FormatKind.decimalPattern:
        return NumberFormat.decimalPattern(locale);
      case _FormatKind.decimalPatternDigits:
        return NumberFormat.decimalPatternDigits(locale: locale, decimalDigits: decimalDigits);
      case _FormatKind.percentPattern:
        return NumberFormat.percentPattern(locale);
      case _FormatKind.decimalPercentPattern:
        return NumberFormat.decimalPercentPattern(locale: locale, decimalDigits: decimalDigits);
      case _FormatKind.scientificPattern:
        return NumberFormat.scientificPattern(locale);
      case _FormatKind.currency:
        return NumberFormat.currency(
          locale: locale,
          name: name,
          symbol: symbol,
          decimalDigits: decimalDigits,
          customPattern: customPattern,
        );
      case _FormatKind.simpleCurrency:
        return NumberFormat.simpleCurrency(locale: locale, name: name, decimalDigits: decimalDigits);
      case _FormatKind.compact:
        return NumberFormat.compact(locale: locale, explicitSign: explicitSign);
      case _FormatKind.compactLong:
        return NumberFormat.compactLong(locale: locale, explicitSign: explicitSign);
      case _FormatKind.compactCurrency:
        return NumberFormat.compactCurrency(
          locale: locale,
          name: name,
          symbol: symbol,
          decimalDigits: decimalDigits,
        );
      case _FormatKind.compactSimpleCurrency:
        return NumberFormat.compactSimpleCurrency(locale: locale, name: name, decimalDigits: decimalDigits);
    }
  }
  String ctorLabelOf({
    required String pat,
    required String loc,
    required String digits,
    required String named,
    required String sym,
    required String custom,
    required bool explicitSign,
  }) {
    switch (this) {
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
}

class NumberFormatDemo extends StatefulWidget {
  const NumberFormatDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<NumberFormatDemo> createState() => _NumberFormatDemoState();
}

class _NumberFormatDemoState extends State<NumberFormatDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

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
  /// 最近事件
  String lastEvent = '—';

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
                                  'Switch factories for decimal, percent, scientific, currency and compact. Locale/pattern null use Intl.defaultLocale / basic format. currency exposes name, symbol, decimalDigits, customPattern; compact / compactLong expose explicitSign. Deprecated currencyPattern is omitted.',
                              NLangEnum.zh:
                                  '可切换 decimal、percent、scientific、currency、compact 等工厂。locale/pattern 为 null 时用 Intl.defaultLocale / 基础格式。currency 含 name、symbol、decimalDigits、customPattern；compact / compactLong 含 explicitSign。已弃用的 currencyPattern 不展示。',
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
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'lastEvent: $lastEvent',
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
          NChoiceChipListItem<_FormatKind>(
            title: const Text('factory'),
            values: _FormatKind.values,
            value: formatKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('factory ${e.label}', () => formatKind = e),
          ),
          if (showPattern) ...[
            const SizedBox(height: 8),
            NChoiceChipListItem<String?>(
              title: const Text('pattern'),
              values: const <String?>['#,##0.00', '###.0#', null],
              value: pattern,
              labelOf: (e) => e ?? 'null',
              onChanged: (e) => onMark('pattern ${e ?? 'null'}', () => pattern = e),
            ),
          ],
          const SizedBox(height: 8),
          NChoiceChipListItem<String?>(
            title: const Text('locale'),
            values: const <String?>['en_US', 'zh_CN', null],
            value: locale,
            labelOf: (e) => e ?? 'null',
            onChanged: (e) => onMark('locale ${e ?? 'null'}', () => locale = e),
          ),
          if (showName) ...[
            const SizedBox(height: 8),
            NChoiceChipListItem<String?>(
              title: const Text('name'),
              values: const <String?>['USD', 'CNY', 'EUR', 'JPY', null],
              value: name,
              labelOf: (e) => e ?? 'null',
              onChanged: (e) => onMark('name ${e ?? 'null'}', () => name = e),
            ),
          ],
          if (showSymbol) ...[
            const SizedBox(height: 8),
            NChoiceChipListItem<String?>(
              title: const Text('symbol'),
              values: const <String?>[r'$', '€', '¥', null],
              value: symbol,
              labelOf: (e) => e ?? 'null',
              onChanged: (e) => onMark('symbol ${e ?? 'null'}', () => symbol = e),
            ),
          ],
          if (showCustomPattern) ...[
            const SizedBox(height: 8),
            NChoiceChipListItem<String?>(
              title: const Text('customPattern'),
              values: const <String?>['¤#,##0.00', '¤#,##0', null],
              value: customPattern,
              labelOf: (e) => e ?? 'null',
              onChanged: (e) => onMark('customPattern ${e ?? 'null'}', () => customPattern = e),
            ),
          ],
          if (showDecimalDigits)
            NSwitchListItem(
              title: const Text('decimalDigits'),
              value: useDecimalDigits,
              onChanged: (v) => onMark('decimalDigits ${v ? 'on' : 'null'}', () => useDecimalDigits = v),
            ),
          if (showDecimalDigits && useDecimalDigits)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('decimalDigits'),
              min: 0,
              max: 8,
              value: decimalDigits.clamp(0, 8),
              onChanged: (v) => onMark('decimalDigits ${v.round()}', () => decimalDigits = v),
              activeColor: theme.colorScheme.primary,
            ),
          if (showExplicitSign)
            NSwitchListItem(
              title: const Text('explicitSign'),
              value: explicitSign,
              onChanged: (v) => onMark('explicitSign $v', () => explicitSign = v),
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
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('value'),
            min: 0,
            max: 123456789.75,
            value: sampleValue.clamp(0, 123456789.75),
            onChanged: (v) => onMark('value ${v.toStringAsFixed(2)}', () => sampleValue = v),
            activeColor: theme.colorScheme.primary,
            valueBuilder: (context, v) {
              return Text(
                v.toStringAsFixed(2),
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


  String ctorLabelOf() {
    final pat = pattern == null ? 'null' : '"$pattern"';
    final loc = locale == null ? 'null' : '"$locale"';
    final named = name == null ? 'null' : '"$name"';
    final sym = symbol == null ? 'null' : '"$symbol"';
    final custom = customPattern == null ? 'null' : '"$customPattern"';
    return formatKind.ctorLabelOf(
      pat: pat,
      loc: loc,
      digits: useDecimalDigits ? '${decimalDigits.round()}' : 'null',
      named: named,
      sym: sym,
      custom: custom,
      explicitSign: explicitSign,
    );
  }

  int? decimalDigitsOf() {
    return useDecimalDigits ? decimalDigits.round() : null;
  }

  NumberFormat numberFormatOf() {
    return formatKind.numberFormatOf(
      pattern: pattern,
      locale: locale,
      decimalDigits: decimalDigitsOf(),
      name: name,
      symbol: symbol,
      customPattern: customPattern,
      explicitSign: explicitSign,
    );
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
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
    lastEvent = '—';
    setState(() {});
  }
}
