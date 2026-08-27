import 'dart:ui' show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/basicWidget/n_style_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

/// 可空 bool
enum _Tri { nil, yes, no }

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

  /// 预览区初始文本
  static const _sampleText = 'Hello EditableText';

  final scrollController = ScrollController();
  final textController = TextEditingController(text: _sampleText);
  final focusNode = FocusNode();
  final fieldScrollController = ScrollController();
  final undoController = UndoHistoryController();

  bool readOnly = false;
  bool obscureText = false;
  String obscuringCharacter = '•';
  bool autocorrect = true;
  SmartDashesType smartDashesType = SmartDashesType.enabled;
  SmartQuotesType smartQuotesType = SmartQuotesType.enabled;
  bool enableSuggestions = true;
  double fontSize = 16;
  Color? styleColor;
  FontWeight fontWeight = FontWeight.w400;
  Color cursorColor = Colors.blue;
  Color backgroundCursorColor = Colors.grey;
  TextAlign textAlign = TextAlign.start;
  _DirKind dirKind = _DirKind.nil;
  _LocaleKind localeKind = _LocaleKind.nil;
  _ScalerKind scalerKind = _ScalerKind.nil;
  double scalerFactor = 1.5;
  double maxLines = 1;
  double minLines = 0;
  bool expands = false;
  bool forceLine = true;
  bool useTextHeightBehavior = false;
  bool applyHeightToFirstAscent = true;
  bool applyHeightToLastDescent = true;
  TextWidthBasis textWidthBasis = TextWidthBasis.parent;
  bool autofocus = false;
  _Tri showCursorKind = _Tri.nil;
  bool showSelectionHandles = false;
  Color? selectionColor;
  _KeyboardKind keyboardKind = _KeyboardKind.auto;
  _ActionKind actionKind = _ActionKind.nil;
  TextCapitalization textCapitalization = TextCapitalization.none;
  _FormatterKind formatterKind = _FormatterKind.nil;
  _MouseKind mouseKind = _MouseKind.nil;
  bool rendererIgnoresPointer = false;
  double cursorWidth = 2;
  double cursorHeight = 0;
  double cursorRadius = 0;
  bool cursorOpacityAnimates = false;
  bool useCursorOffset = false;
  double cursorOffsetDx = 0;
  double cursorOffsetDy = 0;
  bool paintCursorAboveText = false;
  BoxHeightStyle selectionHeightStyle = BoxHeightStyle.tight;
  BoxWidthStyle selectionWidthStyle = BoxWidthStyle.tight;
  double scrollPadding = 20;
  Brightness keyboardAppearance = Brightness.light;
  DragStartBehavior dragStartBehavior = DragStartBehavior.start;
  _Tri interactiveKind = _Tri.nil;
  bool useScrollController = false;
  _PhysicsKind physicsKind = _PhysicsKind.platform;
  Color? autocorrectionTextRectColor;
  _AutofillKind autofillKind = _AutofillKind.empty;
  Clip clipBehavior = Clip.hardEdge;
  bool useRestorationId = false;
  bool useScrollBehavior = false;
  bool scribbleEnabled = true;
  bool enableIMEPersonalizedLearning = true;
  bool useContextMenu = false;
  bool useMagnifier = false;
  bool useUndoController = false;
  _StrutKind strutKind = _StrutKind.nil;
  bool useCustomGroupId = false;
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
                        {
                          NLangEnum.en:
                              'onChanged / onEditingComplete / onSubmitted / onSelectionChanged / onTapOutside update lastEvent.',
                          NLangEnum.zh:
                              'onChanged / onEditingComplete / onSubmitted / onSelectionChanged / onTapOutside 会更新 lastEvent。',
                        },
                      ],
                    ),
                    buildConstructCard(),
                    buildStyleCard(),
                    buildCursorCard(),
                    buildLayoutCard(),
                    buildBehaviorCard(),
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
    final theme = Theme.of(context);
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
      showCursor: showCursorOf(),
      showSelectionHandles: showSelectionHandles,
      selectionColor: selectionColor,
      keyboardType: keyboardTypeOf(),
      textInputAction: textInputActionOf(),
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      onAppPrivateCommand: onAppPrivateCommand,
      onSelectionChanged: onSelectionChanged,
      onSelectionHandleTapped: onSelectionHandleTapped,
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
      enableInteractiveSelection: enableInteractiveSelectionOf(),
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

  Widget buildConstructCard() {
    return NStyleCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'readOnly · obscureText · keyboardType · inputFormatters',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(title: 'readOnly', value: readOnly, onChanged: onReadOnly),
          buildSwitch(title: 'obscureText', value: obscureText, onChanged: onObscureText),
          if (obscureText)
            buildField(
              label: 'obscuringCharacter',
              showTopGap: true,
              child: buildChoiceChips(
                values: const ['•', '*', '●'],
                isSelected: (e) => obscuringCharacter == e,
                labelOf: (e) => e,
                onChanged: onObscuringCharacter,
              ),
            ),
          buildSwitch(title: 'autocorrect', value: autocorrect, onChanged: onAutocorrect),
          buildSwitch(title: 'enableSuggestions', value: enableSuggestions, onChanged: onEnableSuggestions),
          buildField(
            label: 'smartDashesType',
            showTopGap: true,
            child: buildChoiceChips(
              values: SmartDashesType.values,
              isSelected: (e) => smartDashesType == e,
              labelOf: (e) => e.name,
              onChanged: onSmartDashesType,
            ),
          ),
          buildField(
            label: 'smartQuotesType',
            showTopGap: true,
            child: buildChoiceChips(
              values: SmartQuotesType.values,
              isSelected: (e) => smartQuotesType == e,
              labelOf: (e) => e.name,
              onChanged: onSmartQuotesType,
            ),
          ),
          buildField(
            label: 'keyboardType',
            showTopGap: true,
            child: buildChoiceChips(
              values: _KeyboardKind.values,
              isSelected: (e) => keyboardKind == e,
              labelOf: (e) => e.name,
              onChanged: onKeyboardKind,
            ),
          ),
          buildField(
            label: 'textInputAction',
            showTopGap: true,
            child: buildChoiceChips(
              values: _ActionKind.values,
              isSelected: (e) => actionKind == e,
              labelOf: (e) => e.name,
              onChanged: onActionKind,
            ),
          ),
          buildField(
            label: 'textCapitalization',
            showTopGap: true,
            child: buildChoiceChips(
              values: TextCapitalization.values,
              isSelected: (e) => textCapitalization == e,
              labelOf: (e) => e.name,
              onChanged: onTextCapitalization,
            ),
          ),
          buildField(
            label: 'autofillHints',
            showTopGap: true,
            child: buildChoiceChips(
              values: _AutofillKind.values,
              isSelected: (e) => autofillKind == e,
              labelOf: (e) => e.name,
              onChanged: onAutofillKind,
            ),
          ),
          buildField(
            label: 'inputFormatters',
            showTopGap: true,
            child: buildChoiceChips(
              values: _FormatterKind.values,
              isSelected: (e) => formatterKind == e,
              labelOf: (e) => e.name,
              onChanged: onFormatterKind,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStyleCard() {
    return NStyleCard(
      icon: const Icon(Icons.text_fields_rounded),
      title: '样式',
      subtitle: 'style · textAlign · textScaler · strutStyle',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSlider(label: 'style.fontSize', value: fontSize, min: 10, max: 32, onChanged: onFontSize),
          buildField(
            label: 'style.color',
            showTopGap: true,
            child: buildColorDots(value: styleColor, onChanged: onStyleColor),
          ),
          buildField(
            label: 'style.fontWeight',
            showTopGap: true,
            child: buildChoiceChips(
              values: const [FontWeight.w300, FontWeight.w400, FontWeight.w500, FontWeight.w600, FontWeight.w700],
              isSelected: (e) => fontWeight == e,
              labelOf: (e) => e.toString().split('.').last,
              onChanged: onFontWeight,
            ),
          ),
          buildField(
            label: 'textAlign',
            showTopGap: true,
            child: buildChoiceChips(
              values: TextAlign.values,
              isSelected: (e) => textAlign == e,
              labelOf: (e) => e.name,
              onChanged: onTextAlign,
            ),
          ),
          buildField(
            label: 'textDirection',
            showTopGap: true,
            child: buildChoiceChips(
              values: _DirKind.values,
              isSelected: (e) => dirKind == e,
              labelOf: (e) => e.name,
              onChanged: onDirKind,
            ),
          ),
          buildField(
            label: 'locale',
            showTopGap: true,
            child: buildChoiceChips(
              values: _LocaleKind.values,
              isSelected: (e) => localeKind == e,
              labelOf: (e) => e.name,
              onChanged: onLocaleKind,
            ),
          ),
          buildField(
            label: 'textScaler',
            showTopGap: true,
            child: buildChoiceChips(
              values: _ScalerKind.values,
              isSelected: (e) => scalerKind == e,
              labelOf: (e) => e.name,
              onChanged: onScalerKind,
            ),
          ),
          if (scalerKind == _ScalerKind.linear)
            buildSlider(
              label: 'textScaler.linear',
              value: scalerFactor,
              min: 0.5,
              max: 2.5,
              onChanged: onScalerFactor,
              fractionDigits: 2,
            ),
          buildField(
            label: 'strutStyle',
            showTopGap: true,
            child: buildChoiceChips(
              values: _StrutKind.values,
              isSelected: (e) => strutKind == e,
              labelOf: (e) => e.name,
              onChanged: onStrutKind,
            ),
          ),
          buildField(
            label: 'textWidthBasis',
            showTopGap: true,
            child: buildChoiceChips(
              values: TextWidthBasis.values,
              isSelected: (e) => textWidthBasis == e,
              labelOf: (e) => e.name,
              onChanged: onTextWidthBasis,
            ),
          ),
          buildSwitch(title: 'forceLine', value: forceLine, onChanged: onForceLine),
          buildSwitch(
            title: 'textHeightBehavior',
            value: useTextHeightBehavior,
            onChanged: onUseTextHeightBehavior,
          ),
          if (useTextHeightBehavior) ...[
            buildSwitch(
              title: 'applyHeightToFirstAscent',
              value: applyHeightToFirstAscent,
              onChanged: onApplyHeightToFirstAscent,
            ),
            buildSwitch(
              title: 'applyHeightToLastDescent',
              value: applyHeightToLastDescent,
              onChanged: onApplyHeightToLastDescent,
            ),
          ],
        ],
      ),
    );
  }

  Widget buildCursorCard() {
    return NStyleCard(
      icon: const Icon(Icons.highlight_alt_rounded),
      title: '光标与选区',
      subtitle: 'cursorColor · selectionColor · showCursor',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'cursorColor',
            child: buildColorDots(value: cursorColor, onChanged: onCursorColor, allowNull: false),
          ),
          buildField(
            label: 'backgroundCursorColor',
            showTopGap: true,
            child: buildColorDots(
              value: backgroundCursorColor,
              onChanged: onBackgroundCursorColor,
              allowNull: false,
            ),
          ),
          buildField(
            label: 'selectionColor',
            showTopGap: true,
            child: buildColorDots(value: selectionColor, onChanged: onSelectionColor),
          ),
          buildField(
            label: 'autocorrectionTextRectColor',
            showTopGap: true,
            child: buildColorDots(value: autocorrectionTextRectColor, onChanged: onAutocorrectionTextRectColor),
          ),
          buildField(
            label: 'showCursor',
            showTopGap: true,
            child: buildChoiceChips(
              values: _Tri.values,
              isSelected: (e) => showCursorKind == e,
              labelOf: nameOfTri,
              onChanged: onShowCursorKind,
            ),
          ),
          buildSwitch(
            title: 'showSelectionHandles',
            value: showSelectionHandles,
            onChanged: onShowSelectionHandles,
          ),
          buildField(
            label: 'enableInteractiveSelection',
            showTopGap: true,
            child: buildChoiceChips(
              values: _Tri.values,
              isSelected: (e) => interactiveKind == e,
              labelOf: nameOfTri,
              onChanged: onInteractiveKind,
            ),
          ),
          buildSlider(label: 'cursorWidth', value: cursorWidth, min: 1, max: 8, onChanged: onCursorWidth),
          buildSlider(label: 'cursorHeight', value: cursorHeight, min: 0, max: 48, onChanged: onCursorHeight),
          buildSlider(label: 'cursorRadius', value: cursorRadius, min: 0, max: 12, onChanged: onCursorRadius),
          buildSwitch(
            title: 'cursorOpacityAnimates',
            value: cursorOpacityAnimates,
            onChanged: onCursorOpacityAnimates,
          ),
          buildSwitch(title: 'cursorOffset', value: useCursorOffset, onChanged: onUseCursorOffset),
          if (useCursorOffset) ...[
            buildSlider(
              label: 'cursorOffset.dx',
              value: cursorOffsetDx,
              min: -8,
              max: 8,
              onChanged: onCursorOffsetDx,
              fractionDigits: 1,
            ),
            buildSlider(
              label: 'cursorOffset.dy',
              value: cursorOffsetDy,
              min: -8,
              max: 8,
              onChanged: onCursorOffsetDy,
              fractionDigits: 1,
            ),
          ],
          buildSwitch(
            title: 'paintCursorAboveText',
            value: paintCursorAboveText,
            onChanged: onPaintCursorAboveText,
          ),
          buildField(
            label: 'selectionHeightStyle',
            showTopGap: true,
            child: buildChoiceChips(
              values: BoxHeightStyle.values,
              isSelected: (e) => selectionHeightStyle == e,
              labelOf: (e) => e.name,
              onChanged: onSelectionHeightStyle,
            ),
          ),
          buildField(
            label: 'selectionWidthStyle',
            showTopGap: true,
            child: buildChoiceChips(
              values: BoxWidthStyle.values,
              isSelected: (e) => selectionWidthStyle == e,
              labelOf: (e) => e.name,
              onChanged: onSelectionWidthStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLayoutCard() {
    return NStyleCard(
      icon: const Icon(Icons.space_dashboard_rounded),
      title: '布局',
      subtitle: 'maxLines · minLines · expands · clipBehavior',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(title: 'expands', value: expands, onChanged: onExpands),
          if (!expands && !obscureText)
            buildSlider(label: 'maxLines', value: maxLines, min: 0, max: 8, onChanged: onMaxLines),
          if (!expands && !obscureText)
            buildSlider(label: 'minLines', value: minLines, min: 0, max: 8, onChanged: onMinLines),
          buildSlider(label: 'scrollPadding', value: scrollPadding, min: 0, max: 48, onChanged: onScrollPadding),
          buildField(
            label: 'clipBehavior',
            showTopGap: true,
            child: buildChoiceChips(
              values: Clip.values,
              isSelected: (e) => clipBehavior == e,
              labelOf: (e) => e.name,
              onChanged: onClipBehavior,
            ),
          ),
          buildField(
            label: 'scrollPhysics',
            showTopGap: true,
            child: buildChoiceChips(
              values: _PhysicsKind.values,
              isSelected: (e) => physicsKind == e,
              labelOf: (e) => e.name,
              onChanged: onPhysicsKind,
            ),
          ),
          buildSwitch(
            title: 'scrollController',
            value: useScrollController,
            onChanged: onUseScrollController,
          ),
          buildSwitch(
            title: 'scrollBehavior',
            value: useScrollBehavior,
            onChanged: onUseScrollBehavior,
          ),
        ],
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NStyleCard(
      icon: const Icon(Icons.tune_rounded),
      title: '行为',
      subtitle: 'autofocus · magnifier · undoController · onChanged',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(title: 'autofocus', value: autofocus, onChanged: onAutofocus),
          buildSwitch(title: 'rendererIgnoresPointer', value: rendererIgnoresPointer, onChanged: onRendererIgnoresPointer),
          buildSwitch(title: 'scribbleEnabled', value: scribbleEnabled, onChanged: onScribbleEnabled),
          buildSwitch(
            title: 'enableIMEPersonalizedLearning',
            value: enableIMEPersonalizedLearning,
            onChanged: onEnableIMEPersonalizedLearning,
          ),
          buildSwitch(title: 'contextMenuBuilder', value: useContextMenu, onChanged: onUseContextMenu),
          buildSwitch(title: 'magnifierConfiguration', value: useMagnifier, onChanged: onUseMagnifier),
          buildSwitch(title: 'undoController', value: useUndoController, onChanged: onUseUndoController),
          buildSwitch(title: 'restorationId', value: useRestorationId, onChanged: onUseRestorationId),
          buildSwitch(title: 'groupId 自定义', value: useCustomGroupId, onChanged: onUseCustomGroupId),
          buildField(
            label: 'mouseCursor',
            showTopGap: true,
            child: buildChoiceChips(
              values: _MouseKind.values,
              isSelected: (e) => mouseKind == e,
              labelOf: (e) => e.name,
              onChanged: onMouseKind,
            ),
          ),
          buildField(
            label: 'keyboardAppearance',
            showTopGap: true,
            child: buildChoiceChips(
              values: Brightness.values,
              isSelected: (e) => keyboardAppearance == e,
              labelOf: (e) => e.name,
              onChanged: onKeyboardAppearance,
            ),
          ),
          buildField(
            label: 'dragStartBehavior',
            showTopGap: true,
            child: buildChoiceChips(
              values: DragStartBehavior.values,
              isSelected: (e) => dragStartBehavior == e,
              labelOf: (e) => e.name,
              onChanged: onDragStartBehavior,
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

  Widget buildColorDots({
    required Color? value,
    required ValueChanged<Color?> onChanged,
    bool allowNull = true,
  }) {
    final scheme = Theme.of(context).colorScheme;
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
      inactiveColor: Colors.black12,
      trailingBuilder: fractionDigits > 0
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

  Widget buildContextMenu(context, editableTextState) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  TextStyle styleOf() {
    final theme = Theme.of(context);
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

  bool? showCursorOf() {
    switch (showCursorKind) {
      case _Tri.nil:
        return null;
      case _Tri.yes:
        return true;
      case _Tri.no:
        return false;
    }
  }

  bool? enableInteractiveSelectionOf() {
    switch (interactiveKind) {
      case _Tri.nil:
        return null;
      case _Tri.yes:
        return true;
      case _Tri.no:
        return false;
    }
  }

  TextDirection? textDirectionOf() {
    switch (dirKind) {
      case _DirKind.nil:
        return null;
      case _DirKind.ltr:
        return TextDirection.ltr;
      case _DirKind.rtl:
        return TextDirection.rtl;
    }
  }

  Locale? localeOf() {
    switch (localeKind) {
      case _LocaleKind.nil:
        return null;
      case _LocaleKind.en:
        return const Locale('en');
      case _LocaleKind.zh:
        return const Locale('zh');
    }
  }

  TextScaler? textScalerOf() {
    switch (scalerKind) {
      case _ScalerKind.nil:
        return null;
      case _ScalerKind.noScaling:
        return TextScaler.noScaling;
      case _ScalerKind.linear:
        return TextScaler.linear(scalerFactor);
    }
  }

  StrutStyle? strutStyleOf() {
    switch (strutKind) {
      case _StrutKind.nil:
        return null;
      case _StrutKind.disabled:
        return StrutStyle.disabled;
      case _StrutKind.force:
        return const StrutStyle(forceStrutHeight: true);
    }
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
    switch (keyboardKind) {
      case _KeyboardKind.auto:
        return null;
      case _KeyboardKind.text:
        return TextInputType.text;
      case _KeyboardKind.multiline:
        return TextInputType.multiline;
      case _KeyboardKind.number:
        return TextInputType.number;
      case _KeyboardKind.phone:
        return TextInputType.phone;
      case _KeyboardKind.datetime:
        return TextInputType.datetime;
      case _KeyboardKind.emailAddress:
        return TextInputType.emailAddress;
      case _KeyboardKind.url:
        return TextInputType.url;
      case _KeyboardKind.visiblePassword:
        return TextInputType.visiblePassword;
      case _KeyboardKind.name:
        return TextInputType.name;
      case _KeyboardKind.none:
        return TextInputType.none;
    }
  }

  TextInputAction? textInputActionOf() {
    switch (actionKind) {
      case _ActionKind.nil:
        return null;
      case _ActionKind.none:
        return TextInputAction.none;
      case _ActionKind.unspecified:
        return TextInputAction.unspecified;
      case _ActionKind.done:
        return TextInputAction.done;
      case _ActionKind.go:
        return TextInputAction.go;
      case _ActionKind.search:
        return TextInputAction.search;
      case _ActionKind.send:
        return TextInputAction.send;
      case _ActionKind.next:
        return TextInputAction.next;
      case _ActionKind.previous:
        return TextInputAction.previous;
      case _ActionKind.newline:
        return TextInputAction.newline;
    }
  }

  List<TextInputFormatter>? inputFormattersOf() {
    switch (formatterKind) {
      case _FormatterKind.nil:
        return null;
      case _FormatterKind.digits:
        return [FilteringTextInputFormatter.digitsOnly];
      case _FormatterKind.length:
        return [LengthLimitingTextInputFormatter(10)];
    }
  }

  MouseCursor? mouseCursorOf() {
    switch (mouseKind) {
      case _MouseKind.nil:
        return null;
      case _MouseKind.text:
        return SystemMouseCursors.text;
      case _MouseKind.basic:
        return SystemMouseCursors.basic;
      case _MouseKind.click:
        return SystemMouseCursors.click;
      case _MouseKind.forbidden:
        return SystemMouseCursors.forbidden;
      case _MouseKind.grab:
        return SystemMouseCursors.grab;
    }
  }

  ScrollPhysics? scrollPhysicsOf() {
    switch (physicsKind) {
      case _PhysicsKind.platform:
        return null;
      case _PhysicsKind.bouncing:
        return const BouncingScrollPhysics();
      case _PhysicsKind.clamping:
        return const ClampingScrollPhysics();
      case _PhysicsKind.never:
        return const NeverScrollableScrollPhysics();
    }
  }

  Iterable<String> autofillHintsOf() {
    switch (autofillKind) {
      case _AutofillKind.empty:
        return const <String>[];
      case _AutofillKind.email:
        return const [AutofillHints.email];
      case _AutofillKind.username:
        return const [AutofillHints.username];
      case _AutofillKind.password:
        return const [AutofillHints.password];
      case _AutofillKind.telephone:
        return const [AutofillHints.telephoneNumber];
    }
  }

  String nameOfTri(_Tri kind) {
    switch (kind) {
      case _Tri.nil:
        return 'null';
      case _Tri.yes:
        return 'true';
      case _Tri.no:
        return 'false';
    }
  }

  void onChanged(value) {
    lastEvent = 'onChanged $value';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onEditingComplete() {
    lastEvent = 'onEditingComplete';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onSubmitted(value) {
    lastEvent = 'onSubmitted $value';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onAppPrivateCommand(action, data) {
    lastEvent = 'onAppPrivateCommand $action';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onSelectionChanged(TextSelection selection, SelectionChangedCause? cause) {
    lastEvent = 'onSelectionChanged ${cause?.name} ${selection.baseOffset}-${selection.extentOffset}';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onSelectionHandleTapped() {
    lastEvent = 'onSelectionHandleTapped';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onTapOutside(event) {
    lastEvent = 'onTapOutside';
    DLog.d(lastEvent);
    focusNode.unfocus();
    setState(() {});
  }

  void onReadOnly(value) {
    readOnly = value;
    setState(() {});
  }

  void onObscureText(value) {
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
    setState(() {});
  }

  void onObscuringCharacter(value) {
    obscuringCharacter = value;
    setState(() {});
  }

  void onAutocorrect(value) {
    autocorrect = value;
    setState(() {});
  }

  void onEnableSuggestions(value) {
    enableSuggestions = value;
    setState(() {});
  }

  void onSmartDashesType(value) {
    smartDashesType = value;
    setState(() {});
  }

  void onSmartQuotesType(value) {
    smartQuotesType = value;
    setState(() {});
  }

  void onKeyboardKind(value) {
    keyboardKind = value;
    setState(() {});
  }

  void onActionKind(value) {
    actionKind = value;
    setState(() {});
  }

  void onTextCapitalization(value) {
    textCapitalization = value;
    setState(() {});
  }

  void onAutofillKind(value) {
    autofillKind = value;
    setState(() {});
  }

  void onFormatterKind(value) {
    formatterKind = value;
    setState(() {});
  }

  void onFontSize(value) {
    fontSize = value;
    setState(() {});
  }

  void onStyleColor(value) {
    styleColor = value;
    setState(() {});
  }

  void onFontWeight(value) {
    fontWeight = value;
    setState(() {});
  }

  void onTextAlign(value) {
    textAlign = value;
    setState(() {});
  }

  void onDirKind(value) {
    dirKind = value;
    setState(() {});
  }

  void onLocaleKind(value) {
    localeKind = value;
    setState(() {});
  }

  void onScalerKind(value) {
    scalerKind = value;
    setState(() {});
  }

  void onScalerFactor(value) {
    scalerFactor = value;
    setState(() {});
  }

  void onStrutKind(value) {
    strutKind = value;
    setState(() {});
  }

  void onTextWidthBasis(value) {
    textWidthBasis = value;
    setState(() {});
  }

  void onForceLine(value) {
    forceLine = value;
    setState(() {});
  }

  void onUseTextHeightBehavior(value) {
    useTextHeightBehavior = value;
    setState(() {});
  }

  void onApplyHeightToFirstAscent(value) {
    applyHeightToFirstAscent = value;
    setState(() {});
  }

  void onApplyHeightToLastDescent(value) {
    applyHeightToLastDescent = value;
    setState(() {});
  }

  void onCursorColor(value) {
    cursorColor = value ?? Colors.blue;
    setState(() {});
  }

  void onBackgroundCursorColor(value) {
    backgroundCursorColor = value ?? Colors.grey;
    setState(() {});
  }

  void onSelectionColor(value) {
    selectionColor = value;
    setState(() {});
  }

  void onAutocorrectionTextRectColor(value) {
    autocorrectionTextRectColor = value;
    setState(() {});
  }

  void onShowCursorKind(value) {
    showCursorKind = value;
    setState(() {});
  }

  void onShowSelectionHandles(value) {
    showSelectionHandles = value;
    setState(() {});
  }

  void onInteractiveKind(value) {
    interactiveKind = value;
    setState(() {});
  }

  void onCursorWidth(value) {
    cursorWidth = value;
    setState(() {});
  }

  void onCursorHeight(value) {
    cursorHeight = value;
    setState(() {});
  }

  void onCursorRadius(value) {
    cursorRadius = value;
    setState(() {});
  }

  void onCursorOpacityAnimates(value) {
    cursorOpacityAnimates = value;
    setState(() {});
  }

  void onUseCursorOffset(value) {
    useCursorOffset = value;
    setState(() {});
  }

  void onCursorOffsetDx(value) {
    cursorOffsetDx = value;
    setState(() {});
  }

  void onCursorOffsetDy(value) {
    cursorOffsetDy = value;
    setState(() {});
  }

  void onPaintCursorAboveText(value) {
    paintCursorAboveText = value;
    setState(() {});
  }

  void onSelectionHeightStyle(value) {
    selectionHeightStyle = value;
    setState(() {});
  }

  void onSelectionWidthStyle(value) {
    selectionWidthStyle = value;
    setState(() {});
  }

  void onExpands(value) {
    expands = value;
    if (value) {
      obscureText = false;
      maxLines = 0;
      minLines = 0;
    } else {
      maxLines = 1;
    }
    setState(() {});
  }

  void onMaxLines(value) {
    maxLines = value;
    final max = maxLinesOf();
    final min = minLinesOf();
    if (max != null && min != null && min > max) {
      minLines = max.toDouble();
    }
    setState(() {});
  }

  void onMinLines(value) {
    minLines = value;
    final max = maxLinesOf();
    final min = minLinesOf();
    if (max != null && min != null && min > max) {
      minLines = max.toDouble();
    }
    setState(() {});
  }

  void onScrollPadding(value) {
    scrollPadding = value;
    setState(() {});
  }

  void onClipBehavior(value) {
    clipBehavior = value;
    setState(() {});
  }

  void onPhysicsKind(value) {
    physicsKind = value;
    setState(() {});
  }

  void onUseScrollController(value) {
    useScrollController = value;
    setState(() {});
  }

  void onUseScrollBehavior(value) {
    useScrollBehavior = value;
    setState(() {});
  }

  void onAutofocus(value) {
    autofocus = value;
    setState(() {});
  }

  void onRendererIgnoresPointer(value) {
    rendererIgnoresPointer = value;
    setState(() {});
  }

  void onScribbleEnabled(value) {
    scribbleEnabled = value;
    setState(() {});
  }

  void onEnableIMEPersonalizedLearning(value) {
    enableIMEPersonalizedLearning = value;
    setState(() {});
  }

  void onUseContextMenu(value) {
    useContextMenu = value;
    setState(() {});
  }

  void onUseMagnifier(value) {
    useMagnifier = value;
    setState(() {});
  }

  void onUseUndoController(value) {
    useUndoController = value;
    setState(() {});
  }

  void onUseRestorationId(value) {
    useRestorationId = value;
    setState(() {});
  }

  void onUseCustomGroupId(value) {
    useCustomGroupId = value;
    setState(() {});
  }

  void onMouseKind(value) {
    mouseKind = value;
    setState(() {});
  }

  void onKeyboardAppearance(value) {
    keyboardAppearance = value;
    setState(() {});
  }

  void onDragStartBehavior(value) {
    dragStartBehavior = value;
    setState(() {});
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
    showCursorKind = _Tri.nil;
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
    interactiveKind = _Tri.nil;
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
