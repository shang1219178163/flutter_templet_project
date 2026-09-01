//
//  NListItemDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2026/9/1.
//  Copyright © 2026/9/1 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/image/n_cached_network_image.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:flutter_templet_project/util/snack_util.dart';
import 'package:get/get.dart';

/// Gallery 行预设
enum _GalleryKind {
  plain(
    title: 'Title',
    subtitle: null,
    accessory: null,
  ),
  withSubtitle(
    title: 'Title + Subtitle',
    subtitle: 'Subtitle',
    accessory: null,
  ),
  withAccessory(
    title: 'Title + Accessory',
    subtitle: null,
    accessory: Icon(Icons.info_outline),
  ),
  both(
    title: 'Title + Subtitle + Accessory',
    subtitle: 'Subtitle',
    accessory: Icon(Icons.info_outline),
  );

  const _GalleryKind({
    required this.title,
    required this.subtitle,
    required this.accessory,
  });
  final String title;
  final String? subtitle;
  final Widget? accessory;
}

class NListItemDemo extends StatefulWidget {
  const NListItemDemo({super.key, this.title});

  final String? title;

  @override
  State<NListItemDemo> createState() => _NListItemDemoState();
}

class _NListItemDemoState extends State<NListItemDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  late final theme = Theme.of(context);

  final scrollController = ScrollController();

  double spacing = 8;
  bool usePadding = false;
  double padH = 16;
  double padV = 11;
  String lastEvent = '—';

  final _random = Random();
  late final List<String> _galleryUrls = List.generate(
    _GalleryKind.values.length,
    (_) => AppRes.image.urls[_random.nextInt(AppRes.image.urls.length)],
  );

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
              title: Text(widget.title ?? '$widget'),
              actions: [
                TextButton(
                  onPressed: onReset,
                  child: Text('重置', style: TextStyle(color: scheme.onPrimary)),
                ),
              ],
            ),
      body: ColoredBox(
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
                        title: {NLangEnum.en: 'Description', NLangEnum.zh: '说明'},
                        subtitle: {
                          NLangEnum.en: 'Widget NListItem',
                          NLangEnum.zh: '组件 NListItem',
                        },
                        items: [
                          {
                            NLangEnum.en:
                                'Gallery of NListItem variants. Adjust padding and spacing below. trailing null → default chevron.',
                            NLangEnum.zh: 'Gallery 展示 NListItem 变体。可调 padding、spacing。trailing 为 null 时用默认 chevron。',
                          },
                        ],
                      ),
                      buildSurfaceCard(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: buildGallery(),
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

  Widget buildGallery() {
    final kinds = _GalleryKind.values;
    final padding = usePadding
        ? EdgeInsets.symmetric(horizontal: padH, vertical: padV)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 11);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < kinds.length; i++) ...[
            NListItem(
              title: Text(kinds[i].title),
              subtitle: kinds[i].subtitle == null ? null : Text(kinds[i].subtitle!),
              leading: _leadingImage(i),
              accessory: IconTheme(
                data: IconThemeData(color: theme.colorScheme.primary),
                child: kinds[i].accessory ?? SizedBox(),
              ),
              padding: padding,
              spacing: spacing,
              onTap: () => onMark('onTap ${kinds[i].title}'),
            ),
            if (i < kinds.length - 1) const Divider(height: 1, indent: 68),
          ],
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(CupertinoIcons.rectangle),
      title: '表面',
      subtitle: 'padding · spacing',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NSwitchListItem(
            title: const Text('padding'),
            value: usePadding,
            onChanged: (v) => onMark('padding ${v ? 'custom' : 'default'}', () => usePadding = v),
          ),
          if (usePadding) ...[
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('padding.horizontal'),
              min: 0,
              max: 32,
              value: padH.clamp(0, 32),
              onChanged: (v) => onMark('padH ${v.round()}', () => padH = v),
              activeColor: theme.colorScheme.primary,
            ),
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('padding.vertical'),
              min: 0,
              max: 24,
              value: padV.clamp(0, 24),
              onChanged: (v) => onMark('padV ${v.round()}', () => padV = v),
              activeColor: theme.colorScheme.primary,
            ),
          ],
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('spacing'),
            min: 0,
            max: 24,
            value: spacing.clamp(0, 24),
            onChanged: (v) => onMark('spacing ${v.round()}', () => spacing = v),
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _leadingImage(int index) {
    return NCachedNetworkImage(
      imageUrl: _galleryUrls[index],
      placeholderImage: AssetImage(Assets.imagesAvatarMale),
      width: 40,
      height: 40,
      fit: BoxFit.cover,
      radius: 8,
    );
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    SnackUtil.show(event);
    setState(() {});
  }

  void onReset() {
    spacing = 8;
    usePadding = false;
    padH = 16;
    padV = 11;
    lastEvent = '—';
    for (var i = 0; i < _galleryUrls.length; i++) {
      _galleryUrls[i] = AppRes.image.urls[_random.nextInt(AppRes.image.urls.length)];
    }
    setState(() {});
  }
}
