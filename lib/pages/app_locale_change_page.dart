import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/main.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:get/get.dart';

class AppLocaleChangePage extends StatefulWidget {
  const AppLocaleChangePage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<AppLocaleChangePage> createState() => _AppLocaleChangePageState();
}

class _AppLocaleChangePageState extends State<AppLocaleChangePage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant AppLocaleChangePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
              actions: [
                'done',
              ]
                  .map((e) => TextButton(
                        child: Text(
                          e,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => debugPrint(e),
                      ))
                  .toList(),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return ListView.separated(
      itemBuilder: (context, index) {
        if (index == 0) {
          final textStyle = TextStyle(
            fontSize: 12,
          );
          return Container(
            child: Column(
              children: [
                Text('money'.plural(10), style: textStyle), // 显示 "10 dollars"
                Text('money'.plural(1), style: textStyle), // 显示 "one dollar"
                Text('money'.plural(0), style: textStyle), // 显示 "no money"

                Text(
                    'money'.plural(
                      10.23,
                      namedArgs: {'name': 'Jane'},
                    ),
                    style: textStyle), // 显示 "no money"
              ],
            ),
          );
        }

        final e = context.supportedLocales[index - 1];
        final isSelected = e == context.locale;
        return ListTile(
          onTap: () async {
            await context.setLocale(e);
            Get.updateLocale(e);
          },
          title: Text(e.languageCode),
          trailing: Icon(
            Icons.check,
            color: isSelected ? context.primaryColor : Colors.transparent,
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(height: 1, color: lineColor);
      },
      itemCount: context.supportedLocales.length + 1,
    );
  }

  Widget buildBody1() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            ...context.supportedLocales.map((e) => ListTile(
                  title: Text(e.languageCode),
                )),
            // Text(context.locale.languageCode),
          ],
        ),
      ),
    );
  }
}
