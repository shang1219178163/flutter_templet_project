import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_expand_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

// 常用语使用1:
// sendPhrases() {
//   choosePhrases(
//     cb: (val) {
//       debugPrint(val.phrases ?? "-");
//       ...
//     }
//   );
// }

// 常用语使用2:
// sendPhrases() {
//   showPhrasesSheet<IMPhrasesContentModel>(
//       items: phrases,
//       titleCb: (e) => e.phrases ?? "",
//       textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
//       cb: (val) {
//         debugPrint(val.phrases ?? "-");
//         if (val.phrases?.isNotEmpty == true) {
//           ...
//         }
//       },
//       onAdd: () {
//         NavigatorUtil.jump(context, APPRouter.phrasesPage);
//       },
//   );
// }

/// 常用语封装 mixin
mixin BottomSheetPhrasesMixin<T extends StatefulWidget> on State<T>  {
  final _scrollController = ScrollController();

  List<IMPhrasesDetailModel> _phrases = [];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    requestIMPhrasesList();

    super.initState();
  }

  /// 常用语弹窗源方法
  showPhrasesSheet<E>({
    Text? title,
    required List<E> items,
    required String Function(E) titleCb,
    TextStyle? textStyle,
    required ValueChanged<E> cb,
    required VoidCallback? onAdd,
    ScrollController? controller,
  }) {
    controller ??= _scrollController;

    final bottom = MediaQuery.of(context).padding.bottom;

    final child = Container(
      height: 400,
      padding: EdgeInsets.only(bottom: bottom.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.w),
            topRight: Radius.circular(12.w),
          )),
      child: Column(
        children: [
          Container(
            // color: Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTextButton(
                  text: Text("取消",),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                if(title != null) Expanded(child: title,),
                buildTextButton(
                  text: Text("自定义",),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onAdd?.call();
                  },
                ),
              ],
            ),
          ),
          Divider(height: 1,),
          Expanded(
            child: Scrollbar(
              controller: controller,
              child: ListView.separated(
                controller: controller,
                itemCount: items.length,
                itemBuilder: (context, int i) {
                  final e = items[i];

                  return InkWell(
                    onTap: () {
                      cb.call(e);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      // margin: EdgeInsets.symmetric(horizontal: 16.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        // vertical: 8.h,
                      ),
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.all(Radius.circular(18.w)),
                      //   border: Border.all(color: Color(0xFFe3e3e3), width: 1.w),
                      //   // border: Border.all(color: Colors.red, width: 1),
                      // ),
                      constraints: BoxConstraints(
                        minHeight: 38.w,
                      ),
                      alignment: Alignment.centerLeft,
                      child: NExpandText(
                        text: titleCb.call(e),
                        textStyle: textStyle,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, int index) {
                  return Divider(
                    height: 16.w,
                    indent: 16.w,
                    endIndent: 16.w,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );

    child.toShowModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
    );
  }

  buildTextButton({
    required Text text,
    required VoidCallback? onPressed
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size(50, 18),
        textStyle: TextStyle(
          color: context.primaryColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        )
      ),
      onPressed: () {
        Navigator.of(context).pop();
        onPressed?.call();
      },
      child: text,
    );
  }

  /// 选择常用语
  choosePhrases({
    required ValueChanged<IMPhrasesDetailModel>? cb,
  }) {
    showPhrasesSheet<IMPhrasesDetailModel>(
      items: _phrases,
      titleCb: (e) => e.phrases ?? "",
      textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
      cb: cb ?? (val) {
        debugPrint(val.phrases ?? "-");
      },
      onAdd: () {
        /// 跳转新增页面
      },
    );
  }

  /// 获取问候语列表
  requestIMPhrasesList() {
    _phrases = List.generate(20, (i) {
      return IMPhrasesDetailModel(
        id: "$i",
        phrases: "常用语_$i"*(i + 1),
      );
    });
  }
}


class IMPhrasesDetailModel {
  IMPhrasesDetailModel({
    this.id,
    this.phrases,
    this.orderNum,
    this.createBy,
  });

  String? id;
  String? phrases;
  int? orderNum;
  String? createBy;


  IMPhrasesDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phrases = json['phrases'];
    orderNum = json['orderNum'];
    createBy = json['createBy'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['phrases'] = phrases;
    data['orderNum'] = orderNum;
    data['createBy'] = createBy;
    return data;
  }
}