//
//  AnimatedContainerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/15/23 12:19 PM.
//  Copyright © 3/15/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_expansion_fade.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

class AnimatedContainerDemo extends StatefulWidget {
  const AnimatedContainerDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _AnimatedContainerDemoState createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<AnimatedContainerDemo> {
  final sizeStart = Size(200, 200);
  final sizeEnd = Size(400, 400);

  final _width = 0.0.vn;
  final _height = 0.0.vn;
  final _alignment = Alignment.topLeft.vn;
  final _color = Colors.lightBlue.vn;

  @override
  void initState() {
    _width.value = sizeStart.width;
    _height.value = sizeStart.height;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.bgColor,
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            'done',
          ]
              .map((e) => TextButton(
                    onPressed: onPressed,
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
              .toList(),
        ),
        body: buildBody());
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ElevatedButton(
            onPressed: _changeSize,
            child: const Text('更新宽高'),
          ),
          NSectionBox(
            title: "searchContainer",
            child: buildAnimatedContainer(),
          ),
          NSectionBox(
            title: "searchContainer",
            child: searchContainer(),
          ),
          NSectionBox(
            title: "ExpansionCrossFade",
            child: buildExpansionCrossFade(),
          ),
          NSectionBox(
            title: "ExpansionCrossFade",
            child: NExpansionFade(
              childBuilder: (isExpanded, onToggle) {
                return buildExpansionChild(
                  content: "测试_" * 500,
                  isExpanded: isExpanded,
                  onToggle: onToggle,
                );
              },
              expandedBuilder: (isExpanded, onToggle) {
                return buildExpansionChild(
                  content: "测试1_" * 500,
                  isExpanded: isExpanded,
                  onToggle: onToggle,
                );
              },
            ),
          ),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  Widget buildAnimatedContainer() {
    return AnimatedBuilder(
        animation: Listenable.merge([
          _width,
          _height,
          _color,
          _alignment,
        ]),
        builder: (context, child) {
          return AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            width: _width.value,
            height: _height.value,
            color: _color.value,
            alignment: _alignment.value,
            onEnd: onEnd,
            child: TextButton(
              onPressed: () {
                debugPrint("AnimatedContainer");
              },
              child: Text(
                "AnimatedContainer",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        });
  }

  void onEnd() {
    debugPrint('End');
  }

  onPressed() {
    _changeSize();
  }

  void _changeSize() {
    _width.value = _width.value == sizeStart.width ? sizeEnd.width : sizeStart.width;
    _height.value = _height.value == sizeStart.height ? sizeEnd.height : sizeStart.height;
    _color.value = _color.value == Colors.green ? Colors.lightBlue : Colors.green;
    _alignment.value = _alignment.value == Alignment.topLeft ? Alignment.center : Alignment.topLeft;
  }

  // 搜索框初始宽度
  double _searchWidth = 28;
  // 标志是否已展开
  bool _isExpanded = false;

  final _searchWidthVN = ValueNotifier(28.0);
  final _searchVN = ValueNotifier("");

  final _searchController = TextEditingController();

  Widget searchContainer() {
    final fontColor = Color(0xFF1A1A1A);

    void toggle() {
      _isExpanded = !_isExpanded;
      _searchWidth = _isExpanded ? 160.0 : 28.0;

      _searchWidthVN.value = _searchWidth;
      debugPrint("_isExpanded: $_isExpanded, ${_searchWidthVN.value}");
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: NText(
            '全部标签',
            fontWeight: FontWeight.w400,
          ),
        ),
        ValueListenableBuilder(
            valueListenable: _searchWidthVN,
            builder: (context, _searchWidth, child) {
              return GestureDetector(
                onTap: toggle,
                child: AnimatedContainer(
                  height: 28,
                  width: _searchWidth,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          toggle();
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          child: Image(
                            image: 'icon_search.png'.toAssetImage(),
                            width: 18,
                            height: 18,
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 4,
                          child: TextField(
                            controller: _searchController,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: fontColor,
                            ),
                            maxLength: 15,
                            maxLines: 1,
                            onChanged: (val) {
                              _searchVN.value = val;
                            },
                            onSubmitted: (val) {
                              _searchVN.value = val;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Colors.green,
                              hintStyle: TextStyle(color: fontColor.withOpacity(0.2)),
                              isCollapsed: true,
                              contentPadding: EdgeInsets.zero,
                              counterText: '',
                              hintText: '搜索',
                              suffixIcon: ValueListenableBuilder(
                                  valueListenable: _searchVN,
                                  builder: (context, value, child) {
                                    if (value.isEmpty) {
                                      return SizedBox();
                                    }

                                    return InkWell(
                                      onTap: () {
                                        _searchController.clear();
                                        _searchVN.value = "";
                                        toggle();
                                      },
                                      child: Icon(
                                        Icons.cancel,
                                        color: Colors.grey,
                                      ),
                                    );
                                  }),
                              // suffix: Icon(Icons.clear),
                            ),
                          )),
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }

  bool isExpandedExpansion = true;

  Widget buildExpansionCrossFade() {
    return NExpansionFade(
        isExpanded: isExpandedExpansion,
        childBuilder: (isExpanded, onToggle) {
          return Container(
            height: 100,
            color: Colors.green,
            child: IconButton(onPressed: onToggle, icon: Icon(Icons.expand_more)),
          );
        },
        expandedBuilder: (isExpanded, onToggle) {
          return Container(
            height: 200,
            color: Colors.red,
            child: IconButton(onPressed: onToggle, icon: Icon(Icons.expand_less)),
          );
        });
  }

  buildExpansionChild({required String content, required bool isExpanded, required VoidCallback onToggle}) {
    final maxLines = isExpanded ? 10 : 5;
    final arrowImage = isExpanded ? "icon_expand_arrow_up.png" : "icon_expand_arrow_down.png";

    return InkWell(
      onTap: onToggle,
      child: Column(
        children: [
          Container(
            child: NText(
              "测试_" * 500,
              maxLines: maxLines,
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 40,
            padding: EdgeInsets.only(top: 8, bottom: 11),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                // border: Border.all(color: Colors.blue),
                // borderRadius: BorderRadius.all(Radius.circular(0)),
                // gradient: LinearGradient(
                //   tileMode: TileMode.clamp,
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   colors: [
                //     Color(0xFFF9F9F9).withOpacity(0.01),
                //     Color(0xFFF9F9F9),
                //   ],
                // )
                ),
            child: Image(
              image: arrowImage.toAssetImage(),
              width: 21,
              height: 8,
            ),
          )
        ],
      ),
    );
  }
}
