

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box_one.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/mixin/dialog_mixin.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:tuple/tuple.dart';

class NChoiceBoxOneDemo extends StatefulWidget {

  NChoiceBoxOneDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  State<NChoiceBoxOneDemo> createState() => _NChoiceBoxOneDemoState();
}

class _NChoiceBoxOneDemoState extends State<NChoiceBoxOneDemo> {

  final _scrollController = ScrollController();

  final rpItems = <Tuple3<String, String, String>>[
    Tuple3('西药/中成药/特医', RpType.WESTERN_MEDICINE.name, "+添加药品"),
    Tuple3('医疗器械', RpType.MEDICAL_APPLIANCE.name, "+添加器械"),
    Tuple3('检测检验', RpType.JC.name, "+添加检测"),
    Tuple3('中药', RpType.CHINESE_MEDICINE.name, "+添加药品"),
  ];

  late Tuple3<String, String, String> rpItemCurrent = rpItems[0];

  final canChange = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            buildRpTypeBox(),
          ],
        ),
      ),
    );
  }

  /// 模板类型
  Widget buildRpTypeBox() {
    Widget content = NChoiceBoxOne<Tuple3<String, String, String>>(
          items: rpItems,
          seletedItem: rpItemCurrent,
          primaryColor: context.primaryColor,
          styleSeleted: TextStyle(
            color: context.primaryColor,
            fontSize: 15,
          ),
          canChanged: (val, onSelect) {
            if (rpItemCurrent == val) {
              return false;
            }
            if (!canChange) {
              DeleteAlert().show(context,
                scrollController: ScrollController(),
                title: "提示",
                message: "切换模板种类会清空已选中的药品，是否确认切换?",
                onConfirm: () async {
                  Navigator.of(context).pop();
                  onSelect(val, true);
                  rpItemCurrent = val;
                },
              );
            }
            return canChange;
          },
          onChanged: (val){
            // debugPrint("NChoiceBoxOne e: $val");
            if (rpItemCurrent == val) {
              return;
            }
            if (val is! Tuple3<String, String, String>) {
              return;
            }
            rpItemCurrent = val;

          }
      );

    return buildItemHeader(
      title: '模版类型',
      isRequired: true,
      child: Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: content,
      ),
    );
  }

  //item 表头
  Widget buildItemHeader({
    EdgeInsets? padding,
    required String title,
    String? detailTitle,
    required bool isRequired,
    Widget? leading,
    Widget? trailing,
    required Widget child,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              leading ?? const SizedBox(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title.isNotEmpty)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: NText(title,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              // letterSpacing: 2,
                            ),
                          ),
                          SizedBox(
                              width: 10,
                              child: Offstage(
                                offstage: !isRequired,
                                child: NText(
                                  '*',
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              )),
                        ],
                      ),
                    if (detailTitle?.isNotEmpty == true)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NText(detailTitle ?? "",
                            color: fontColor[30],
                            fontSize: 12,
                            fontWeight: FontWeight.w500
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              trailing ?? const SizedBox(),
            ],
          ),
          child,
        ],
      ),
    );
  }
}


/// 处方类型
enum RpType {
  /// 西药
  WESTERN_MEDICINE('西药/中成药/特医'),
  /// 中药
  CHINESE_MEDICINE('中药'),
  /// 器械
  MEDICAL_APPLIANCE('医疗器械'),
  /// 检查
  JC('检测检查'),
  /// 续方
  RENEW_RP('续方');


  const RpType(this.desc,);
  /// 当前枚举对应的 描述文字
  final String desc;

}