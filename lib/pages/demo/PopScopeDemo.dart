//
//  PopScopeDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/10/29 17:26.
//  Copyright © 2024/10/29 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// 弹出回调
enum _PopCallbackKind {
  withResult(label: 'onPopInvokedWithResult'),
  invoked(label: 'onPopInvoked'),
  none(label: 'null');
  const _PopCallbackKind({required this.label});
  final String label;
}

class PopScopeDemo extends StatefulWidget {
  const PopScopeDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<PopScopeDemo> createState() => _PopScopeDemoState();
}

class _PopScopeDemoState extends State<PopScopeDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  late final theme = Theme.of(context);

  final scrollController = ScrollController();

  bool canPop = false;
  _PopCallbackKind callbackKind = _PopCallbackKind.withResult;
  String lastEvent = '—';

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: callbackKind == _PopCallbackKind.withResult ? onPopInvokedWithResult : null,
      // ignore: deprecated_member_use
      onPopInvoked: callbackKind == _PopCallbackKind.invoked ? onPopInvoked : null,
      child: Scaffold(
        backgroundColor: scheme.surfaceContainerLowest,
        appBar: hideApp
            ? null
            : AppBar(
                title: const Text('PopScope 示例'),
                actions: [
                  TextButton(
                    onPressed: onReset,
                    child: Text('重置', style: TextStyle(color: scheme.onPrimary)),
                  ),
                ],
              ),
        body: buildBody(),
      ),
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
                        NLangEnum.en: 'Widget PopScope',
                        NLangEnum.zh: '组件 PopScope',
                      },
                      items: [
                        {
                          NLangEnum.en: 'canPop false blocks the route pop; the callback still runs with didPop false.',
                          NLangEnum.zh: 'canPop 为 false 时拦截返回；回调仍会触发且 didPop 为 false。',
                        },
                        {
                          NLangEnum.en: 'onPopInvokedWithResult and onPopInvoked cannot be set together.',
                          NLangEnum.zh: 'onPopInvokedWithResult 与 onPopInvoked 不能同时传入。',
                        },
                        {
                          NLangEnum.en: 'Original confirm dialog is kept when using onPopInvokedWithResult.',
                          NLangEnum.zh: '使用 onPopInvokedWithResult 时保留原来的确认弹窗。',
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
      ),
    );
  }

  Widget buildPreview() {
    final scheme = theme.colorScheme;
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
            Text(
              '按返回按钮会弹出确认对话框',
              style: theme.textTheme.titleSmall?.copyWith(color: scheme.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              lastEvent,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: onMaybePop,
              child: const Text('Navigator.maybePop'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'canPop',
      child: NSwitchListTile(title: const Text('canPop'), value: canPop, onChanged: onCanPop),
    );
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_rounded),
      title: '行为',
      subtitle: 'onPopInvokedWithResult · onPopInvoked',
      child: NChoiceChipListItem<_PopCallbackKind>(
        title: const Text('callback'),
        values: _PopCallbackKind.values,
        value: callbackKind,
        labelOf: (e) => e.label,
        onChanged: onCallbackKind,
      ),
    );
  }


  Future<void> onPopInvokedWithResult(bool didPop, Object? result) async {
    lastEvent = 'onPopInvokedWithResult didPop=$didPop result=$result';
    setState(() {});
    DLog.d('onPopInvokedWithResult: $didPop, $result');
    await showAlert();
  }

  void onPopInvoked(bool didPop) {
    lastEvent = 'onPopInvoked didPop=$didPop';
    setState(() {});
    DLog.d('onPopInvoked: $didPop');
  }

  Future<void> showAlert() async {
    final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('确认'),
            content: const Text('你确定要离开这个页面吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('确定'),
              ),
            ],
          ),
        ) ??
        false;
    DLog.d('shouldPop: $shouldPop');
    if (!mounted || !shouldPop) {
      return;
    }
    Navigator.of(context).pop({'a': '999'});
  }

  void onCanPop(bool value) {
    canPop = value;
    setState(() {});
  }

  void onCallbackKind(_PopCallbackKind value) {
    callbackKind = value;
    lastEvent = '—';
    setState(() {});
  }

  void onMaybePop() {
    Navigator.of(context).maybePop();
  }

  void onReset() {
    canPop = false;
    callbackKind = _PopCallbackKind.withResult;
    lastEvent = '—';
    setState(() {});
  }
}
