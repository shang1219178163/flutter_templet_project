import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/cache/file_manager.dart';
import 'package:flutter_templet_project/extension/clipboard_ext.dart';
import 'package:flutter_templet_project/extension/snack_bar_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/pages/demo/ApiCreateTemplet.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/model_generator.dart';

class ApiCreatePage extends StatefulWidget {
  ApiCreatePage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ApiCreatePage> createState() => _ApiCreatePageState();
}

class _ApiCreatePageState extends State<ApiCreatePage> {
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  var rootClassNameStr = "Root";
  var classPrefix = "YY";
  var classSuffix = "Model";

  late final _nameController = TextEditingController(text: rootClassNameStr);
  late final _prefixController = TextEditingController(text: classPrefix);
  late final _suffixController = TextEditingController(text: classSuffix);

  final _scrollController = ScrollController();

  var jsonStr = "";
  final outVN = ValueNotifier("");

  final appSchemes = [
    "yl_health_app",
    "yl_health_manage_app",
    "yl_patient_app",
  ];

  late var appScheme = appSchemes[0];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$widget"), actions: [
        IconButton(
            onPressed: () {
              Get.bottomSheet(Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NText(
                      "1. 所有对象不能为空(零属性)",
                    ),
                  ],
                ),
              ));
            },
            icon: Icon(Icons.warning_amber_rounded)),
      ]),
      body: buildBody(),
    );
  }

  buildBody() {
    return Container(
      child: LayoutBuilder(builder: (context, constraints) {
        final direction =
            constraints.maxWidth > 500 ? Axis.horizontal : Axis.vertical;
        if (direction == Axis.horizontal) {
          return buildBodyHorizontal(constraints: constraints);
        }
        return buildBodyVertical(constraints: constraints);
      }),
    );
  }

  buildBodyVertical(
      {double spacing = 10, required BoxConstraints constraints}) {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.all(spacing * 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTop(),
              Container(
                height: constraints.maxHeight * 0.7,
                child: buildLeft(isVertical: true),
              ),
              SizedBox(
                height: spacing * 3,
              ),
              Container(
                child: buildRight(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildBodyHorizontal(
      {double spacing = 10, required BoxConstraints constraints}) {
    return Container(
      padding: EdgeInsets.all(spacing * 3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTop(),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildLeft(),
                SizedBox(
                  width: spacing * 3,
                ),
                Expanded(
                  child: buildRight(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTop({
    bool isVertical = false,
    double spacing = 10,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NText(
          "文件名生成 api 文件",
          maxLines: 3,
        ),
        SizedBox(
          height: spacing * 2,
        ),
      ],
    );
  }

  Widget buildTextfield({
    hintText = "hintText",
    maxLines = 1,
    TextEditingController? controller,
    FocusNode? focusNode,
  }) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: EdgeInsets.all(12),
        hintText: hintText,
        hintStyle: TextStyle(
          color: const Color(0xff999999),
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
        fillColor: bgColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        counterText: '',
      ),
      onChanged: (val) async {
        // debugPrint("onChanged: $val");
      },
      onSubmitted: (val) {
        debugPrint("onSubmitted: $val");
      },
      onEditingComplete: () {
        debugPrint("onEditingComplete: ");
      },
      // onTap: (){
      //   debugPrint("onTap: ${controller?.value.text}");
      // },
      // onTapOutside: (e){
      //   debugPrint("onTapOutside: $e ${controller?.value.text}");
      // },
    );
  }

  Widget buildLeft({
    bool isVertical = false,
    double spacing = 10,
    double maxWidth = 400,
  }) {
    double? maxWidth = isVertical ? double.maxFinite : 300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: maxWidth,
            child: buildTextfield(
              controller: _textEditingController,
              focusNode: _focusNode,
              maxLines: 200,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: spacing),
          child: NMenuAnchor<String>(
            values: appSchemes,
            initialItem: appScheme,
            onChanged: (val) {
              appScheme = val;
            },
            cbName: (e) => e ?? "请选择",
            equal: (a, b) => a == b,
          ),
        ),
        Row(
          children: [
            ElevatedButton(
              // style: ElevatedButton.styleFrom(
              //   elevation: 0,
              //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              // ),
              onPressed: onGenerate,
              child: NText("Generate Dart"),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: ElevatedButton(
                onPressed: onPaste,
                child: NText("Paste"),
              ),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                // minimumSize: Size(50, 18),
                shape: CircleBorder(),
              ),
              onPressed: onTry,
              child: NText(
                "try",
                color: Colors.black45,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: spacing),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black54,
            ),
            onPressed: () {
              debugPrint("copy");
              Clipboard.setData(ClipboardData(text: outVN.value));
            },
            child: NText("Copy Dart code to clipboard"),
          ),
        ),
      ],
    );
  }

  Widget buildRight({
    ScrollController? controller,
    double spacing = 10,
    bool selectable = true,
  }) {
    return ValueListenableBuilder<String>(
        valueListenable: outVN,
        builder: (context, value, child) {
          final child = selectable
              ? SelectableText(
                  value,
                  // maxLines: 1000,
                )
              : NText(
                  value,
                  // maxLines: 1000,
                );

          return Scrollbar(
            controller: controller,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: controller,
              child: child,
            ),
          );
        });
  }

  /// 生成模型文件
  toCreateDartFile({required String fileName}) async {
    try {
      _focusNode.unfocus();

      final className =
          fileName.contains("_") ? fileName.toCamlCase("_") : fileName;

      outVN.value = ApiCreateTemplet.createApi(
          appScheme: appScheme, className: className);
      // debugPrint("fileName: $fileName");

      /// 生成本地文件
      final file = await FileManager()
          .createFile(fileName: fileName, content: outVN.value);
      debugPrint("file: ${file.path}");

      showSnackBar(SnackBar(
        content: NText(
          "文件已生成(下载文件夹)",
          color: Colors.white,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      debugPrint("catch: $e");
      Get.bottomSheet(Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NText(
              e.toString(),
            ),
          ],
        ),
      ));
    }
  }

  onGenerate() async {
    if (_textEditingController.text.isEmpty) {
      var data = await Clipboard.getData("text/plain");
      final dateStr = data?.text ?? "";
      if (dateStr.isNotEmpty) {
        _textEditingController.text = dateStr;
      }
    }
    try {
      toCreateDartFiles();
    } catch (e) {
      debugPrint("catch: $e");
      Get.bottomSheet(Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NText(
              e.toString(),
            ),
          ],
        ),
      ));
    }

    //{ "name": "John Smith", "age": 30, "city": "New York"\ }
  }

  Future<String> loadData() async {
    final response = await rootBundle.loadString('assets/data/appInfo.json');
    return response;
  }

  onClear() {
    _textEditingController.text = "";
  }

  onPaste() async {
    _textEditingController.text = await ClipboardExt.paste();
  }

  onTry() async {
    _textEditingController.text = "health_management_add_group_status";
    toCreateDartFiles();
  }

  toCreateDartFiles() async {
    final fileNames = _textEditingController.text.split("\n");
    for (var i = 0; i < fileNames.length; i++) {
      final fileName = fileNames[i];
      await toCreateDartFile(fileName: fileName);
    }
  }

  onPressed() {
    // var tmp = "{ 'name': 'John Smith', 'age': 30, 'city': 'New York',}>";
    // // tmp = "atogeneratedBCDE";
    // var str = tmp.toUnderScoreCase();
    // debugPrint("str: $str");
    // var str1 = str.toUncamlCase();
    // debugPrint("str1: $str1");
    onGenerate();
  }
}
