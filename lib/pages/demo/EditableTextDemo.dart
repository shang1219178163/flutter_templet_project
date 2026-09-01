import 'dart:ui' show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_color_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

/// 键盘类型，auto 表示交给构造函数推断
enum _KeyboardKind {
  auto(label: 'auto', keyboardType: null),
  text(label: 'text', keyboardType: TextInputType.text),
  multiline(label: 'multiline', keyboardType: TextInputType.multiline),
  number(label: 'number', keyboardType: TextInputType.number),
  phone(label: 'phone', keyboardType: TextInputType.phone),
  datetime(label: 'datetime', keyboardType: TextInputType.datetime),
  emailAddress(label: 'emailAddress', keyboardType: TextInputType.emailAddress),
  url(label: 'url', keyboardType: TextInputType.url),
  visiblePassword(label: 'visiblePassword', keyboardType: TextInputType.visiblePassword),
  name(label: 'name', keyboardType: TextInputType.name),
  none(label: 'none', keyboardType: TextInputType.none);

  const _KeyboardKind({required this.label, required this.keyboardType});
  /// Chip 文案
  final String label;
  /// 对应 keyboardType；auto 为 null
  final TextInputType? keyboardType;
}

/// 键盘动作，nil 表示 null
enum _ActionKind {
  nil(label: 'nil', textInputAction: null),
  none(label: 'none', textInputAction: TextInputAction.none),
  unspecified(label: 'unspecified', textInputAction: TextInputAction.unspecified),
  done(label: 'done', textInputAction: TextInputAction.done),
  go(label: 'go', textInputAction: TextInputAction.go),
  search(label: 'search', textInputAction: TextInputAction.search),
  send(label: 'send', textInputAction: TextInputAction.send),
  next(label: 'next', textInputAction: TextInputAction.next),
  previous(label: 'previous', textInputAction: TextInputAction.previous),
  newline(label: 'newline', textInputAction: TextInputAction.newline);

  const _ActionKind({required this.label, required this.textInputAction});
  /// Chip 文案
  final String label;
  /// 对应 textInputAction；nil 为 null
  final TextInputAction? textInputAction;
}

/// 文本方向
enum _DirKind {
  nil(label: 'nil', direction: null),
  ltr(label: 'ltr', direction: TextDirection.ltr),
  rtl(label: 'rtl', direction: TextDirection.rtl);

  const _DirKind({required this.label, required this.direction});
  /// Chip 文案
  final String label;
  /// 对应 textDirection；nil 为 null
  final TextDirection? direction;
}


/// 指针样式
enum _MouseKind {
  nil(label: 'nil', cursor: null),
  text(label: 'text', cursor: SystemMouseCursors.text),
  basic(label: 'basic', cursor: SystemMouseCursors.basic),
  click(label: 'click', cursor: SystemMouseCursors.click),
  forbidden(label: 'forbidden', cursor: SystemMouseCursors.forbidden),
  grab(label: 'grab', cursor: SystemMouseCursors.grab);

  const _MouseKind({required this.label, required this.cursor});
  /// Chip 文案
  final String label;
  /// 对应 mouseCursor；nil 为 null
  final MouseCursor? cursor;
}

/// 文本缩放
enum _ScalerKind {
  nil(label: 'nil'),
  noScaling(label: 'noScaling'),
  linear(label: 'linear');

  const _ScalerKind({required this.label});
  /// Chip 文案
  final String label;

  /// 对应 textScaler；linear 使用 [factor]
  TextScaler? textScaler(double factor) => switch (this) {
        _ScalerKind.nil => null,
        _ScalerKind.noScaling => TextScaler.noScaling,
        _ScalerKind.linear => TextScaler.linear(factor),
      };
}

/// strut 预设
enum _StrutKind {
  nil(label: 'nil', strutStyle: null),
  disabled(label: 'disabled', strutStyle: StrutStyle.disabled),
  force(label: 'force', strutStyle: StrutStyle(forceStrutHeight: true));

  const _StrutKind({required this.label, required this.strutStyle});
  /// Chip 文案
  final String label;
  /// 对应 strutStyle；nil 为 null
  final StrutStyle? strutStyle;
}

/// 输入格式化
enum _FormatterKind {
  nil(label: 'nil'),
  digits(label: 'digits'),
  length(label: 'length');

  const _FormatterKind({required this.label});
  /// Chip 文案
  final String label;

  /// 对应 inputFormatters
  List<TextInputFormatter>? get formatters => switch (this) {
        _FormatterKind.nil => null,
        _FormatterKind.digits => [FilteringTextInputFormatter.digitsOnly],
        _FormatterKind.length => [LengthLimitingTextInputFormatter(10)],
      };
}

/// 自动填充
enum _AutofillKind {
  empty(label: 'empty', hints: <String>[]),
  email(label: 'email', hints: [AutofillHints.email]),
  username(label: 'username', hints: [AutofillHints.username]),
  password(label: 'password', hints: [AutofillHints.password]),
  telephone(label: 'telephone', hints: [AutofillHints.telephoneNumber]);

  const _AutofillKind({required this.label, required this.hints});
  /// Chip 文案
  final String label;
  /// 对应 autofillHints
  final Iterable<String> hints;
}

/// 语言
enum _LocaleKind {
  nil(label: 'nil', locale: null),
  en(label: 'en', locale: Locale('en')),
  zh(label: 'zh', locale: Locale('zh'));

  const _LocaleKind({required this.label, required this.locale});
  /// Chip 文案
  final String label;
  /// 对应 locale；nil 为 null
  final Locale? locale;
}

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
  PhysicsKind physicsKind = PhysicsKind.platform;
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
      strutStyle: strutKind.strutStyle,
      cursorColor: cursorColor,
      backgroundCursorColor: backgroundCursorColor,
      textAlign: textAlign,
      textDirection: dirKind.direction,
      locale: localeKind.locale,
      textScaler: scalerKind.textScaler(scalerFactor),
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
      keyboardType: keyboardKind.keyboardType,
      textInputAction: actionKind.textInputAction,
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
      inputFormatters: formatterKind.formatters,
      mouseCursor: mouseKind.cursor,
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
      scrollPhysics: physicsKind.physics,
      autocorrectionTextRectColor: autocorrectionTextRectColor,
      autofillHints: autofillKind.hints,
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
          NSwitchListItem(
            title: const Text('readOnly'),
            value: readOnly,
            onChanged: (v) => onMark('readOnly $v', () => readOnly = v),
          ),
          NSwitchListItem(title: const Text('obscureText'), value: obscureText, onChanged: onObscureText),
          if (obscureText) ...[
            const SizedBox(height: 8),
            NChoiceChipListItem(
              title: const Text('obscuringCharacter'),
              values: const ['•', '*', '●'],
              onEqual: (e) => obscuringCharacter == e,
              labelOf: (e) => e,
              onChanged: (v) => onMark('obscuringCharacter $v', () => obscuringCharacter = v),
            ),
          ],
          NSwitchListItem(
            title: const Text('autocorrect'),
            value: autocorrect,
            onChanged: (v) => onMark('autocorrect $v', () => autocorrect = v),
          ),
          NSwitchListItem(
            title: const Text('enableSuggestions'),
            value: enableSuggestions,
            onChanged: (v) => onMark('enableSuggestions $v', () => enableSuggestions = v),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('smartDashesType'),
            values: SmartDashesType.values,
            onEqual: (e) => smartDashesType == e,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('smartDashesType ${e.name}', () => smartDashesType = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('smartQuotesType'),
            values: SmartQuotesType.values,
            onEqual: (e) => smartQuotesType == e,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('smartQuotesType ${e.name}', () => smartQuotesType = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('keyboardType'),
            values: _KeyboardKind.values,
            onEqual: (e) => keyboardKind == e,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('keyboardType ${e.name}', () => keyboardKind = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('textInputAction'),
            values: _ActionKind.values,
            onEqual: (e) => actionKind == e,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('textInputAction ${e.name}', () => actionKind = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('textCapitalization'),
            values: TextCapitalization.values,
            onEqual: (e) => textCapitalization == e,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('textCapitalization ${e.name}', () => textCapitalization = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('autofillHints'),
            values: _AutofillKind.values,
            onEqual: (e) => autofillKind == e,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('autofillHints ${e.name}', () => autofillKind = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('inputFormatters'),
            values: _FormatterKind.values,
            onEqual: (e) => formatterKind == e,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('inputFormatters ${e.name}', () => formatterKind = e),
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
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('style.fontSize'),
            min: 10,
            max: 32,
            value: fontSize.clamp(10, 32),
            onChanged: (v) => onMark('style.fontSize ${v.round()}', () => fontSize = v),
            activeColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: 8),
          NChoiceColorListItem(
            title: const Text('style.color'),
            value: styleColor,
            onChanged: (v) => onMark('style.color ${v ?? 'null'}', () => styleColor = v),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('style.fontWeight'),
            values: const [FontWeight.w300, FontWeight.w400, FontWeight.w500, FontWeight.w600, FontWeight.w700],
            onEqual: (e) => fontWeight == e,
            labelOf: (e) => e.toString().split('.').last,
            onChanged: (e) => onMark('style.fontWeight ${e.toString().split('.').last}', () => fontWeight = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('textAlign'),
            values: TextAlign.values,
            onEqual: (e) => textAlign == e,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('textAlign ${e.name}', () => textAlign = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('textDirection'),
            values: _DirKind.values,
            onEqual: (e) => dirKind == e,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('textDirection ${e.name}', () => dirKind = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('locale'),
            values: _LocaleKind.values,
            onEqual: (e) => localeKind == e,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('locale ${e.name}', () => localeKind = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('textScaler'),
            values: _ScalerKind.values,
            onEqual: (e) => scalerKind == e,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('textScaler ${e.name}', () => scalerKind = e),
          ),
          if (scalerKind == _ScalerKind.linear)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('textScaler.linear'),
              min: 0.5,
              max: 2.5,
              value: scalerFactor.clamp(0.5, 2.5),
              onChanged: (v) => onMark('textScaler.linear ${v.toStringAsFixed(2)}', () => scalerFactor = v),
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
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('strutStyle'),
            values: _StrutKind.values,
            onEqual: (e) => strutKind == e,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('strutStyle ${e.name}', () => strutKind = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('textWidthBasis'),
            values: TextWidthBasis.values,
            onEqual: (e) => textWidthBasis == e,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('textWidthBasis ${e.name}', () => textWidthBasis = e),
          ),
          NSwitchListItem(
            title: const Text('forceLine'),
            value: forceLine,
            onChanged: (v) => onMark('forceLine $v', () => forceLine = v),
          ),
          NSwitchListItem(
            title: const Text('textHeightBehavior'),
            value: useTextHeightBehavior,
            onChanged: (v) => onMark('textHeightBehavior $v', () => useTextHeightBehavior = v),
          ),
          if (useTextHeightBehavior) ...[
            NSwitchListItem(
              title: const Text('applyHeightToFirstAscent'),
              value: applyHeightToFirstAscent,
              onChanged: (v) => onMark('applyHeightToFirstAscent $v', () => applyHeightToFirstAscent = v),
            ),
            NSwitchListItem(
              title: const Text('applyHeightToLastDescent'),
              value: applyHeightToLastDescent,
              onChanged: (v) => onMark('applyHeightToLastDescent $v', () => applyHeightToLastDescent = v),
            ),
          ],
          const SizedBox(height: 8),
          NChoiceColorListItem(
            title: const Text('cursorColor'),
            value: cursorColor,
            colors: AppColor.colorOptions.where((e) => e != null).toList(),
            onChanged: (v) => onMark('cursorColor $v', () => cursorColor = v ?? Colors.blue),
          ),
          const SizedBox(height: 8),
          NChoiceColorListItem(
            title: const Text('backgroundCursorColor'),
            value: backgroundCursorColor,
            colors: AppColor.colorOptions.where((e) => e != null).toList(),
            onChanged: (v) => onMark('backgroundCursorColor $v', () => backgroundCursorColor = v ?? Colors.grey),
          ),
          const SizedBox(height: 8),
          NChoiceColorListItem(
            title: const Text('selectionColor'),
            value: selectionColor,
            onChanged: (v) => onMark('selectionColor ${v ?? 'null'}', () => selectionColor = v),
          ),
          const SizedBox(height: 8),
          NChoiceColorListItem(
            title: const Text('autocorrectionTextRectColor'),
            value: autocorrectionTextRectColor,
            onChanged: (v) => onMark('autocorrectionTextRectColor ${v ?? 'null'}', () => autocorrectionTextRectColor = v),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('showCursor'),
            values: const [null, true, false],
            onEqual: (e) => showCursor == e,
            labelOf: (e) => e == null ? '默' : '$e',
            onChanged: (e) => onMark('showCursor ${e ?? 'null'}', () => showCursor = e),
          ),
          NSwitchListItem(
            title: const Text('showSelectionHandles'),
            value: showSelectionHandles,
            onChanged: (v) => onMark('showSelectionHandles $v', () => showSelectionHandles = v),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('enableInteractiveSelection'),
            values: const [null, true, false],
            onEqual: (e) => enableInteractiveSelection == e,
            labelOf: (e) => e == null ? '默' : '$e',
            onChanged: (e) => onMark('enableInteractiveSelection ${e ?? 'null'}', () => enableInteractiveSelection = e),
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('cursorWidth'),
            min: 1,
            max: 8,
            value: cursorWidth.clamp(1, 8),
            onChanged: (v) => onMark('cursorWidth ${v.round()}', () => cursorWidth = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('cursorHeight'),
            min: 0,
            max: 48,
            value: cursorHeight.clamp(0, 48),
            onChanged: (v) => onMark('cursorHeight ${v.round()}', () => cursorHeight = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('cursorRadius'),
            min: 0,
            max: 12,
            value: cursorRadius.clamp(0, 12),
            onChanged: (v) => onMark('cursorRadius ${v.round()}', () => cursorRadius = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSwitchListItem(
            title: const Text('cursorOpacityAnimates'),
            value: cursorOpacityAnimates,
            onChanged: (v) => onMark('cursorOpacityAnimates $v', () => cursorOpacityAnimates = v),
          ),
          NSwitchListItem(
            title: const Text('cursorOffset'),
            value: useCursorOffset,
            onChanged: (v) => onMark('cursorOffset $v', () => useCursorOffset = v),
          ),
          if (useCursorOffset) ...[
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('cursorOffset.dx'),
              min: -8,
              max: 8,
              value: cursorOffsetDx.clamp(-8, 8),
              onChanged: (v) => onMark('cursorOffset.dx ${v.toStringAsFixed(1)}', () => cursorOffsetDx = v),
              activeColor: theme.colorScheme.primary,
              valueBuilder: (context, v) {
                return Text(
                  v.toStringAsFixed(1),
                  style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
                );
              },
            ),
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('cursorOffset.dy'),
              min: -8,
              max: 8,
              value: cursorOffsetDy.clamp(-8, 8),
              onChanged: (v) => onMark('cursorOffset.dy ${v.toStringAsFixed(1)}', () => cursorOffsetDy = v),
              activeColor: theme.colorScheme.primary,
              valueBuilder: (context, v) {
                return Text(
                  v.toStringAsFixed(1),
                  style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
                );
              },
            ),
          ],
          NSwitchListItem(
            title: const Text('paintCursorAboveText'),
            value: paintCursorAboveText,
            onChanged: (v) => onMark('paintCursorAboveText $v', () => paintCursorAboveText = v),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('selectionHeightStyle'),
            values: BoxHeightStyle.values,
            onEqual: (e) => selectionHeightStyle == e,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('selectionHeightStyle ${e.name}', () => selectionHeightStyle = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('selectionWidthStyle'),
            values: BoxWidthStyle.values,
            onEqual: (e) => selectionWidthStyle == e,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('selectionWidthStyle ${e.name}', () => selectionWidthStyle = e),
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
          NSwitchListItem(title: const Text('expands'), value: expands, onChanged: onExpands),
          if (!expands && !obscureText)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('maxLines'),
              min: 0,
              max: 8,
              value: maxLines.clamp(0, 8),
              onChanged: onMaxLines,
              activeColor: theme.colorScheme.primary,
            ),
          if (!expands && !obscureText)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('minLines'),
              min: 0,
              max: 8,
              value: minLines.clamp(0, 8),
              onChanged: onMinLines,
              activeColor: theme.colorScheme.primary,
            ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('scrollPadding'),
            min: 0,
            max: 48,
            value: scrollPadding.clamp(0, 48),
            onChanged: (v) => onMark('scrollPadding ${v.round()}', () => scrollPadding = v),
            activeColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('clipBehavior'),
            values: Clip.values,
            onEqual: (e) => clipBehavior == e,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('clipBehavior ${e.name}', () => clipBehavior = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('scrollPhysics'),
            values: PhysicsKind.values,
            onEqual: (e) => physicsKind == e,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('scrollPhysics ${e.name}', () => physicsKind = e),
          ),
          NSwitchListItem(
            title: const Text('scrollController'),
            value: useScrollController,
            onChanged: (v) => onMark('scrollController $v', () => useScrollController = v),
          ),
          NSwitchListItem(
            title: const Text('scrollBehavior'),
            value: useScrollBehavior,
            onChanged: (v) => onMark('scrollBehavior $v', () => useScrollBehavior = v),
          ),
          NSwitchListItem(
            title: const Text('autofocus'),
            value: autofocus,
            onChanged: (v) => onMark('autofocus $v', () => autofocus = v),
          ),
          NSwitchListItem(
            title: const Text('rendererIgnoresPointer'),
            value: rendererIgnoresPointer,
            onChanged: (v) => onMark('rendererIgnoresPointer $v', () => rendererIgnoresPointer = v),
          ),
          NSwitchListItem(
            title: const Text('scribbleEnabled'),
            value: scribbleEnabled,
            onChanged: (v) => onMark('scribbleEnabled $v', () => scribbleEnabled = v),
          ),
          NSwitchListItem(
            title: const Text('enableIMEPersonalizedLearning'),
            value: enableIMEPersonalizedLearning,
            onChanged: (v) => onMark('enableIMEPersonalizedLearning $v', () => enableIMEPersonalizedLearning = v),
          ),
          NSwitchListItem(
            title: const Text('contextMenuBuilder'),
            value: useContextMenu,
            onChanged: (v) => onMark('contextMenuBuilder $v', () => useContextMenu = v),
          ),
          NSwitchListItem(
            title: const Text('magnifierConfiguration'),
            value: useMagnifier,
            onChanged: (v) => onMark('magnifierConfiguration $v', () => useMagnifier = v),
          ),
          NSwitchListItem(
            title: const Text('undoController'),
            value: useUndoController,
            onChanged: (v) => onMark('undoController $v', () => useUndoController = v),
          ),
          NSwitchListItem(
            title: const Text('restorationId'),
            value: useRestorationId,
            onChanged: (v) => onMark('restorationId $v', () => useRestorationId = v),
          ),
          NSwitchListItem(
            title: const Text('groupId 自定义'),
            value: useCustomGroupId,
            onChanged: (v) => onMark('groupId $v', () => useCustomGroupId = v),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('mouseCursor'),
            values: _MouseKind.values,
            onEqual: (e) => mouseKind == e,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('mouseCursor ${e.name}', () => mouseKind = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('keyboardAppearance'),
            values: Brightness.values,
            onEqual: (e) => keyboardAppearance == e,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('keyboardAppearance ${e.name}', () => keyboardAppearance = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('dragStartBehavior'),
            values: DragStartBehavior.values,
            onEqual: (e) => dragStartBehavior == e,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('dragStartBehavior ${e.name}', () => dragStartBehavior = e),
          ),
        ],
      ),
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

  TextHeightBehavior? textHeightBehaviorOf() {
    if (!useTextHeightBehavior) {
      return null;
    }
    return TextHeightBehavior(
      applyHeightToFirstAscent: applyHeightToFirstAscent,
      applyHeightToLastDescent: applyHeightToLastDescent,
    );
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
    physicsKind = PhysicsKind.platform;
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
