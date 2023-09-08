

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/basicWidget/header.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tuple/tuple.dart';

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
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: () {
          APPThemeService().changeTheme();
        },
        child: Icon(Icons.change_circle_outlined),
      ),
    );
  }

  buildBody() {
    final items = <Tuple2<String, Color>>[
      Tuple2("canvasColor", Theme.of(context).canvasColor,),
      Tuple2("cardColor", Theme.of(context).cardColor,),
      Tuple2("dialogBackgroundColor", Theme.of(context).dialogBackgroundColor,),
      Tuple2("disabledColor", Theme.of(context).disabledColor,),
      Tuple2("dividerColor", Theme.of(context).dividerColor,),
      Tuple2("focusColor", Theme.of(context).focusColor,),
      Tuple2("highlightColor", Theme.of(context).highlightColor,),
      Tuple2("hintColor", Theme.of(context).hintColor,),
      Tuple2("hoverColor", Theme.of(context).hoverColor,),
      Tuple2("indicatorColor", Theme.of(context).indicatorColor,),
      Tuple2("primaryColor", Theme.of(context).primaryColor,),
      Tuple2("primaryColorDark", Theme.of(context).primaryColorDark,),
      Tuple2("primaryColorLight", Theme.of(context).primaryColorLight,),
      Tuple2("scaffoldBackgroundColor", Theme.of(context).scaffoldBackgroundColor,),
      Tuple2("secondaryHeaderColor", Theme.of(context).secondaryHeaderColor,),
      Tuple2("shadowColor", Theme.of(context).shadowColor,),
      Tuple2("splashColor", Theme.of(context).splashColor,),
      Tuple2("unselectedWidgetColor", Theme.of(context).unselectedWidgetColor,),
    ];

    final colorScheme = Theme.of(context).colorScheme;

    final colorSchemeItems = <Tuple2<String, Color>>[
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

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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

            return Container(
              width: itemW,
              padding: EdgeInsets.all(8),
              color: e.item2,
              child: Text("${e.item1}"),
            );
          }).toList(),
        );
      }
    );
  }

}