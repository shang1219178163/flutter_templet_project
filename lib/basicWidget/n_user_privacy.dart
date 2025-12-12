//
//  n_user_privacy.dart
//  flutter_templet_project
//
//  Created by shang on 7/30/21 9:32 PM.
//  Copyright © 7/30/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class NUserPrivacy extends StatefulWidget {
  const NUserPrivacy({
    Key? key,
    this.title,
    this.content,
    required this.onCancel,
    required this.onConfirm,
    this.radius = 8,
    this.cancellBuilder,
    this.confirmBuilder,
    this.bottomBuilder,
  })  : assert(title != null || content != null),
        super(key: key);

  final Text? title;
  final Text? content;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  final double radius;

  final WidgetBuilder? cancellBuilder;
  final WidgetBuilder? confirmBuilder;
  final WidgetBuilder? bottomBuilder;

  @override
  _NUserPrivacyState createState() => _NUserPrivacyState();
}

class _NUserPrivacyState extends State<NUserPrivacy> {
  final ScrollController _scrollController = ScrollController();

  bool isScrollBottom = false;

  @override
  void initState() {
    //监听滚动事件，打印滚动位置
    _scrollController.addListener(() {
      isScrollBottom = (_scrollController.offset >= _scrollController.position.maxScrollExtent);
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Center(
      child: Material(
        color: Colors.red,
        borderRadius: BorderRadius.circular(widget.radius),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(widget.radius),
          ),
          width: context.screenSize.width * .8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.title != null)
                Container(
                  height: 45,
                  padding: EdgeInsets.only(top: 12, left: 12, bottom: 8, right: 12),
                  child: widget.title,
                ),
              if (widget.content != null)
                Container(
                  padding: EdgeInsets.only(left: 16, bottom: 8, right: 16),
                  height: context.screenSize.height * .5,
                  child: CupertinoScrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: widget.content!,
                    ),
                  ),
                ),
              Divider(
                height: 1,
              ),
              widget.bottomBuilder ?? _buildButtonBar(),
            ],
          ),
        ),
      ),
    );
  }

  _buildButtonBar() {
    return Container(
      height: 45,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: widget.onCancel,
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: widget.cancellBuilder != null
                    ? widget.cancellBuilder?.call(context)
                    : Text(
                        '不同意',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
              ),
            ),
          ),
          VerticalDivider(
            width: 1,
          ),
          Expanded(
              child: GestureDetector(
            onTap: !isScrollBottom ? null : widget.onConfirm,
            child: Container(
              decoration: BoxDecoration(
                color: _getConfirmBtnBgColor(),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(widget.radius)),
              ),
              alignment: Alignment.center,
              child: widget.confirmBuilder != null
                  ? widget.confirmBuilder?.call(context)
                  : Text(
                      '同意',
                      style: TextStyle(fontWeight: FontWeight.w500, color: _getConfirmBtnTextColor()),
                    ),
            ),
          )),
        ],
      ),
    );
  }

  Color _getConfirmBtnBgColor() {
    return !isScrollBottom ? Colors.grey : Theme.of(context).colorScheme.primary;
  }

  Color _getConfirmBtnTextColor() {
    return !isScrollBottom ? Colors.black87 : Colors.white;
  }
}
