import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// bindings 是否挂上快捷键
enum _BindingKind { original, empty }

class CallbackShortcutsDemo extends StatefulWidget {
  const CallbackShortcutsDemo({
    super.key,
    this.title,
    this.message = 'This is the message.',
  });

  final String? title;
  final String message;

  @override
  State<CallbackShortcutsDemo> createState() => _CallbackShortcutsDemoState();
}

class _CallbackShortcutsDemoState extends State<CallbackShortcutsDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();
  final buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  /// 原 Demo Ctrl+S 切换显示
  _BindingKind bindingKind = _BindingKind.original;
  LogicalKeyboardKey trigger = LogicalKeyboardKey.keyS;
  bool control = true;
  bool shift = false;
  bool alt = false;
  bool meta = false;
  bool includeRepeats = true;
  bool showing = false;
  String lastEvent = '—';

  static const triggers = <(String, LogicalKeyboardKey)>[
    ('S', LogicalKeyboardKey.keyS),
    ('M', LogicalKeyboardKey.keyM),
    ('H', LogicalKeyboardKey.keyH),
    ('Space', LogicalKeyboardKey.space),
  ];

  @override
  void dispose() {
    buttonFocusNode.dispose();
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
                            NLangEnum.en: 'Widget CallbackShortcuts',
                            NLangEnum.zh: '组件 CallbackShortcuts',
                          },
                          items: [
                            {
                              NLangEnum.en:
                                  'CallbackShortcuts only has bindings and child. Focus the preview, then press the shortcut (default Ctrl+S) to toggle the message.',
                              NLangEnum.zh: 'CallbackShortcuts 只有 bindings 和 child。先点预览拿到焦点，再按快捷键（默认 Ctrl+S）切换文案。',
                            },
                            {
                              NLangEnum.en:
                                  'OPEN MENU / Show Message / Radio two are the original child. empty bindings means the shortcut does nothing.',
                              NLangEnum.zh: 'OPEN MENU、Show Message、Radio two 是原来的 child。bindings 选 empty 时快捷键无效。',
                            },
                          ],
                        ),
                        buildConstructCard(),
                        if (bindingKind == _BindingKind.original) buildActivatorCard(),
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
                child: buildShortcuts(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text(
              '$shortcutLabel · $lastEvent',
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

  Widget buildShortcuts() {
    return CallbackShortcuts(
      bindings: bindingsOf(),
      child: Focus(
        autofocus: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MenuAnchor(
              childFocusNode: buttonFocusNode,
              menuChildren: [
                CheckboxMenuButton(
                  value: showing,
                  onChanged: onCheckbox,
                  child: const Text('Show Message'),
                ),
                RadioMenuButton(
                  groupValue: 0,
                  value: 0,
                  onChanged: onRadio,
                  child: const Text('two'),
                ),
              ],
              builder: (context, controller, child) {
                return TextButton(
                  focusNode: buttonFocusNode,
                  onPressed: () => onMenu(controller),
                  child: const Text('OPEN MENU'),
                );
              },
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    showing ? widget.message : '',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<ShortcutActivator, VoidCallback> bindingsOf() {
    if (bindingKind == _BindingKind.empty) {
      return const <ShortcutActivator, VoidCallback>{};
    }
    return <ShortcutActivator, VoidCallback>{
      SingleActivator(
        trigger,
        control: control,
        shift: shift,
        alt: alt,
        meta: meta,
        includeRepeats: includeRepeats,
      ): onShortcut,
    };
  }

  String get shortcutLabel {
    if (bindingKind == _BindingKind.empty) {
      return 'bindings {}';
    }
    final parts = <String>[];
    if (control) {
      parts.add('Ctrl');
    }
    if (shift) {
      parts.add('Shift');
    }
    if (alt) {
      parts.add('Alt');
    }
    if (meta) {
      parts.add('Meta');
    }
    final triggerName = triggers.firstWhere((e) => identical(e.$2, trigger), orElse: () => ('?', trigger)).$1;
    parts.add(triggerName);
    return parts.join('+');
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'bindings · child',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'bindings',
            child: buildChoiceChips(
              values: _BindingKind.values,
              isSelected: (e) => bindingKind == e,
              labelOf: (e) => e.name,
              onChanged: onBindingKind,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActivatorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.keyboard_rounded),
      title: 'SingleActivator',
      subtitle: 'trigger · control · shift · alt · meta · includeRepeats',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'trigger',
            child: buildChoiceChips(
              values: triggers,
              isSelected: (e) => identical(trigger, e.$2),
              labelOf: (e) => e.$1,
              onChanged: onTrigger,
            ),
          ),
          buildSwitch(title: 'control', value: control, onChanged: onControl),
          buildSwitch(title: 'shift', value: shift, onChanged: onShift),
          buildSwitch(title: 'alt', value: alt, onChanged: onAlt),
          buildSwitch(title: 'meta', value: meta, onChanged: onMeta),
          buildSwitch(title: 'includeRepeats', value: includeRepeats, onChanged: onIncludeRepeats),
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

  void onShortcut() {
    showing = !showing;
    lastEvent = 'onShortcut $shortcutLabel';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onCheckbox(bool? value) {
    showing = value ?? false;
    lastEvent = 'onCheckbox $showing';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onRadio(int? value) {
    lastEvent = 'onRadio $value';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onMenu(MenuController controller) {
    if (controller.isOpen) {
      controller.close();
      lastEvent = 'onMenu close';
    } else {
      controller.open();
      lastEvent = 'onMenu open';
    }
    DLog.d(lastEvent);
    setState(() {});
  }

  void onBindingKind(_BindingKind value) {
    bindingKind = value;
    setState(() {});
  }

  void onTrigger((String, LogicalKeyboardKey) value) {
    trigger = value.$2;
    setState(() {});
  }

  void onControl(bool value) {
    control = value;
    setState(() {});
  }

  void onShift(bool value) {
    shift = value;
    setState(() {});
  }

  void onAlt(bool value) {
    alt = value;
    setState(() {});
  }

  void onMeta(bool value) {
    meta = value;
    setState(() {});
  }

  void onIncludeRepeats(bool value) {
    includeRepeats = value;
    setState(() {});
  }

  void onReset() {
    bindingKind = _BindingKind.original;
    trigger = LogicalKeyboardKey.keyS;
    control = true;
    shift = false;
    alt = false;
    meta = false;
    includeRepeats = true;
    showing = false;
    lastEvent = '—';
    setState(() {});
  }
}
