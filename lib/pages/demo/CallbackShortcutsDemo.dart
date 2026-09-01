import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// bindings 是否挂上快捷键
enum _BindingKind {
  original(label: 'original'),
  empty(label: 'empty');
  const _BindingKind({required this.label});
  final String label;
}

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

  late final theme = Theme.of(context);

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
                                  'CallbackShortcuts only has bindings and child. Focus the preview, then press the shortcut (default Ctrl+S) to toggle the message. OPEN MENU / Show Message / Radio two are the original child; empty bindings means the shortcut does nothing.',
                              NLangEnum.zh:
                                  'CallbackShortcuts 只有 bindings 和 child。先点预览拿到焦点，再按快捷键（默认 Ctrl+S）切换文案。OPEN MENU、Show Message、Radio two 是原来的 child；bindings 选 empty 时快捷键无效。',
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
                  onChanged: (v) => onMark('onCheckbox ${v ?? false}', () => showing = v ?? false),
                  child: const Text('Show Message'),
                ),
                RadioMenuButton(
                  groupValue: 0,
                  value: 0,
                  onChanged: (v) => onMark('onRadio $v'),
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
                    style: theme.textTheme.headlineSmall,
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
          NChoiceChipListItem<_BindingKind>(
            title: const Text('bindings'),
            values: _BindingKind.values,
            value: bindingKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('bindings ${e.label}', () => bindingKind = e),
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
          NChoiceChipListItem<(String, LogicalKeyboardKey)>(
            title: const Text('trigger'),
            values: triggers,
            onEqual: (e) => identical(trigger, e.$2),
            labelOf: (e) => e.$1,
            onChanged: (e) => onMark('trigger ${e.$1}', () => trigger = e.$2),
          ),
          NSwitchListTile(title: const Text('control'), value: control, onChanged: (v) => onMark('control $v', () => control = v)),
          NSwitchListTile(title: const Text('shift'), value: shift, onChanged: (v) => onMark('shift $v', () => shift = v)),
          NSwitchListTile(title: const Text('alt'), value: alt, onChanged: (v) => onMark('alt $v', () => alt = v)),
          NSwitchListTile(title: const Text('meta'), value: meta, onChanged: (v) => onMark('meta $v', () => meta = v)),
          NSwitchListTile(title: const Text('includeRepeats'), value: includeRepeats, onChanged: (v) => onMark('includeRepeats $v', () => includeRepeats = v)),
        ],
      ),
    );
  }


  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onShortcut() {
    showing = !showing;
    onMark('onShortcut $shortcutLabel');
  }

  void onMenu(MenuController controller) {
    if (controller.isOpen) {
      controller.close();
      onMark('onMenu close');
    } else {
      controller.open();
      onMark('onMenu open');
    }
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
