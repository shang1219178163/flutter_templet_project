import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

import 'package:flutter_templet_project/vendor/flutter_pickers/flutter_picker_util.dart';
import 'package:get/get.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class FlutterPickerUtilDemo extends StatefulWidget {
  const FlutterPickerUtilDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<FlutterPickerUtilDemo> createState() => _FlutterPickerUtilDemoState();
}

class _FlutterPickerUtilDemoState extends State<FlutterPickerUtilDemo> {
  bool get hideApp => Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  late final items = [
    (name: "选择地区", action: showAddressChoice),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Text("$widget"),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: items.map((e) {
                return OutlinedButton(
                  onPressed: e.action,
                  child: NText(e.name),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }

  String initProvince = '', initCity = '', initTown = '';

  void showAddressChoice() {
    FocusScope.of(context).unfocus();
    FlutterPickerUtil.showAddressPicker(
      title: '选择地区',
      initProvince: initProvince,
      initCity: initCity,
      initTown: initTown,
      confirm: (e) {
        // DLog.d(e.toJson());
        DLog.d(e);
      },
    );
  }
}
