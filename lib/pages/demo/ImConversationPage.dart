//
//  ImConversationListPage.dart
//  flutter_templet_project
//
//  Created by shang on 2025/2/13 11:04.
//  Copyright © 2025/2/13 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_templet_project/basicWidget/n_refresh_view.dart';
import 'package:flutter_templet_project/extension/date_time_ext.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/mixin/asset_resource_mixin.dart';
import 'package:flutter_templet_project/model/im_conversation_detail_model.dart';
import 'package:flutter_templet_project/pages/demo/widget/im_conversation_cell.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

/// 会话列表
class ImConversationPage extends StatefulWidget {
  const ImConversationPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ImConversationPage> createState() => _ImConversationPageState();
}

class _ImConversationPageState extends State<ImConversationPage> with AssetResourceMixin {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  final refreshViewController = NRefreshViewController<ImConversationDetailModel>();

  // 创建一个随机数生成器
  Random random = Random();

  @override
  void initState() {
    super.initState();

    onAssetResourceFinished = () {};
  }

  @override
  void didUpdateWidget(covariant ImConversationPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlue, Colors.green], // 渐变的颜色
                    begin: Alignment.centerLeft, // 渐变的起始位置
                    end: Alignment.centerRight, // 渐变的结束位置
                  ),
                ),
              ),
              title: Text("$widget"),
              actions: [
                GestureDetector(
                  onTap: () {
                    DLog.d("搜索");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Image(
                      image: AssetImage(
                        "assets/images/icon_search.png",
                      ),
                      width: 18,
                      height: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                buildPopupMenu(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.add, size: 24),
                  ),
                ),
              ],
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return NRefreshView<ImConversationDetailModel>(
      controller: refreshViewController,
      pageSize: 5,
      onRequest: (bool isRefresh, int page, int pageSize, last) async {
        return requestList(isRefresh: isRefresh, pageNo: page, pageSize: pageSize);
      },
      itemBuilder: (BuildContext context, int index, e) {
        final dateStr = DateTime.now().toString19();

        final content = InkWell(
          onTap: () {
            // DLog.d("${e.toJson()}");
            Get.toNamed(AppRouter.imChatPage);
          },
          child: IMConversationCell(
            imgUrl: e.faceUrl ?? "",
            badgeValue: random.nextInt(100),
            decorationImage: DecorationImage(
              image: index % 2 == 0 ? AssetImage("assets/images/bg_mk11.jpg") : AssetImage("assets/images/shan.png"),
              fit: BoxFit.fill,
            ),
            title: e.showName ?? "-",
            subtitle: assetFileModels.firstOrNull?.content?.split("\n").randomOne ?? "",
            time: dateStr,
          ),
        );

        return buildSlidable(
          isPinned: e.isPinned ?? false,
          onPin: () async {
            debugPrint("onPin");
          },
          onDelete: () async {
            debugPrint("onDelete");
          },
          child: content,
        );
      },
    );
  }

  /// 列表数据请求
  Future<List<ImConversationDetailModel>> requestList({
    required bool isRefresh,
    required int pageNo,
    int pageSize = 20,
  }) async {
    // var api = SchemePageApi(
    //   ownerId: arguments['userId'] ?? '',
    //   pageNo: pageNo,
    //   pageSize: pageSize,
    // );
    //
    // Map<String, dynamic>? response = await api.startRequest();
    // if (response['code'] != 'OK') {
    //   return [];
    // }
    //
    // final rootModel = DepartmentPageRootModel.fromJson(response ?? {});
    // var list = rootModel.result?.content ?? [];

    final urls = AppRes.image.urls;

    if (refreshViewController.items.length >= urls.length) {
      return [];
    }

    var list = List.generate(pageSize, (i) {
      var currentIndex = isRefresh ? i : refreshViewController.items.length + i;
      return ImConversationDetailModel(
        conversationID: "conversation_$currentIndex",
        groupID: "${i % 2 == 0 ? "CONSULTATION_" : "pub_"}${12.generateChars()}",
        showName: "Flutter 学习群 $currentIndex",
        faceUrl: urls[currentIndex],
      );
    });

    return list;
  }

  Widget buildPopupMenu({Widget? child}) {
    final items = <({int index, IconData iconData, String title, VoidCallback event})>[
      (index: 0, iconData: Icons.chat, title: '发起群聊', event: () => DLog.d("发起群聊")),
      (index: 1, iconData: Icons.add_circle_outline, title: '添加朋友', event: () => DLog.d("添加朋友")),
      (index: 2, iconData: Icons.document_scanner_rounded, title: '扫一扫', event: () => DLog.d("扫一扫")),
      (index: 3, iconData: Icons.payment, title: '收付款', event: () => DLog.d("收付款")),
    ];

    return PopupMenuButton(
      // icon: FStyle.iconfont(0xe62d, size: 17.0),
      offset: const Offset(0, 50.0),
      tooltip: '',
      color: const Color(0xFF353535),
      itemBuilder: (BuildContext context) {
        return items.map((e) {
          return popupMenuItem(e.iconData, e.title, e.index);
        }).toList();
      },
      onSelected: (value) {
        final item = items.firstWhereOrNull((e) => e.index == value);
        item?.event();
      },
      child: child,
    );
  }

  // 下拉菜单项
  PopupMenuItem popupMenuItem(IconData icon, String title, value) {
    return PopupMenuItem(
      value: value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10.0),
          Icon(icon, size: 21.0, color: Colors.white),
          const SizedBox(width: 10.0),
          Text(
            title,
            style: const TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ],
      ),
    );
  }

  buildSlidable({
    required bool isPinned,
    required VoidCallback? onPin,
    required VoidCallback? onDelete,
    required Widget child,
  }) {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (ctx) => onPin?.call(),
            backgroundColor: AppColor.primary,
            foregroundColor: Colors.white,
            icon: Icons.push_pin,
            label: isPinned ? "取消置顶" : '置顶',
            padding: EdgeInsets.zero,
          ),
          SlidableAction(
            onPressed: (ctx) => onDelete?.call(),
            backgroundColor: AppColor.cancelColor,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '删除',
          ),
        ],
      ),
      child: child,
    );
  }
}
