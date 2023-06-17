

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/mixin/dialog_tag_select.dart';
import 'package:flutter_templet_project/model/selected_model.dart';

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

  final items = List.generate(20, (index) => index);

  /// 标签列表
  late List<SelectModel> tags = items.map((e) => SelectModel(
    id: e.toString(),
    name: "标签_${e}",
  )).toList();

  /// 选择的标签
  List<SelectModel> selectTags = [];

  /// 临时选择的标签病列表
  List<SelectModel> selectTagsTmp = [];

  /// 已选择的标签
  List<String> get selectTagNames => selectTags.map((e) => e.name ?? "-").toList();


  @override
  Widget build(BuildContext context) {
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
      body: Text(selectTagNames.toString())
    );
  }

  onPressed(){
    DialogTagSelect().present(
      context: context,
      title: "标签",
      tags: tags,
      selectTagsTmp: selectTagsTmp,
      selectTags: selectTags,
      // isMuti: false,
      onCancel: (){

      },
      onConfirm: (List<SelectModel> selectedItems){
        selectTags = selectedItems;

        debugPrint(selectTagNames.toString());
        setState(() {});
      },
    );
  }

}