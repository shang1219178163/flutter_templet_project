//
//  WillPopScopeDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/25/21 2:48 PM.
//  Copyright © 10/25/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// onWillPop 传值
enum _OnWillPopKind {
  nullable(label: 'null', allow: null),
  deny(label: 'false', allow: false),
  allowPop(label: 'true', allow: true);
  const _OnWillPopKind({required this.label, required this.allow});
  final String label;
  final bool? allow;
}

class WillPopScopeDemo extends StatefulWidget {
  const WillPopScopeDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<WillPopScopeDemo> createState() => _WillPopScopeDemoState();
}

class _WillPopScopeDemoState extends State<WillPopScopeDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  late final theme = Theme.of(context);

  final scrollController = ScrollController();

  /// onWillPop 为 null 时可直接返回（原 Demo enable = true）
  _OnWillPopKind onWillPopKind = _OnWillPopKind.nullable;
  String lastEvent = '—';

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: onWillPopKind.allow == null ? null : onWillPop,
      child: Scaffold(
        appBar: hideApp
            ? null
            : AppBar(
                title: Text(widget.title ?? "$widget"),
                centerTitle: true,
                elevation: 0,
                scrolledUnderElevation: 0,
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
                        NLangEnum.en: 'Widget WillPopScope',
                        NLangEnum.zh: '组件 WillPopScope',
                      },
                      items: [
                        {
                          NLangEnum.en: 'WillPopScope only has child and onWillPop.',
                          NLangEnum.zh: 'WillPopScope 只有 child 与 onWillPop 两个参数。',
                        },
                        {
                          NLangEnum.en: 'onWillPop null allows the route to pop. false vetoes; true allows.',
                          NLangEnum.zh: 'onWillPop 为 null 可直接返回；返回 false 拦截，true 放行。',
                        },
                        {
                          NLangEnum.en: 'Press system back or maybePop to see the callback.',
                          NLangEnum.zh: '按系统返回或点击 maybePop 查看回调。',
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
              'WillPopScope 拦截系统返回',
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
      subtitle: 'onWillPop',
      child: NChoiceChipListItem<_OnWillPopKind>(
        title: const Text('onWillPop'),
        values: _OnWillPopKind.values,
        value: onWillPopKind,
        labelOf: (e) => e.label,
        onChanged: onOnWillPopKind,
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_rounded),
      title: '行为',
      subtitle: 'Navigator.maybePop',
      child: Text(
        onWillPopKind.allow == null
            ? 'onWillPop 为 null，系统返回会直接出栈。'
            : 'onWillPop 会先弹确认框，再返回 ${onWillPopKind.allow}。',
        style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontSize: 13.5,
            ),
      ),
    );
  }

  Future<bool> onWillPop() async {
    lastEvent = 'onWillPop → ${onWillPopKind.allow}';
    setState(() {});
    DLog.d('onWillPop');
    await showAlert();
    return onWillPopKind.allow!;
  }

  Future<bool> showAlert({String message = ''}) async {
    final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('确认'),
              content: Text('你确定要离开这个页面吗？$message'),
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
            );
          },
        ) ??
        false;
    return shouldPop;
  }

  void onOnWillPopKind(_OnWillPopKind value) {
    onWillPopKind = value;
    lastEvent = '—';
    setState(() {});
  }

  void onMaybePop() {
    Navigator.of(context).maybePop();
  }

  void onReset() {
    onWillPopKind = _OnWillPopKind.nullable;
    lastEvent = '—';
    setState(() {});
  }
}
