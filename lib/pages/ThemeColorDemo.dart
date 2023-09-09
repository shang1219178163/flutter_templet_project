

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/basicWidget/header.dart';
import 'package:tuple/tuple.dart';

/// scaffoldBackgroundColor 背景色
/// dialogBackgroundColor 弹窗背景色
/// surface 表面颜色(背景色), onSurface 文字颜色
///
///


class ThemeColorDemo extends StatefulWidget {

  ThemeColorDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _ThemeColorDemoState createState() => _ThemeColorDemoState();
}

class _ThemeColorDemoState extends State<ThemeColorDemo> {


  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    late final items = <Tuple2<String, Color>>[
      Tuple2("canvasColor", themeData.canvasColor,),
      Tuple2("cardColor", themeData.cardColor,),
      Tuple2("dialogBackgroundColor", themeData.dialogBackgroundColor,),
      Tuple2("disabledColor", themeData.disabledColor,),
      Tuple2("dividerColor", themeData.dividerColor,),
      Tuple2("focusColor", themeData.focusColor,),
      Tuple2("highlightColor", themeData.highlightColor,),
      Tuple2("hintColor", themeData.hintColor,),
      Tuple2("hoverColor", themeData.hoverColor,),
      Tuple2("indicatorColor", themeData.indicatorColor,),
      Tuple2("primaryColor", themeData.primaryColor,),
      Tuple2("primaryColorDark", themeData.primaryColorDark,),
      Tuple2("primaryColorLight", themeData.primaryColorLight,),
      Tuple2("scaffoldBackgroundColor", themeData.scaffoldBackgroundColor,),
      Tuple2("secondaryHeaderColor", themeData.secondaryHeaderColor,),
      Tuple2("shadowColor", themeData.shadowColor,),
      Tuple2("splashColor", themeData.splashColor,),
      Tuple2("unselectedWidgetColor", themeData.unselectedWidgetColor,),
    ];

    late final colorScheme = themeData.colorScheme;

    late final colorSchemeItems = <Tuple2<String, Color>>[
      Tuple2("primaryColor", colorScheme.primary,),
      Tuple2("onPrimary", colorScheme.onPrimary,),
      Tuple2("primaryContainer", colorScheme.primaryContainer,),
      Tuple2("onPrimaryContainer", colorScheme.onPrimaryContainer,),
      Tuple2("secondary", colorScheme.secondary,),
      Tuple2("onSecondary", colorScheme.onSecondary,),
      Tuple2("secondaryContainer", colorScheme.secondaryContainer,),
      Tuple2("onSecondaryContainer", colorScheme.onSecondaryContainer,),
      Tuple2("tertiary", colorScheme.tertiary,),
      Tuple2("onTertiary", colorScheme.onTertiary,),
      Tuple2("tertiaryContainer", colorScheme.tertiaryContainer,),
      Tuple2("onTertiaryContainer", colorScheme.onTertiaryContainer,),
      Tuple2("error", colorScheme.error,),
      Tuple2("onError", colorScheme.onError,),
      Tuple2("errorContainer", colorScheme.errorContainer,),
      Tuple2("onErrorContainer", colorScheme.onErrorContainer,),
      Tuple2("background", colorScheme.background,),
      Tuple2("onBackground", colorScheme.onBackground,),
      Tuple2("surface", colorScheme.surface,),
      Tuple2("onSurface", colorScheme.onSurface,),
      Tuple2("surfaceVariant", colorScheme.surfaceVariant,),
      Tuple2("onSurfaceVariant", colorScheme.onSurfaceVariant,),
      Tuple2("outline", colorScheme.outline,),
      Tuple2("outlineVariant", colorScheme.outlineVariant,),
      Tuple2("shadow", colorScheme.shadow,),
      Tuple2("scrim", colorScheme.scrim,),
      Tuple2("inverseSurface", colorScheme.inverseSurface,),
      Tuple2("onInverseSurface", colorScheme.onInverseSurface,),
      Tuple2("inversePrimary", colorScheme.inversePrimary,),
      Tuple2("surfaceTint", colorScheme.surfaceTint,),
    ];


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['change',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            APPThemeService().changeTheme();
          },
        )).toList(),
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
            Header.h4(title: "Theme.of(context)",),
            buildBox(items),
            Divider(color: Colors.red, thickness: 3,),
            Header.h4(title: "Theme.of(context).colorScheme",),
            buildBox(colorSchemeItems),
          ],
        ),
      ),
    );
  }

  Widget buildBox(List<Tuple2<String, Color>> items) {
    return LayoutBuilder(
      builder: (context, constraints){

        final itemW = constraints.maxWidth/2;
        return Wrap(
          children: items.map((e) {
            final name = e.item2.toString()
                .replaceAll('MaterialColor(primary value:', '')
                .replaceAll('MaterialAccentColor(primary value:', '')
                .replaceAll('))', ')');

            return Container(
              width: itemW.truncateToDouble(),
              padding: EdgeInsets.all(8),
              color: e.item2,
              child: Text("${e.item1}\n(${name})",
                style: TextStyle(color: Colors.green, fontSize: 14),
              ),
              // child: Text("${e.item1}\n(${e.item2.toString().replaceAll("MaterialAccentColor(primary Value:", "")})",
              //   style: TextStyle(color: Colors.green, fontSize: 14),
              // ),
            );
          }).toList(),
        );
      }
    );
  }

}