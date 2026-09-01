//
//  TimelineStep.dart
//  flutter_templet_project
//
//  Created by shang on 12/13/21 5:14 PM.
//  Copyright © 12/13/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/vendor/timeline/timeline.dart';
import 'package:get/get.dart';

class TimelineStep extends StatefulWidget {
  const TimelineStep({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TimelineStepState createState() => _TimelineStepState();
}

class _TimelineStepState extends State<TimelineStep> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();
  final previewController = ScrollController();

  /// 原 TimelineDemo 的 listData
  List listData = [
    {
      'day': '07-08',
      'time': '13:20',
      'remark': "备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑",
      'description': '',
      'subtitle': '何神(主播)',
      'title': "新建工单"
    },
    {
      'id': "2",
      'day': '07-08',
      'time': '13:20',
      'description': "备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑",
      'subtitle': '吴飞飞(销售专员)',
      'title': "联系客户"
    },
    {
      'id': "3",
      'day': '07-08',
      'time': '13:20',
      'description': "备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑，辛苦再撮合",
      // 'subtitle': '何神(主播)',
      'title': "新建工单"
    },
    {
      'id': "4",
      'day': '07-08',
      'time': '13:20',
      'description': "备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑，辛苦再撮合",
      'subtitle': '何神(主播)',
      'title': "新建工单"
    },
    {'id': "5", 'day': '07-08', 'time': '13:20', 'description': "备注：降价1000客户可考虑", 'subtitle': '何神(主播)', 'title': "新建工单"}
  ];

  /// 时间轴颜色，null 使用 ColorScheme.outlineVariant
  Color? lineColor;

  /// 是否指定 height，默认走组件内部计算
  bool useHeight = false;
  double height = 80;
  Color? backgroundColor;
  bool useTitleStyle = false;
  double titleFontSize = 14;
  bool useSubtitleStyle = false;
  double subtitleFontSize = 12;
  bool useDescriptionStyle = false;
  double descriptionFontSize = 12;

  /// TimelineDemo 为 true
  bool leftContent = true;
  String lastEvent = '—';

  @override
  void dispose() {
    previewController.dispose();
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
          final previewHeight = (constraints.maxHeight * 0.42).clamp(240.0, 400.0);
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
                            NLangEnum.en: 'Widget TimelineComponent',
                            NLangEnum.zh: '组件 TimelineComponent',
                          },
                          items: [
                            {
                              NLangEnum.en:
                                  'Preview uses TimelineDemo listData. lineColor defaults to ColorScheme.outlineVariant and leftContent is true.',
                              NLangEnum.zh: '预览使用 TimelineDemo 的 listData。lineColor 默认 ColorScheme.outlineVariant，leftContent 默认 true。',
                            },
                            {
                              NLangEnum.en:
                                  'height is optional; when off the item height is computed from description/remark. Styles are null unless enabled.',
                              NLangEnum.zh: 'height 可选；关闭时由描述/备注计算行高。titleStyle / subtitleStyle / descriptionStyle 未开启时为 null。',
                            },
                            {
                              NLangEnum.en:
                                  'leftContent off passes null because the widget checks leftContent != null to show the time column.',
                              NLangEnum.zh: '关闭 leftContent 时传 null，组件用 leftContent != null 决定是否展示左侧时间。',
                            },
                          ],
                        ),
                        buildConstructCard(),
                        buildSurfaceCard(),
                        buildStyleCard(),
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
              child: Scrollbar(
                  controller: previewController,
                  child: SingleChildScrollView(
                    controller: previewController,
                    child: TimelineComponent(
                      timelineList: listData,
                      lineColor: lineColor,
                      height: useHeight ? height : null,
                      backgroundColor: backgroundColor,
                      titleStyle: useTitleStyle ? TextStyle(fontSize: titleFontSize) : null,
                      subtitleStyle: useSubtitleStyle ? TextStyle(fontSize: subtitleFontSize) : null,
                      descriptionStyle: useDescriptionStyle ? TextStyle(fontSize: descriptionFontSize) : null,
                      leftContent: leftContent ? true : null,
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

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'timelineList · leftContent · height',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(
            title: 'leftContent',
            value: leftContent,
            onChanged: onLeftContent,
          ),
          buildSwitch(
            title: 'height 指定高度',
            value: useHeight,
            onChanged: onUseHeight,
          ),
          if (useHeight)
            buildSlider(
              label: 'height',
              value: height,
              min: 40,
              max: 160,
              onChanged: onHeight,
            ),
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.layers_rounded),
      title: '表面',
      subtitle: 'lineColor · backgroundColor',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'lineColor',
            child: buildColorDots(value: lineColor, onChanged: onLineColor),
          ),
          buildField(
            label: 'backgroundColor',
            showTopGap: true,
            child: buildColorDots(value: backgroundColor, onChanged: onBackgroundColor),
          ),
        ],
      ),
    );
  }

  Widget buildStyleCard() {
    return NDecorationCard(
      icon: const Icon(Icons.text_fields_rounded),
      title: '样式',
      subtitle: 'titleStyle · subtitleStyle · descriptionStyle',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(
            title: 'titleStyle',
            value: useTitleStyle,
            onChanged: onUseTitleStyle,
          ),
          if (useTitleStyle)
            buildSlider(
              label: 'titleStyle.fontSize',
              value: titleFontSize,
              min: 10,
              max: 24,
              onChanged: onTitleFontSize,
            ),
          buildSwitch(
            title: 'subtitleStyle',
            value: useSubtitleStyle,
            onChanged: onUseSubtitleStyle,
          ),
          if (useSubtitleStyle)
            buildSlider(
              label: 'subtitleStyle.fontSize',
              value: subtitleFontSize,
              min: 10,
              max: 24,
              onChanged: onSubtitleFontSize,
            ),
          buildSwitch(
            title: 'descriptionStyle',
            value: useDescriptionStyle,
            onChanged: onUseDescriptionStyle,
          ),
          if (useDescriptionStyle)
            buildSlider(
              label: 'descriptionStyle.fontSize',
              value: descriptionFontSize,
              min: 10,
              max: 24,
              onChanged: onDescriptionFontSize,
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
    return NSliderListItem(
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

  void onLeftContent(bool value) {
    leftContent = value;
    lastEvent = 'leftContent=$value';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onUseHeight(bool value) {
    useHeight = value;
    lastEvent = 'height=${value ? height : null}';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onHeight(double value) {
    height = value;
    lastEvent = 'height=${value.round()}';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onLineColor(Color? value) {
    lineColor = value;
    lastEvent = 'lineColor=$value';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onBackgroundColor(Color? value) {
    backgroundColor = value;
    lastEvent = 'backgroundColor=$value';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onUseTitleStyle(bool value) {
    useTitleStyle = value;
    lastEvent = 'titleStyle=${value ? titleFontSize : null}';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onTitleFontSize(double value) {
    titleFontSize = value;
    lastEvent = 'titleStyle.fontSize=${value.round()}';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onUseSubtitleStyle(bool value) {
    useSubtitleStyle = value;
    lastEvent = 'subtitleStyle=${value ? subtitleFontSize : null}';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onSubtitleFontSize(double value) {
    subtitleFontSize = value;
    lastEvent = 'subtitleStyle.fontSize=${value.round()}';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onUseDescriptionStyle(bool value) {
    useDescriptionStyle = value;
    lastEvent = 'descriptionStyle=${value ? descriptionFontSize : null}';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onDescriptionFontSize(double value) {
    descriptionFontSize = value;
    lastEvent = 'descriptionStyle.fontSize=${value.round()}';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onReset() {
    lineColor = null;
    useHeight = false;
    height = 80;
    backgroundColor = null;
    useTitleStyle = false;
    titleFontSize = 14;
    useSubtitleStyle = false;
    subtitleFontSize = 12;
    useDescriptionStyle = false;
    descriptionFontSize = 12;
    leftContent = true;
    lastEvent = '—';
    DLog.d('reset');
    setState(() {});
  }
}
