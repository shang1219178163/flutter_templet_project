//
//  NFilterDropBox.dart
//  yl_health_app_v2.20.5
//
//  Created by shang on 2024/4/9 18:28.
//  Copyright © 2024/4/9 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_footer_button_bar.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';



class NFilterDropBox extends StatefulWidget {

  NFilterDropBox({
    super.key,
    required this.sections,
    required this.onCancel,
    required this.onReset,
    required this.onConfirm,
  });


  final List<Widget> sections;
  final VoidCallback onCancel;
  final VoidCallback onReset;
  final VoidCallback onConfirm;

  @override
  State<NFilterDropBox> createState() => _NFilterDropBoxState();
}

class _NFilterDropBoxState extends State<NFilterDropBox> {

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => widget.onCancel,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(
          // bottom: context.appBarHeight + 51,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Column(
          children: [
            const Divider(
              height: 1,
              color: lineColor,
            ),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: widget.sections.map((e) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                              ),
                              child: e,
                            ),
                            if (widget.sections.last != e) buildDvider(),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            buildDropBoxButtonBar(
              onCancel: widget.onReset,
              onConfirm: widget.onConfirm,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDvider() {
    return Container(
      height: 8,
      margin: const EdgeInsets.only(top: 15),
      color: lineColor[30],
    );
  }

  /// 筛选弹窗 取消确认菜单
  Widget buildDropBoxButtonBar({
    required VoidCallback onCancel,
    required VoidCallback onConfirm,
  }) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(8),
      ),
      child: NFooterButtonBar(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xffE5E5E5), width: 0.5)),
        ),
        cancelTitle: "重置",
        confirmTitle: "确定",
        onCancel: onCancel,
        onConfirm: onConfirm,
      ),
    );
  }
}