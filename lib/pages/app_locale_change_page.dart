import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/main.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart' hide Trans;

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
              title: Text("多语言"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: ListView.separated(
        itemBuilder: (context, index) {
          if (index == 0) {
            final textStyle = TextStyle(
              fontSize: 12,
            );
            return Container(
              child: Column(
                children: [
                  Text('language'.tr(), style: textStyle),
                  Text(
                      'money'.plural(
                        0,
                        namedArgs: {
                          'name': 'Jane',
                        },
                      ),
                      style: textStyle),
                  Text(
                      plural(
                        'money',
                        10.23,
                        namedArgs: {'name': 'Jane', 'money': '10.23'},
                      ),
                      style: textStyle),
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
          return Divider(height: 1, color: AppColor.lineColor);
        },
        itemCount: context.supportedLocales.length + 1,
      ),
    );
  }
}
