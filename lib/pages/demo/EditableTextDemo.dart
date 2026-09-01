import 'dart:ui' show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

/// 键盘类型，auto 表示交给构造函数推断
enum _KeyboardKind {
  auto,
  text,
  multiline,
  number,
  phone,
  datetime,
  emailAddress,
  url,
  visiblePassword,
  name,
  none,
}

/// 键盘动作，nil 表示 null
enum _ActionKind { nil, none, unspecified, done, go, search, send, next, previous, newline }

/// 文本方向
enum _DirKind { nil, ltr, rtl }

/// 滚动物理
enum _PhysicsKind { platform, bouncing, clamping, never }

/// 指针样式
enum _MouseKind { nil, text, basic, click, forbidden, grab }

/// 文本缩放
enum _ScalerKind { nil, noScaling, linear }

/// strut 预设
enum _StrutKind { nil, disabled, force }

/// 输入格式化
enum _FormatterKind { nil, digits, length }

/// 自动填充
enum _AutofillKind { empty, email, username, password, telephone }

/// 语言
enum _LocaleKind { nil, en, zh }

class EditableTextDemo extends StatefulWidget {
  EditableTextDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<EditableTextDemo> createState() => _EditableTextDemoState();
}

class _EditableTextDemoState extends State<EditableTextDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

  /// 预览区初始文本
  static const _sampleText = 'Hello EditableText';

  final scrollController = ScrollController();
  final textController = TextEditingController(text: _sampleText);
  final focusNode = FocusNode();
  final fieldScrollController = ScrollController();
  final undoController = UndoHistoryController();

  /// 是否只读
  bool readOnly = false;
  /// 是否密文
  bool obscureText = false;
  /// 密文字符
  String obscuringCharacter = '•';
  /// 是否自动纠正
  bool autocorrect = true;
  /// 智能破折号
  SmartDashesType smartDashesType = SmartDashesType.enabled;
  /// 智能引号
  SmartQuotesType smartQuotesType = SmartQuotesType.enabled;
  /// 是否显示输入建议
  bool enableSuggestions = true;
  /// 字号
  double fontSize = 16;
  /// 文字颜色
  Color? styleColor;
  /// 字重
  FontWeight fontWeight = FontWeight.w400;
  /// 光标颜色
  Color cursorColor = Colors.blue;
  /// 背景光标颜色
  Color backgroundCursorColor = Colors.grey;
  /// 文字对齐
  TextAlign textAlign = TextAlign.start;
  /// 文字方向
  _DirKind dirKind = _DirKind.nil;
  /// 语言
  _LocaleKind localeKind = _LocaleKind.nil;
  /// 文字缩放
  _ScalerKind scalerKind = _ScalerKind.nil;
  /// 线性缩放系数
  double scalerFactor = 1.5;
  /// 最大行数
  double maxLines = 1;
  /// 最小行数，0 表示 null
  double minLines = 0;
  /// 是否撑满父布局
  bool expands = false;
  /// 是否强制换行
  bool forceLine = true;
  /// 是否传入 textHeightBehavior
  bool useTextHeightBehavior = false;
  /// 首行 ascent 是否应用行高
  bool applyHeightToFirstAscent = true;
  /// 末行 descent 是否应用行高
  bool applyHeightToLastDescent = true;
  /// 宽度计算基准
  TextWidthBasis textWidthBasis = TextWidthBasis.parent;
  /// 是否自动聚焦
  bool autofocus = false;
  /// 是否显示光标
  bool? showCursor;
  /// 是否显示选区手柄
  bool showSelectionHandles = false;
  /// 选区颜色
  Color? selectionColor;
  /// 键盘类型
  _KeyboardKind keyboardKind = _KeyboardKind.auto;
  /// 键盘动作
  _ActionKind actionKind = _ActionKind.nil;
  /// 大小写
  TextCapitalization textCapitalization = TextCapitalization.none;
  /// 输入格式化
  _FormatterKind formatterKind = _FormatterKind.nil;
  /// 指针样式
  _MouseKind mouseKind = _MouseKind.nil;
  /// 渲染层是否忽略指针
  bool rendererIgnoresPointer = false;
  /// 光标宽度
  double cursorWidth = 2;
  /// 光标高度，0 表示 null
  double cursorHeight = 0;
  /// 光标圆角，0 表示 null
  double cursorRadius = 0;
  /// 光标透明度动画
  bool cursorOpacityAnimates = false;
  /// 是否传入 cursorOffset
  bool useCursorOffset = false;
  /// 光标水平偏移
  double cursorOffsetDx = 0;
  /// 光标垂直偏移
  double cursorOffsetDy = 0;
  /// 光标画在文字上方
  bool paintCursorAboveText = false;
  /// 选区高度样式
  BoxHeightStyle selectionHeightStyle = BoxHeightStyle.tight;
  /// 选区宽度样式
  BoxWidthStyle selectionWidthStyle = BoxWidthStyle.tight;
  /// 滚动内边距
  double scrollPadding = 20;
  /// 键盘外观
  Brightness keyboardAppearance = Brightness.light;
  /// 拖动手势起点
  DragStartBehavior dragStartBehavior = DragStartBehavior.start;
  /// 是否可交互
  bool? enableInteractiveSelection;
  /// 是否传入 scrollController
  bool useScrollController = false;
  /// 滚动物理
  _PhysicsKind physicsKind = _PhysicsKind.platform;
  /// 自动纠正矩形颜色
  Color? autocorrectionTextRectColor;
  /// 自动填充
  _AutofillKind autofillKind = _AutofillKind.empty;
  /// 裁剪
  Clip clipBehavior = Clip.hardEdge;
  /// 是否传入 restorationId
  bool useRestorationId = false;
  /// 是否传入 scrollBehavior
  bool useScrollBehavior = false;
  /// 是否启用 Scribble
  bool scribbleEnabled = true;
  /// 是否允许 IME 个性化学习
  bool enableIMEPersonalizedLearning = true;
  /// 是否自定义上下文菜单
  bool useContextMenu = false;
  /// 是否自定义放大镜
  bool useMagnifier = false;
  /// 是否传入 undoController
  bool useUndoController = false;
  /// strut 预设
  _StrutKind strutKind = _StrutKind.nil;
  /// 是否自定义 groupId
  bool useCustomGroupId = false;
  /// 最近事件
  String lastEvent = '—';

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    scrollController.dispose();
    fieldScrollController.dispose();
    undoController.dispose();
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
                        NLangEnum.en: 'Widget EditableText',
                        NLangEnum.zh: '组件 EditableText',
                      },
                      items: [
                        {
                          NLangEnum.en:
                              'EditableText is the low-level editor behind TextField. The bordered box is a live preview.',
                          NLangEnum.zh: 'EditableText 是 TextField 底层的可编辑文本。上方边框内是实时预览。',
                        },
                        {
                          NLangEnum.en:
                              'obscureText forces maxLines=1. expands requires maxLines and minLines to be null.',
                          NLangEnum.zh: 'obscureText 为 true 时强制 maxLines=1；expands 为 true 时 maxLines/minLines 必须为 null。',
                        },
                      ],
                    ),
                    buildInputCard(),
                    buildLookCard(),
                    buildLayoutCard(),
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
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final lines = maxLinesOf();
    final fieldHeight = expands ? 180.0 : (lines == null || lines > 1 ? 140.0 : 52.0);
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
          children: [
            if (arguments != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '$arguments',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
            SizedBox(
              height: fieldHeight,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.65)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: SizedBox.expand(child: buildEditableText()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Text(
                lastEvent,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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

  Widget buildEditableText() {
    return EditableText(
      key: ValueKey('$obscureText$expands$keyboardKind$useScrollController'),
      controller: textController,
      focusNode: focusNode,
      readOnly: readOnly,
      obscuringCharacter: obscuringCharacter,
      obscureText: obscureText,
      autocorrect: autocorrect,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      style: styleOf(),
      strutStyle: strutStyleOf(),
      cursorColor: cursorColor,
      backgroundCursorColor: backgroundCursorColor,
      textAlign: textAlign,
      textDirection: textDirectionOf(),
      locale: localeOf(),
      textScaler: textScalerOf(),
      maxLines: maxLinesOf(),
      minLines: minLinesOf(),
      expands: expands,
      forceLine: forceLine,
      textHeightBehavior: textHeightBehaviorOf(),
      textWidthBasis: textWidthBasis,
      autofocus: autofocus,
      showCursor: showCursor,
      showSelectionHandles: showSelectionHandles,
      selectionColor: selectionColor,
      keyboardType: keyboardTypeOf(),
      textInputAction: textInputActionOf(),
      textCapitalization: textCapitalization,
      onChanged: (v) => onMark('onChanged $v'),
      onEditingComplete: () => onMark('onEditingComplete'),
      onSubmitted: (v) => onMark('onSubmitted $v'),
      onAppPrivateCommand: (action, data) => onMark('onAppPrivateCommand $action'),
      onSelectionChanged: (selection, cause) =>
          onMark('onSelectionChanged ${cause?.name} ${selection.baseOffset}-${selection.extentOffset}'),
      onSelectionHandleTapped: () => onMark('onSelectionHandleTapped'),
      groupId: useCustomGroupId ? this : EditableText,
      onTapOutside: onTapOutside,
      inputFormatters: inputFormattersOf(),
      mouseCursor: mouseCursorOf(),
      rendererIgnoresPointer: rendererIgnoresPointer,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight > 0 ? cursorHeight : null,
      cursorRadius: cursorRadius > 0 ? Radius.circular(cursorRadius) : null,
      cursorOpacityAnimates: cursorOpacityAnimates,
      cursorOffset: useCursorOffset ? Offset(cursorOffsetDx, cursorOffsetDy) : null,
      paintCursorAboveText: paintCursorAboveText,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      scrollPadding: EdgeInsets.all(scrollPadding),
      keyboardAppearance: keyboardAppearance,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      scrollController: useScrollController ? fieldScrollController : null,
      scrollPhysics: scrollPhysicsOf(),
      autocorrectionTextRectColor: autocorrectionTextRectColor,
      autofillHints: autofillHintsOf(),
      clipBehavior: clipBehavior,
      restorationId: useRestorationId ? 'editableTextDemo' : null,
      scrollBehavior: useScrollBehavior ? const MaterialScrollBehavior() : null,
      scribbleEnabled: scribbleEnabled,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      contextMenuBuilder: useContextMenu ? buildContextMenu : null,
      magnifierConfiguration: useMagnifier ? const TextMagnifierConfiguration() : TextMagnifierConfiguration.disabled,
      undoController: useUndoController ? undoController : null,
    );
  }

  Widget buildInputCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '输入',
      subtitle: 'readOnly · obscureText · keyboardType · inputFormatters',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(
            title: 'readOnly',
            value: readOnly,
            onChanged: (v) => onMark('readOnly $v', () => readOnly = v),
          ),
          buildSwitch(title: 'obscureText', value: obscureText, onChanged: onObscureText),
          if (obscureText)
            buildField(
              label: 'obscuringCharacter',
              showTopGap: true,
              child: buildChoiceChips(
                values: const ['•', '*', '●'],
                isSelected: (e) => obscuringCharacter == e,
                labelOf: (e) => e,
                onChanged: (v) => onMark('obscuringCharacter $v', () => obscuringCharacter = v),
              ),
            ),
          buildSwitch(
            title: 'autocorrect',
            value: autocorrect,
            onChanged: (v) => onMark('autocorrect $v', () => autocorrect = v),
          ),
          buildSwitch(
            title: 'enableSuggestions',
            value: enableSuggestions,
            onChanged: (v) => onMark('enableSuggestions $v', () => enableSuggestions = v),
          ),
          buildField(
            label: 'smartDashesType',
            showTopGap: true,
            child: buildChoiceChips(
              values: SmartDashesType.values,
              isSelected: (e) => smartDashesType == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('smartDashesType ${e.name}', () => smartDashesType = e),
            ),
          ),
          buildField(
            label: 'smartQuotesType',
            showTopGap: true,
            child: buildChoiceChips(
              values: SmartQuotesType.values,
              isSelected: (e) => smartQuotesType == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('smartQuotesType ${e.name}', () => smartQuotesType = e),
            ),
          ),
          buildField(
            label: 'keyboardType',
            showTopGap: true,
            child: buildChoiceChips(
              values: _KeyboardKind.values,
              isSelected: (e) => keyboardKind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('keyboardType ${e.name}', () => keyboardKind = e),
            ),
          ),
          buildField(
            label: 'textInputAction',
            showTopGap: true,
            child: buildChoiceChips(
              values: _ActionKind.values,
              isSelected: (e) => actionKind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('textInputAction ${e.name}', () => actionKind = e),
            ),
          ),
          buildField(
            label: 'textCapitalization',
            showTopGap: true,
            child: buildChoiceChips(
              values: TextCapitalization.values,
              isSelected: (e) => textCapitalization == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('textCapitalization ${e.name}', () => textCapitalization = e),
            ),
          ),
          buildField(
            label: 'autofillHints',
            showTopGap: true,
            child: buildChoiceChips(
              values: _AutofillKind.values,
              isSelected: (e) => autofillKind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('autofillHints ${e.name}', () => autofillKind = e),
            ),
          ),
          buildField(
            label: 'inputFormatters',
            showTopGap: true,
            child: buildChoiceChips(
              values: _FormatterKind.values,
              isSelected: (e) => formatterKind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('inputFormatters ${e.name}', () => formatterKind = e),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLookCard() {
    return NDecorationCard(
      icon: const Icon(Icons.text_fields_rounded),
      title: '外观',
      subtitle: 'style · textAlign · cursorColor · selectionColor',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSlider(
            label: 'style.fontSize',
            value: fontSize,
            min: 10,
            max: 32,
            onChanged: (v) => onMark('style.fontSize ${v.round()}', () => fontSize = v),
          ),
          buildField(
            label: 'style.color',
            showTopGap: true,
            child: buildColorDots(
              value: styleColor,
              onChanged: (v) => onMark('style.color ${v ?? 'null'}', () => styleColor = v),
            ),
          ),
          buildField(
            label: 'style.fontWeight',
            showTopGap: true,
            child: buildChoiceChips(
              values: const [FontWeight.w300, FontWeight.w400, FontWeight.w500, FontWeight.w600, FontWeight.w700],
              isSelected: (e) => fontWeight == e,
              labelOf: (e) => e.toString().split('.').last,
              onChanged: (e) => onMark('style.fontWeight ${e.toString().split('.').last}', () => fontWeight = e),
            ),
          ),
          buildField(
            label: 'textAlign',
            showTopGap: true,
            child: buildChoiceChips(
              values: TextAlign.values,
              isSelected: (e) => textAlign == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('textAlign ${e.name}', () => textAlign = e),
            ),
          ),
          buildField(
            label: 'textDirection',
            showTopGap: true,
            child: buildChoiceChips(
              values: _DirKind.values,
              isSelected: (e) => dirKind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('textDirection ${e.name}', () => dirKind = e),
            ),
          ),
          buildField(
            label: 'locale',
            showTopGap: true,
            child: buildChoiceChips(
              values: _LocaleKind.values,
              isSelected: (e) => localeKind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('locale ${e.name}', () => localeKind = e),
            ),
          ),
          buildField(
            label: 'textScaler',
            showTopGap: true,
            child: buildChoiceChips(
              values: _ScalerKind.values,
              isSelected: (e) => scalerKind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('textScaler ${e.name}', () => scalerKind = e),
            ),
          ),
          if (scalerKind == _ScalerKind.linear)
            buildSlider(
              label: 'textScaler.linear',
              value: scalerFactor,
              min: 0.5,
              max: 2.5,
              onChanged: (v) => onMark('textScaler.linear ${v.toStringAsFixed(2)}', () => scalerFactor = v),
              fractionDigits: 2,
            ),
          buildField(
            label: 'strutStyle',
            showTopGap: true,
            child: buildChoiceChips(
              values: _StrutKind.values,
              isSelected: (e) => strutKind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('strutStyle ${e.name}', () => strutKind = e),
            ),
          ),
          buildField(
            label: 'textWidthBasis',
            showTopGap: true,
            child: buildChoiceChips(
              values: TextWidthBasis.values,
              isSelected: (e) => textWidthBasis == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('textWidthBasis ${e.name}', () => textWidthBasis = e),
            ),
          ),
          buildSwitch(
            title: 'forceLine',
            value: forceLine,
            onChanged: (v) => onMark('forceLine $v', () => forceLine = v),
          ),
          buildSwitch(
            title: 'textHeightBehavior',
            value: useTextHeightBehavior,
            onChanged: (v) => onMark('textHeightBehavior $v', () => useTextHeightBehavior = v),
          ),
          if (useTextHeightBehavior) ...[
            buildSwitch(
              title: 'applyHeightToFirstAscent',
              value: applyHeightToFirstAscent,
              onChanged: (v) => onMark('applyHeightToFirstAscent $v', () => applyHeightToFirstAscent = v),
            ),
            buildSwitch(
              title: 'applyHeightToLastDescent',
              value: applyHeightToLastDescent,
              onChanged: (v) => onMark('applyHeightToLastDescent $v', () => applyHeightToLastDescent = v),
            ),
          ],
          buildField(
            label: 'cursorColor',
            showTopGap: true,
            child: buildColorDots(
              value: cursorColor,
              onChanged: (v) => onMark('cursorColor $v', () => cursorColor = v ?? Colors.blue),
              allowNull: false,
            ),
          ),
          buildField(
            label: 'backgroundCursorColor',
            showTopGap: true,
            child: buildColorDots(
              value: backgroundCursorColor,
              onChanged: (v) => onMark('backgroundCursorColor $v', () => backgroundCursorColor = v ?? Colors.grey),
              allowNull: false,
            ),
          ),
          buildField(
            label: 'selectionColor',
            showTopGap: true,
            child: buildColorDots(
              value: selectionColor,
              onChanged: (v) => onMark('selectionColor ${v ?? 'null'}', () => selectionColor = v),
            ),
          ),
          buildField(
            label: 'autocorrectionTextRectColor',
            showTopGap: true,
            child: buildColorDots(
              value: autocorrectionTextRectColor,
              onChanged: (v) => onMark('autocorrectionTextRectColor ${v ?? 'null'}', () => autocorrectionTextRectColor = v),
            ),
          ),
          buildField(
            label: 'showCursor',
            showTopGap: true,
            child: buildChoiceChips(
              values: const [null, true, false],
              isSelected: (e) => showCursor == e,
              labelOf: (e) => e == null ? '默' : '$e',
              onChanged: (e) => onMark('showCursor ${e ?? 'null'}', () => showCursor = e),
            ),
          ),
          buildSwitch(
            title: 'showSelectionHandles',
            value: showSelectionHandles,
            onChanged: (v) => onMark('showSelectionHandles $v', () => showSelectionHandles = v),
          ),
          buildField(
            label: 'enableInteractiveSelection',
            showTopGap: true,
            child: buildChoiceChips(
              values: const [null, true, false],
              isSelected: (e) => enableInteractiveSelection == e,
              labelOf: (e) => e == null ? '默' : '$e',
              onChanged: (e) => onMark('enableInteractiveSelection ${e ?? 'null'}', () => enableInteractiveSelection = e),
            ),
          ),
          buildSlider(
            label: 'cursorWidth',
            value: cursorWidth,
            min: 1,
            max: 8,
            onChanged: (v) => onMark('cursorWidth ${v.round()}', () => cursorWidth = v),
          ),
          buildSlider(
            label: 'cursorHeight',
            value: cursorHeight,
            min: 0,
            max: 48,
            onChanged: (v) => onMark('cursorHeight ${v.round()}', () => cursorHeight = v),
          ),
          buildSlider(
            label: 'cursorRadius',
            value: cursorRadius,
            min: 0,
            max: 12,
            onChanged: (v) => onMark('cursorRadius ${v.round()}', () => cursorRadius = v),
          ),
          buildSwitch(
            title: 'cursorOpacityAnimates',
            value: cursorOpacityAnimates,
            onChanged: (v) => onMark('cursorOpacityAnimates $v', () => cursorOpacityAnimates = v),
          ),
          buildSwitch(
            title: 'cursorOffset',
            value: useCursorOffset,
            onChanged: (v) => onMark('cursorOffset $v', () => useCursorOffset = v),
          ),
          if (useCursorOffset) ...[
            buildSlider(
              label: 'cursorOffset.dx',
              value: cursorOffsetDx,
              min: -8,
              max: 8,
              onChanged: (v) => onMark('cursorOffset.dx ${v.toStringAsFixed(1)}', () => cursorOffsetDx = v),
              fractionDigits: 1,
            ),
            buildSlider(
              label: 'cursorOffset.dy',
              value: cursorOffsetDy,
              min: -8,
              max: 8,
              onChanged: (v) => onMark('cursorOffset.dy ${v.toStringAsFixed(1)}', () => cursorOffsetDy = v),
              fractionDigits: 1,
            ),
          ],
          buildSwitch(
            title: 'paintCursorAboveText',
            value: paintCursorAboveText,
            onChanged: (v) => onMark('paintCursorAboveText $v', () => paintCursorAboveText = v),
          ),
          buildField(
            label: 'selectionHeightStyle',
            showTopGap: true,
            child: buildChoiceChips(
              values: BoxHeightStyle.values,
              isSelected: (e) => selectionHeightStyle == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('selectionHeightStyle ${e.name}', () => selectionHeightStyle = e),
            ),
          ),
          buildField(
            label: 'selectionWidthStyle',
            showTopGap: true,
            child: buildChoiceChips(
              values: BoxWidthStyle.values,
              isSelected: (e) => selectionWidthStyle == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('selectionWidthStyle ${e.name}', () => selectionWidthStyle = e),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLayoutCard() {
    return NDecorationCard(
      icon: const Icon(Icons.space_dashboard_rounded),
      title: '布局与行为',
      subtitle: 'maxLines · expands · autofocus · magnifier · undoController',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(title: 'expands', value: expands, onChanged: onExpands),
          if (!expands && !obscureText)
            buildSlider(label: 'maxLines', value: maxLines, min: 0, max: 8, onChanged: onMaxLines),
          if (!expands && !obscureText)
            buildSlider(label: 'minLines', value: minLines, min: 0, max: 8, onChanged: onMinLines),
          buildSlider(
            label: 'scrollPadding',
            value: scrollPadding,
            min: 0,
            max: 48,
            onChanged: (v) => onMark('scrollPadding ${v.round()}', () => scrollPadding = v),
          ),
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
          buildField(
            label: 'scrollPhysics',
            showTopGap: true,
            child: buildChoiceChips(
              values: _PhysicsKind.values,
              isSelected: (e) => physicsKind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('scrollPhysics ${e.name}', () => physicsKind = e),
            ),
          ),
          buildSwitch(
            title: 'scrollController',
            value: useScrollController,
            onChanged: (v) => onMark('scrollController $v', () => useScrollController = v),
          ),
          buildSwitch(
            title: 'scrollBehavior',
            value: useScrollBehavior,
            onChanged: (v) => onMark('scrollBehavior $v', () => useScrollBehavior = v),
          ),
          buildSwitch(
            title: 'autofocus',
            value: autofocus,
            onChanged: (v) => onMark('autofocus $v', () => autofocus = v),
          ),
          buildSwitch(
            title: 'rendererIgnoresPointer',
            value: rendererIgnoresPointer,
            onChanged: (v) => onMark('rendererIgnoresPointer $v', () => rendererIgnoresPointer = v),
          ),
          buildSwitch(
            title: 'scribbleEnabled',
            value: scribbleEnabled,
            onChanged: (v) => onMark('scribbleEnabled $v', () => scribbleEnabled = v),
          ),
          buildSwitch(
            title: 'enableIMEPersonalizedLearning',
            value: enableIMEPersonalizedLearning,
            onChanged: (v) => onMark('enableIMEPersonalizedLearning $v', () => enableIMEPersonalizedLearning = v),
          ),
          buildSwitch(
            title: 'contextMenuBuilder',
            value: useContextMenu,
            onChanged: (v) => onMark('contextMenuBuilder $v', () => useContextMenu = v),
          ),
          buildSwitch(
            title: 'magnifierConfiguration',
            value: useMagnifier,
            onChanged: (v) => onMark('magnifierConfiguration $v', () => useMagnifier = v),
          ),
          buildSwitch(
            title: 'undoController',
            value: useUndoController,
            onChanged: (v) => onMark('undoController $v', () => useUndoController = v),
          ),
          buildSwitch(
            title: 'restorationId',
            value: useRestorationId,
            onChanged: (v) => onMark('restorationId $v', () => useRestorationId = v),
          ),
          buildSwitch(
            title: 'groupId 自定义',
            value: useCustomGroupId,
            onChanged: (v) => onMark('groupId $v', () => useCustomGroupId = v),
          ),
          buildField(
            label: 'mouseCursor',
            showTopGap: true,
            child: buildChoiceChips(
              values: _MouseKind.values,
              isSelected: (e) => mouseKind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('mouseCursor ${e.name}', () => mouseKind = e),
            ),
          ),
          buildField(
            label: 'keyboardAppearance',
            showTopGap: true,
            child: buildChoiceChips(
              values: Brightness.values,
              isSelected: (e) => keyboardAppearance == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('keyboardAppearance ${e.name}', () => keyboardAppearance = e),
            ),
          ),
          buildField(
            label: 'dragStartBehavior',
            showTopGap: true,
            child: buildChoiceChips(
              values: DragStartBehavior.values,
              isSelected: (e) => dragStartBehavior == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('dragStartBehavior ${e.name}', () => dragStartBehavior = e),
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
    bool allowNull = true,
  }) {
    final scheme = theme.colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppColor.colorOptions.where((e) => allowNull || e != null).map((e) {
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
    int fractionDigits = 0,
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
      valueBuilder: fractionDigits > 0
          ? (context, v) {
              return Text(
                v.toStringAsFixed(fractionDigits),
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

  Widget buildContextMenu(context, editableTextState) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  TextStyle styleOf() {
    return (theme.textTheme.bodyLarge ?? const TextStyle()).copyWith(
      fontSize: fontSize,
      color: styleColor,
      fontWeight: fontWeight,
    );
  }

  int? maxLinesOf() {
    if (obscureText) {
      return 1;
    }
    if (expands || maxLines == 0) {
      return null;
    }
    return maxLines.round().clamp(1, 8);
  }

  int? minLinesOf() {
    if (expands || obscureText || minLines == 0) {
      return null;
    }
    final min = minLines.round().clamp(1, 8);
    final max = maxLinesOf();
    if (max != null && min > max) {
      return max;
    }
    return min;
  }

  TextDirection? textDirectionOf() {
    return switch (dirKind) {
      _DirKind.nil => null,
      _DirKind.ltr => TextDirection.ltr,
      _DirKind.rtl => TextDirection.rtl,
    };
  }

  Locale? localeOf() {
    return switch (localeKind) {
      _LocaleKind.nil => null,
      _LocaleKind.en => const Locale('en'),
      _LocaleKind.zh => const Locale('zh'),
    };
  }

  TextScaler? textScalerOf() {
    return switch (scalerKind) {
      _ScalerKind.nil => null,
      _ScalerKind.noScaling => TextScaler.noScaling,
      _ScalerKind.linear => TextScaler.linear(scalerFactor),
    };
  }

  StrutStyle? strutStyleOf() {
    return switch (strutKind) {
      _StrutKind.nil => null,
      _StrutKind.disabled => StrutStyle.disabled,
      _StrutKind.force => const StrutStyle(forceStrutHeight: true),
    };
  }

  TextHeightBehavior? textHeightBehaviorOf() {
    if (!useTextHeightBehavior) {
      return null;
    }
    return TextHeightBehavior(
      applyHeightToFirstAscent: applyHeightToFirstAscent,
      applyHeightToLastDescent: applyHeightToLastDescent,
    );
  }

  TextInputType? keyboardTypeOf() {
    return switch (keyboardKind) {
      _KeyboardKind.auto => null,
      _KeyboardKind.text => TextInputType.text,
      _KeyboardKind.multiline => TextInputType.multiline,
      _KeyboardKind.number => TextInputType.number,
      _KeyboardKind.phone => TextInputType.phone,
      _KeyboardKind.datetime => TextInputType.datetime,
      _KeyboardKind.emailAddress => TextInputType.emailAddress,
      _KeyboardKind.url => TextInputType.url,
      _KeyboardKind.visiblePassword => TextInputType.visiblePassword,
      _KeyboardKind.name => TextInputType.name,
      _KeyboardKind.none => TextInputType.none,
    };
  }

  TextInputAction? textInputActionOf() {
    return switch (actionKind) {
      _ActionKind.nil => null,
      _ActionKind.none => TextInputAction.none,
      _ActionKind.unspecified => TextInputAction.unspecified,
      _ActionKind.done => TextInputAction.done,
      _ActionKind.go => TextInputAction.go,
      _ActionKind.search => TextInputAction.search,
      _ActionKind.send => TextInputAction.send,
      _ActionKind.next => TextInputAction.next,
      _ActionKind.previous => TextInputAction.previous,
      _ActionKind.newline => TextInputAction.newline,
    };
  }

  List<TextInputFormatter>? inputFormattersOf() {
    return switch (formatterKind) {
      _FormatterKind.nil => null,
      _FormatterKind.digits => [FilteringTextInputFormatter.digitsOnly],
      _FormatterKind.length => [LengthLimitingTextInputFormatter(10)],
    };
  }

  MouseCursor? mouseCursorOf() {
    return switch (mouseKind) {
      _MouseKind.nil => null,
      _MouseKind.text => SystemMouseCursors.text,
      _MouseKind.basic => SystemMouseCursors.basic,
      _MouseKind.click => SystemMouseCursors.click,
      _MouseKind.forbidden => SystemMouseCursors.forbidden,
      _MouseKind.grab => SystemMouseCursors.grab,
    };
  }

  ScrollPhysics? scrollPhysicsOf() {
    return switch (physicsKind) {
      _PhysicsKind.platform => null,
      _PhysicsKind.bouncing => const BouncingScrollPhysics(),
      _PhysicsKind.clamping => const ClampingScrollPhysics(),
      _PhysicsKind.never => const NeverScrollableScrollPhysics(),
    };
  }

  Iterable<String> autofillHintsOf() {
    return switch (autofillKind) {
      _AutofillKind.empty => const <String>[],
      _AutofillKind.email => const [AutofillHints.email],
      _AutofillKind.username => const [AutofillHints.username],
      _AutofillKind.password => const [AutofillHints.password],
      _AutofillKind.telephone => const [AutofillHints.telephoneNumber],
    };
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onTapOutside(event) {
    onMark('onTapOutside', () => focusNode.unfocus());
  }

  void onObscureText(value) {
    onMark('obscureText $value', () {
      obscureText = value;
      if (value) {
        expands = false;
        maxLines = 1;
        minLines = 0;
        smartDashesType = SmartDashesType.disabled;
        smartQuotesType = SmartQuotesType.disabled;
      } else {
        smartDashesType = SmartDashesType.enabled;
        smartQuotesType = SmartQuotesType.enabled;
      }
    });
  }

  void onExpands(value) {
    onMark('expands $value', () {
      expands = value;
      if (value) {
        obscureText = false;
        maxLines = 0;
        minLines = 0;
      } else {
        maxLines = 1;
      }
    });
  }

  void onMaxLines(double value) {
    onMark('maxLines ${value.round()}', () {
      maxLines = value;
      final max = maxLinesOf();
      final min = minLinesOf();
      if (max != null && min != null && min > max) {
        minLines = max.toDouble();
      }
    });
  }

  void onMinLines(double value) {
    onMark('minLines ${value.round()}', () {
      minLines = value;
      final max = maxLinesOf();
      final min = minLinesOf();
      if (max != null && min != null && min > max) {
        minLines = max.toDouble();
      }
    });
  }

  void onReset() {
    readOnly = false;
    obscureText = false;
    obscuringCharacter = '•';
    autocorrect = true;
    smartDashesType = SmartDashesType.enabled;
    smartQuotesType = SmartQuotesType.enabled;
    enableSuggestions = true;
    fontSize = 16;
    styleColor = null;
    fontWeight = FontWeight.w400;
    cursorColor = Colors.blue;
    backgroundCursorColor = Colors.grey;
    textAlign = TextAlign.start;
    dirKind = _DirKind.nil;
    localeKind = _LocaleKind.nil;
    scalerKind = _ScalerKind.nil;
    scalerFactor = 1.5;
    maxLines = 1;
    minLines = 0;
    expands = false;
    forceLine = true;
    useTextHeightBehavior = false;
    applyHeightToFirstAscent = true;
    applyHeightToLastDescent = true;
    textWidthBasis = TextWidthBasis.parent;
    autofocus = false;
    showCursor = null;
    showSelectionHandles = false;
    selectionColor = null;
    keyboardKind = _KeyboardKind.auto;
    actionKind = _ActionKind.nil;
    textCapitalization = TextCapitalization.none;
    formatterKind = _FormatterKind.nil;
    mouseKind = _MouseKind.nil;
    rendererIgnoresPointer = false;
    cursorWidth = 2;
    cursorHeight = 0;
    cursorRadius = 0;
    cursorOpacityAnimates = false;
    useCursorOffset = false;
    cursorOffsetDx = 0;
    cursorOffsetDy = 0;
    paintCursorAboveText = false;
    selectionHeightStyle = BoxHeightStyle.tight;
    selectionWidthStyle = BoxWidthStyle.tight;
    scrollPadding = 20;
    keyboardAppearance = Brightness.light;
    dragStartBehavior = DragStartBehavior.start;
    enableInteractiveSelection = null;
    useScrollController = false;
    physicsKind = _PhysicsKind.platform;
    autocorrectionTextRectColor = null;
    autofillKind = _AutofillKind.empty;
    clipBehavior = Clip.hardEdge;
    useRestorationId = false;
    useScrollBehavior = false;
    scribbleEnabled = true;
    enableIMEPersonalizedLearning = true;
    useContextMenu = false;
    useMagnifier = false;
    useUndoController = false;
    strutKind = _StrutKind.nil;
    useCustomGroupId = false;
    lastEvent = '—';
    textController.text = _sampleText;
    setState(() {});
  }
}
