//
//  NNUserPrivacy.dart
//  fluttertemplet
//
//  Created by shang on 7/30/21 9:32 PM.
//  Copyright © 7/30/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertemplet/basicWidget/NNWebView.dart';

class NNUserPrivacy extends StatefulWidget {
  final String? title;
  final Text? content;
  final Function onClickCancel;
  final Function onClickConfirm;

  NNUserPrivacy(
      {Key? key,
      this.title,
      this.content,
      required this.onClickCancel,
      required this.onClickConfirm})
      : assert(title != null || content != null),
        super(key: key);

  @override
  _NNUserPrivacyState createState() => _NNUserPrivacyState();
}

class _NNUserPrivacyState extends State<NNUserPrivacy> {
  ScrollController _scrollController = ScrollController();

  bool isScrollBottom = false;

  @override
  void initState() {
    //监听滚动事件，打印滚动位置
    _scrollController.addListener(() {
      setState(() {
        isScrollBottom = (_scrollController.offset >=
            _scrollController.position.maxScrollExtent);
      });
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
    // dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    final screenSize = MediaQuery.of(context).size;

    return Center(
      child: Material(
        child: Container(
          color: Colors.white,
          width: screenSize.width * .8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.title != null)
                Container(
                  padding:
                      EdgeInsets.only(top: 12, left: 12, bottom: 8, right: 12),
                  child: Text(
                    widget.title!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              if (widget.content != null)
                Container(
                  padding: EdgeInsets.only(left: 12, bottom: 8, right: 12),
                  height: screenSize.height * .5,
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
              Container(
                height: 45,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          widget.onClickCancel();
                        },
                        child: Container(
                          alignment: Alignment.center, child: Text('不同意')
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 1,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: !isScrollBottom
                            ? null
                            : () {
                          widget.onClickConfirm();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: !isScrollBottom
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                          child: Text('同意',),
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
