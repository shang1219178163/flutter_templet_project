//
//  ThemeColorSchemePage.dart
//  flutter_templet_project
//
//  Created by shang on 2026/6/15 18:15.
//  Copyright © 2026/6/15 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_seed_color_box.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/theme/AppThemeService.dart';
import 'package:get/get.dart';

class ThemeColorSchemePage extends StatefulWidget {
  const ThemeColorSchemePage({super.key});

  @override
  State<ThemeColorSchemePage> createState() => _ThemeColorSchemePageState();
}

class _ThemeColorSchemePageState extends State<ThemeColorSchemePage> with SeedColorMixin {
  final colors = <Color>[
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.cyan,
    Colors.deepPurple,
    Colors.lime,
    Colors.amber,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ColorScheme 配色'),
        actions: [
          IconButton(
            icon: Icon(Icons.color_lens),
            onPressed: () async {
              await AppThemeService().showSeedColorPicker(context: context);
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () async {
              AppThemeService().toggleTheme();
            },
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;
    final currIndex = colors.indexOf(primary).clamp(0, colors.length - 1);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 配色方案展示
          buildColorSchemeDisplay(colorScheme),
          buildCustomMatchColors(),
        ],
      ),
    );
  }

  Widget buildColorSchemeDisplay(ColorScheme colorScheme) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.black : Color(0xFFF2F4ED);
    final goldColor = Color(0xFFFFD700);
    return Card(
      color: cardColor,
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '配色方案详情',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            // 主要颜色
            buildColorItem('primary', colorScheme.primary, colorScheme.onPrimary),
            buildColorItem('onPrimary', colorScheme.onPrimary, colorScheme.primary),
            buildColorItem('primaryContainer', colorScheme.primaryContainer, colorScheme.onPrimaryContainer),
            buildColorItem('onPrimaryContainer', colorScheme.onPrimaryContainer, colorScheme.primaryContainer),

            // 次要颜色
            buildColorItem('secondary', colorScheme.secondary, colorScheme.onSecondary),
            buildColorItem('onSecondary', colorScheme.onSecondary, colorScheme.secondary),
            buildColorItem('secondaryContainer', colorScheme.secondaryContainer, colorScheme.onSecondaryContainer),
            buildColorItem('onSecondaryContainer', colorScheme.onSecondaryContainer, goldColor),

            // 三级颜色
            buildColorItem('tertiary', colorScheme.tertiary, colorScheme.onTertiary),
            buildColorItem('onTertiary', colorScheme.onTertiary, colorScheme.tertiary),
            buildColorItem('tertiaryContainer', colorScheme.tertiaryContainer, colorScheme.onTertiaryContainer),
            buildColorItem('onTertiaryContainer', colorScheme.onTertiaryContainer, colorScheme.tertiaryContainer),

            // 表面颜色
            buildColorItem('surface', colorScheme.surface, colorScheme.onSurface),
            buildColorItem('onSurface', colorScheme.onSurface, colorScheme.surface),
            buildColorItem(
                'surfaceContainerHighest', colorScheme.surfaceContainerHighest, colorScheme.onSurfaceVariant),
            buildColorItem('onSurfaceVariant', colorScheme.onSurfaceVariant, colorScheme.surfaceContainerHighest),

            // 背景颜色
            // buildColorItem('background', colorScheme.background, colorScheme.onBackground),
            // buildColorItem('onBackground', colorScheme.onBackground, colorScheme.background),

            // 错误颜色
            buildColorItem('error', colorScheme.error, colorScheme.onError),
            buildColorItem('onError', colorScheme.onError, colorScheme.error),
            buildColorItem('errorContainer', colorScheme.errorContainer, colorScheme.onErrorContainer),
            buildColorItem('onErrorContainer', colorScheme.onErrorContainer, colorScheme.errorContainer),

            // 轮廓颜色
            buildColorItem('outline', colorScheme.outline, colorScheme.surface),
            buildColorItem('outlineVariant', colorScheme.outlineVariant, colorScheme.surface),

            // 反转表面颜色
            buildColorItem('inverseSurface', colorScheme.inverseSurface, colorScheme.onInverseSurface),
            buildColorItem('onInverseSurface', colorScheme.onInverseSurface, colorScheme.inverseSurface),

            // 主要颜色反转
            buildColorItem('inversePrimary', colorScheme.inversePrimary, goldColor),

            // 阴影颜色
            buildColorItem('shadow', colorScheme.shadow, Colors.white),

            // 表面色调颜色
            buildColorItem('surfaceTint', colorScheme.surfaceTint, Colors.white),
          ],
        ),
      ),
    );
  }

  Widget buildColorItem(String name, Color bgColor, Color textColor) {
    final bgColorHex = '#${bgColor.argbInt.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    final textColorHex = '#${textColor.argbInt.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    final desc = [bgColorHex, textColorHex].join(", ");

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Flex(
        direction: Axis.horizontal,
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              name,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            desc,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCustomMatchColors() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.black : Color(0xFFF2F4ED);
    return Card(
      color: cardColor,
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '自定义配色对比',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                buildItem(
                  color: Color(0xFF121212),
                  textColor: context.themeData.colorScheme.primary,
                ),
                buildItem(
                  color: Color(0xFF181818),
                  textColor: context.themeData.colorScheme.primary,
                ),
                buildItem(
                  color: Color(0xFF242424),
                  textColor: context.themeData.colorScheme.primary,
                ),
                buildItem(
                  color: Color(0xFFF6F6F6),
                  textColor: context.themeData.colorScheme.primary,
                ),
                buildItem(
                  color: Color(0xFFFFFFFF),
                  textColor: context.themeData.colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem({required Color color, required Color textColor}) {
    final desc = color.toHex();
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Text(
        desc,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
