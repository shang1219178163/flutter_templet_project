//
//  NSearchBarViewView.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/14 09:28.
//  Copyright © 2026/4/14 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class NSearchBarView extends StatefulWidget {
  const NSearchBarView({
    super.key,
    this.suffix,
    this.prefix,
    required this.controller,
    this.hint,
    this.backgroudColor,
    this.onTapSearch,
    this.onChanged,
  });

  //搜索框后缀
  final Widget? suffix;

  //搜索框前缀
  final Widget? prefix;

  final TextEditingController controller;

  final String? hint;

  final Color? backgroudColor;

  final ValueChanged<String>? onTapSearch;
  final ValueChanged<String>? onChanged;

  @override
  State<NSearchBarView> createState() => _NSearchBarViewState();
}

class _NSearchBarViewState extends State<NSearchBarView> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.transparent;
    final dividerColor = Color(0xFFDEDEDE);
    final textfieldBackgroudColor = Color(0xFFF5F8F9);
    final hintColor = Colors.black26;
    final titleColor = Colors.black;
    final subtitleColor = Color(0xFF7C7C85);

    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: textfieldBackgroudColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.prefix != null) widget.prefix!,
          if (widget.prefix != null)
            Container(
              width: 0.5,
              height: 18,
              color: dividerColor,
            ),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: widget.controller,
              style: TextStyle(
                color: titleColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.search,
              // autofocus: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: widget.hint ?? '请输入搜索内容',
                hintStyle: TextStyle(
                  color: hintColor,
                ),
                isDense: true,
                filled: true,
                fillColor: Colors.transparent,
              ),
              onSubmitted: widget.onTapSearch,
              onChanged: widget.onChanged,
            ),
          ),
          Container(
            width: 0.5,
            height: 18,
            color: dividerColor,
          ),
          widget.suffix ??
              TextButton(
                onPressed: () => widget.onTapSearch?.call(widget.controller.text),
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
                child: Text(
                  '搜索',
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'PingFang SC',
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
