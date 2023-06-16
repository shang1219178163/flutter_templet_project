

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/mixin/dialog_tag_select.dart';

class AlertDialogTagSelectDemo extends StatefulWidget {

  AlertDialogTagSelectDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _AlertDialogTagSelectDemoState createState() => _AlertDialogTagSelectDemoState();
}

class _AlertDialogTagSelectDemoState extends State<AlertDialogTagSelectDemo> {


  /// 标签列表
  List<TagDetailModel> tags = [];

  /// 选择的标签
  List<TagDetailModel> selectTags = [];

  /// 临时选择的标签病列表
  List<TagDetailModel> selectTagsTmp = [];

  /// 已选择的标签
  String get selectTagNames {
    List<String> result = selectTags.map((e) => e.name ?? "-").toList();
    // debugPrint("selectDiseaseTypesNames: ${result}");
    return result.join();
  }


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;
    final items = List.generate(20, (index) => index);

    tags = items.map((e) => TagDetailModel(
      id: e.toString(),
      name: "标签_${e}"
    )).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onPressed,)
        ).toList(),
      ),
      body: Text(arguments.toString())
    );
  }

  onPressed(){
    DialogTagSelect().present(
      context: context,
      userId: "",
      title: "标签",
      tags: tags,
      selectTagsTmp: selectTagsTmp,
      selectTags: selectTags,
      isMuti: false,
      onCancel: (){

      },
      onConfirm: (List<TagDetailModel> selectedItems){
        selectTags = selectedItems;

        debugPrint(selectTags.map((e) => e.name ?? "").toList().toString());
      },
    );
  }

}