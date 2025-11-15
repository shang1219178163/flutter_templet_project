import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/util/theme/AppThemeService.dart';

/// scaffoldBackgroundColor 背景色
/// dialogBackgroundColor 弹窗背景色
/// surface 表面颜色(背景色), onSurface 文字颜色
///
///

class ThemeColorDemo extends StatefulWidget {
  ThemeColorDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ThemeColorDemoState createState() => _ThemeColorDemoState();
}

class _ThemeColorDemoState extends State<ThemeColorDemo> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    late final items = <Tuple2<String, Color>>[
      Tuple2(
        "canvasColor",
        themeData.canvasColor,
      ),
      Tuple2(
        "cardColor",
        themeData.cardColor,
      ),
      Tuple2(
        "dialogBackgroundColor",
        themeData.dialogBackgroundColor,
      ),
      Tuple2(
        "disabledColor",
        themeData.disabledColor,
      ),
      Tuple2(
        "dividerColor",
        themeData.dividerColor,
      ),
      Tuple2(
        "focusColor",
        themeData.focusColor,
      ),
      Tuple2(
        "highlightColor",
        themeData.highlightColor,
      ),
      Tuple2(
        "hintColor",
        themeData.hintColor,
      ),
      Tuple2(
        "hoverColor",
        themeData.hoverColor,
      ),
      Tuple2(
        "indicatorColor",
        themeData.indicatorColor,
      ),
      Tuple2(
        "primaryColor",
        themeData.primaryColor,
      ),
      Tuple2(
        "primaryColorDark",
        themeData.primaryColorDark,
      ),
      Tuple2(
        "primaryColorLight",
        themeData.primaryColorLight,
      ),
      Tuple2(
        "scaffoldBackgroundColor",
        themeData.scaffoldBackgroundColor,
      ),
      Tuple2(
        "secondaryHeaderColor",
        themeData.secondaryHeaderColor,
      ),
      Tuple2(
        "shadowColor",
        themeData.shadowColor,
      ),
      Tuple2(
        "splashColor",
        themeData.splashColor,
      ),
      Tuple2(
        "unselectedWidgetColor",
        themeData.unselectedWidgetColor,
      ),
    ];

    late final colorScheme = themeData.colorScheme;

    late final colorSchemeItems = <Tuple2<String, Color>>[
      Tuple2(
        "primaryColor",
        colorScheme.primary,
      ),
      Tuple2(
        "onPrimary",
        colorScheme.onPrimary,
      ),
      Tuple2(
        "primaryContainer",
        colorScheme.primaryContainer,
      ),
      Tuple2(
        "onPrimaryContainer",
        colorScheme.onPrimaryContainer,
      ),
      Tuple2(
        "secondary",
        colorScheme.secondary,
      ),
      Tuple2(
        "onSecondary",
        colorScheme.onSecondary,
      ),
      Tuple2(
        "secondaryContainer",
        colorScheme.secondaryContainer,
      ),
      Tuple2(
        "onSecondaryContainer",
        colorScheme.onSecondaryContainer,
      ),
      Tuple2(
        "tertiary",
        colorScheme.tertiary,
      ),
      Tuple2(
        "onTertiary",
        colorScheme.onTertiary,
      ),
      Tuple2(
        "tertiaryContainer",
        colorScheme.tertiaryContainer,
      ),
      Tuple2(
        "onTertiaryContainer",
        colorScheme.onTertiaryContainer,
      ),
      Tuple2(
        "error",
        colorScheme.error,
      ),
      Tuple2(
        "onError",
        colorScheme.onError,
      ),
      Tuple2(
        "errorContainer",
        colorScheme.errorContainer,
      ),
      Tuple2(
        "onErrorContainer",
        colorScheme.onErrorContainer,
      ),
      Tuple2(
        "background",
        colorScheme.surface,
      ),
      Tuple2(
        "onBackground",
        colorScheme.onSurface,
      ),
      Tuple2(
        "surface",
        colorScheme.surface,
      ),
      Tuple2(
        "onSurface",
        colorScheme.onSurface,
      ),
      Tuple2(
        "surfaceVariant",
        colorScheme.surfaceContainerHighest,
      ),
      Tuple2(
        "onSurfaceVariant",
        colorScheme.onSurfaceVariant,
      ),
      Tuple2(
        "outline",
        colorScheme.outline,
      ),
      Tuple2(
        "outlineVariant",
        colorScheme.outlineVariant,
      ),
      Tuple2(
        "shadow",
        colorScheme.shadow,
      ),
      Tuple2(
        "scrim",
        colorScheme.scrim,
      ),
      Tuple2(
        "inverseSurface",
        colorScheme.inverseSurface,
      ),
      Tuple2(
        "onInverseSurface",
        colorScheme.onInverseSurface,
      ),
      Tuple2(
        "inversePrimary",
        colorScheme.inversePrimary,
      ),
      Tuple2(
        "surfaceTint",
        colorScheme.surfaceTint,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          Icon(Icons.change_circle_outlined),
        ]
            .map((e) => IconButton(
                  icon: e,
                  onPressed: () {
                    AppThemeService().toggleTheme();
                  },
                ))
            .toList(),
      ),
      body: buildBody(items: items, colorSchemeItems: colorSchemeItems),
      // floatingActionButton: FloatingActionButton(
      //   tooltip: 'Increment',
      //   onPressed: () {
      //     APPThemeService().changeTheme();
      //   },
      //   child: Icon(Icons.change_circle_outlined),
      // ),
    );
  }

  buildBody({
    required List<Tuple2<String, Color>> items,
    required List<Tuple2<String, Color>> colorSchemeItems,
  }) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   padding: EdgeInsets.all(8),
            //   color: Theme.of(context).scaffoldBackgroundColor,
            //   child: Text("scaffoldBackgroundColor(${Theme.of(context).scaffoldBackgroundColor})",
            //     style: TextStyle(color: Colors.green,),
            //   )
            // ),
            NSectionBox(
              title: "Theme.of(context)",
              child: buildBox(items: items),
            ),
            NSectionBox(
              title: "Theme.of(context).colorScheme",
              child: buildBox(items: colorSchemeItems),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBox({
    required List<Tuple2<String, Color>> items,
    int rowCount = 3,
    double spacing = 8,
    double runSpacing = 8,
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      final itemWidth = ((constraints.maxWidth - spacing * (rowCount - 1)) / rowCount).truncateToDouble();

      return Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: items.map((e) {
          final name = e.item2
              .toString()
              .replaceAll('MaterialColor(primary value:', '')
              .replaceAll('MaterialAccentColor(primary value:', '')
              .replaceAll('))', ')');

          return Container(
            width: itemWidth,
            padding: EdgeInsets.all(8),
            color: e.item2,
            child: Text(
              "${e.item1}\n($name)",
              style: TextStyle(color: Colors.green, fontSize: 14),
            ),
          );
        }).toList(),
      );
    });
  }
}
