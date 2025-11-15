import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_page_view.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/cache/file_manager.dart';
import 'package:flutter_templet_project/extension/src/snack_bar_ext.dart';
import 'package:tuple/tuple.dart';

class IconConvertPage extends StatefulWidget {
  IconConvertPage({super.key, this.title});

  final String? title;

  @override
  State<IconConvertPage> createState() => _IconConvertPageState();
}

class _IconConvertPageState extends State<IconConvertPage> {
  final scrollController = ScrollController();
  final scrollController1 = ScrollController();
  final scrollController2 = ScrollController();
  final scrollController3 = ScrollController();

  final linesVN = ValueNotifier(<String>[]);
  final linesOneVN = ValueNotifier(<String>[]);
  final linesTwoVN = ValueNotifier(<String>[]);

  final linesThreeVN = ValueNotifier(<String>[]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  onPressed: onDone,
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: NPageView(
        items: [
          Tuple2(
              "全部",
              buildPage(
                items: linesVN,
                controller: scrollController,
                onConvert: convertToMapItem,
              )),
          Tuple2(
              "IconData get",
              buildPage(
                items: linesOneVN,
                controller: scrollController1,
                onConvert: convertToMapItem,
              )),
          Tuple2(
              "const IconData ",
              buildPage(
                items: linesTwoVN,
                controller: scrollController2,
                onConvert: convertToMapItem,
              )),
          Tuple2(
              "结果",
              buildPage(
                items: linesThreeVN,
                controller: scrollController3,
              )),
        ],
      ),
    );
  }

  Widget buildPage({
    required ValueNotifier<List<String>> items,
    required ScrollController controller,
    String Function(String e)? onConvert,
  }) {
    return Column(
      children: [
        Expanded(
          child: ValueListenableBuilder(
              valueListenable: items,
              builder: (context, list, child) {
                if (list.isEmpty) {
                  return Center(child: NPlaceholder());
                }

                return Scrollbar(
                  controller: controller,
                  child: ListView.builder(
                      controller: controller,
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        final e = list[i];

                        // final subtitle = convertToMapItem(e);
                        final subtitle = onConvert?.call(e) ?? "";

                        return Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NText(
                                  e,
                                  textAlign: TextAlign.start,
                                ),
                                if (subtitle.isNotEmpty)
                                  NText(
                                    subtitle,
                                    textAlign: TextAlign.start,
                                    color: Colors.black45,
                                  ),
                              ],
                            ));
                      }),
                );
              }),
        ),
      ],
    );
  }

  onDone() async {
    var lines = await readFile(path: '/Users/shang/fvm/versions/3.16.7/packages/flutter/lib/src/material/icons.dart');
    lines = lines.where((e) => e.contains("IconData get") || e.contains("const IconData ")).toList();
    linesVN.value = lines;

    linesOneVN.value = lines.where((e) => e.contains("IconData get")).toList();
    linesTwoVN.value = lines.where((e) => e.contains("const IconData ")).toList();
    debugPrint("$widget linesOneVN: ${linesOneVN.value.length},");
    debugPrint("$widget linesTwoVN: ${linesTwoVN.value.length},");

    linesThreeVN.value = lines.map((e) => convertToMapItem(e)).toList();
    debugPrint("$widget linesThreeVN: ${linesThreeVN.value.length},");

    final keyValues = linesThreeVN.value.map((e) => "\t$e\n").join("");
    createFile(fileName: "icons_map", content: """
import 'package:flutter/material.dart';
  
  
Map<String, IconData> kIConDic = {
  $keyValues
};
""");
  }

  Future<List<String>> readFile({required String path}) async {
    var contents = <String>[];
    try {
      final file = File(path);
      // Read the file
      contents = await file.readAsLines();
    } catch (e) {
      debugPrint("$widget catch: $e");
    }
    return contents;
  }

  String convertToMapItem(String e) {
    var result = "";

    var tmp = e.split(" ");
    if (e.contains("IconData get ")) {
      // if (e.contains("get_app")) {
      //   debugPrint("e: $e");
      // }
      tmp = tmp.sublist(2, 5);
      tmp.remove("get");

      final desc = "${tmp[0]}.${tmp[1]}";
      result = "'$desc': $desc,";
    } else if (e.contains("const IconData ")) {
      tmp = tmp.sublist(4, 6);

      final desc = "${tmp[0]}.${tmp[1]}";
      result = "'$desc': $desc,";
    }

    result = result.replaceAll("IconData", "Icons");
    // if (result.contains('static.')) {
    //   debugPrint("e: $e");
    // }
    return result;
  }

  createFile({String? fileName, required String content}) async {
    fileName ??= "未命名_${DateTime.now().toString().substring(0, 9)}";
    final file = await FileManager().createFile(fileName: fileName, content: content);
    debugPrint("file: ${file.path}");

    showSnackBar(SnackBar(
      content: NText(
        "文件已生成(下载文件夹)",
        color: Colors.white,
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.green,
    ));
  }
}
