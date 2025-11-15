import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 字符串转换
class StringTransformPage extends StatefulWidget {
  StringTransformPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _StringTransformPageState createState() => _StringTransformPageState();
}

class _StringTransformPageState extends State<StringTransformPage> {
  late final _editingController = TextEditingController();

  late final items = <Tuple2<String, VoidCallback>>[
    Tuple2("驼峰转下换线", camelToUnderScoreCase),
    Tuple2("下换线转驼峰", underScoreCaseToCamel),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("字符串转换"),
          // actions: ['done',].map((e) => TextButton(
          //   child: Text(e,
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   onPressed: () => debugPrint(e),)
          // ).toList(),
        ),
        body: buildBody());
  }

  buildBody() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: buildTextfield(
              controller: _editingController,
              hintText: "请输入",
              maxLines: 5,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            child: LayoutBuilder(builder: (context, constraints) {
              final spacing = 8.0;
              final runSpacing = 8.0;

              return Wrap(
                spacing: spacing,
                runSpacing: runSpacing,
                // alignment: WrapAlignment.start,
                children: items
                    .map((e) => OutlinedButton(
                          onPressed: e.item2,
                          child: NText(e.item1),
                        ))
                    .toList(),
              );
            }),
          ),
        ],
      ),
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
        fillColor: AppColor.bgColor,
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

  camelToUnderScoreCase() {
    final tmp = _editingController.text;
    _editingController.text = tmp.toUncamlCase("_");
  }

  underScoreCaseToCamel() {
    final tmp = _editingController.text;
    _editingController.text = tmp.toCamlCase("_");
  }
}
