
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/snack_bar_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/uti/color_util.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/model_generator.dart';

import 'package:path_provider/path_provider.dart';


class JsonToDartPage extends StatefulWidget {

  JsonToDartPage({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _JsonToDartPageState createState() => _JsonToDartPageState();
}

class _JsonToDartPageState extends State<JsonToDartPage> {

  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();


  var rootClassNameStr = "Autogenerated";
  late final _classEditingController = TextEditingController(text: rootClassNameStr);

  final _scrollController = ScrollController();

  var jsonStr = "";
  final outVN = ValueNotifier("");


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        // actions: ['done',].map((e) => TextButton(
        //   child: Text(e,
        //     style: TextStyle(color: Colors.white),
        //   ),
        //   onPressed: onPressed)
        // ).toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Container(
      child: LayoutBuilder(
        builder: (context, constraints) {

          final direction = constraints.maxWidth > 500 ? Axis.horizontal : Axis.vertical;
          if (direction == Axis.horizontal) {
            return buildBodyHorizontal();
          }
          return buildBodyVertical();
        }
      ),
    );
  }

  buildBodyVertical({double spacing = 10,}) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(spacing*3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTop(),
              Container(
                height: 500,
                child: buildLeft(isVertical: true),
              ),
              SizedBox(height: spacing*3,),
              Container(
                child: buildRight(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildBodyHorizontal({double spacing = 10,}) {
    return Container(
      padding: EdgeInsets.all(spacing*3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTop(),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildLeft(),
                SizedBox(width: spacing*3,),
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
        NText("JSON to Dart",
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: spacing,),
        NText("Paste your JSON in the textarea below, click convert and get your Dart classes for free.",
          maxLines: 3,
        ),
        SizedBox(height: spacing*2,),
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
      onChanged: (val) async{
        // debugPrint("onChanged: $val");
      },
      onSubmitted: (val){
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
              maxLines: 20,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: spacing),
          width: maxWidth,
          child: buildTextfield(
            controller: _classEditingController,
            hintText: rootClassNameStr,
          ),
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: onGenerate,
              child: NText("Generate Dart"),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                // minimumSize: Size(50, 18),
                shape: CircleBorder(),
              ),
              onPressed: () async{
                final jsonStr = await loadData();
                _textEditingController.text = jsonStr;
                toCreateDartFile();
              },
              child: NText("try", color: Colors.black45,),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: spacing),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black54,
            ),
            onPressed: (){
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
      builder: (context,  value, child){

        final child = selectable ?
        SelectableText(value,
          // maxLines: 1000,
        ) : NText(value,
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
      }
    );
  }

  /// 转模型
  String convertModel({String rootClassName = "Autogenerated", required String val,}) {
    final classGenerator = ModelGenerator(rootClassName);
    var dartCode = classGenerator.generateDartClasses(val);
    // debugPrint("dartCode.code:${dartCode.code}");
    return dartCode.code;
  }
  /// 生成模型文件
  toCreateDartFile() async {
    _focusNode.unfocus();
    outVN.value = convertModel(
      val: _textEditingController.text,
      rootClassName: _classEditingController.text,
    );

    final fileName = _classEditingController.text.toUncamlCase();
    // debugPrint("fileName: $fileName");

    /// 生成本地文件
    final tempDir = await getDownloadsDirectory();
    var path = '${tempDir?.path}/$fileName.dart';
    var file = File(path);
    file.createSync();
    file.writeAsStringSync(outVN.value);

    showSnackBar(SnackBar(
      content: NText("文件已生成(下载文件夹)",
        color: Colors.white,
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.green,
    ));
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
      jsonDecode(_textEditingController.text);

      toCreateDartFile();
    } catch (e) {
      debugPrint("catch: $e");
      Get.bottomSheet(Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NText(e.toString(),),
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

extension StringExt on String{
  /// 驼峰转下划线
  String toUnderScoreCase() {
    var str = this;
    var items = str.split("");
    for (var i = 0; i < items.length; i++) {
      var char = items[i];
      final isUpper = char.contains(RegExp(r'[A-Z]'));
      // debugPrint("$char $isUpper");
      if (isUpper) {
        str = str.replaceFirst(char, "${i == 0 ? '' : '_'}${char.toLowerCase()}");
      }
    }
    return str;
  }
}

