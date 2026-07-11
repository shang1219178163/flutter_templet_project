//
//  DiscussListPage.dart
//  flutter_templet_project
//
//  Created by shang on 2026/7/10 17:31.
//  Copyright © 2026/7/10 shang. All rights reserved.
//

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/input_accessory_view/n_input_accessory_view_one.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';
import 'package:flutter_templet_project/basicWidget/refresh/n_custom_scrollView.dart';
import 'package:flutter_templet_project/basicWidget/refresh/n_easy_refresh_mixin.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_box.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/pages/demo/discuss/model/NewsDiscussRootModel.dart';
import 'package:flutter_templet_project/pages/demo/discuss/provider/discuss_provider.dart';
import 'package:flutter_templet_project/pages/demo/discuss/widget/discuss_list_item.dart';
import 'package:flutter_templet_project/pages/demo/discuss/widget/discuss_title_bar.dart';
import 'package:flutter_templet_project/pages/demo/discuss/widget/news_detail_bottom_bar.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

class DiscussListPage extends StatefulWidget {
  const DiscussListPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<DiscussListPage> createState() => _DiscussListPageState();
}

class _DiscussListPageState extends State<DiscussListPage> with NInputAccessoryViewOneMixin {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final refreshController = NListRefreshController<NewsDiscussDetailModel>();

  final discussProvider = NewsDiscussProvider();

  @override
  void dispose() {
    discussProvider.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DiscussListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
      bottomNavigationBar: NewsDetailBottomBar(
        onTap: () => showInputView(onSend: onSend),
      ),
    );
  }

  Widget buildBody() {
    return NCustomScrollView<NewsDiscussDetailModel>(
      controller: refreshController,
      onRequest: (bool isRefresh, int page, int pageSize, pres) async {
        final jsonStr = await rootBundle.loadString('assets/data/discuss.json');
        final Map<String, dynamic> json = jsonDecode(jsonStr);
        final rootModel = NewsDiscussRootModel.fromJson(json);
        final dataModel = rootModel.data?.page;
        final followItems = (dataModel?.items ?? []);
        return followItems;
      },
      itemBuilder: (context, index, e) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDiscussListItem(model: e, isHot: true),
            Divider(),
          ],
        );
      },
      headerBuilder: (int count) {
        final length = refreshController.items.length;
        return [
          NSliverPersistentHeaderBuilder(
            key: const ValueKey("热门评论"),
            pinned: false,
            floating: false,
            min: 48,
            max: 48,
            builder: (context, shrinkOffset, overlapsContent) {
              return DiscussTitleBar(
                title: "热门评论 ${length}",
                style: const TextStyle(
                  color: AppColor.cancelColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: "PingFang SC",
                ),
              );
            },
          ),
        ];
      },
    );
  }

  Widget buildDiscussListItem({
    required NewsDiscussDetailModel model,
    bool isHot = false,
  }) {
    return DiscussListItem(
      model: model,
      onTap: () {
        DLog.d("跳转");
      },
      onRely: () {
        DLog.d("回复消息");
      },
      onLike: () async {
        DLog.d("onLike");
        model.like = !(model.like ?? false);
        model.likeNumber = 1;
        return model.toJson();
      },
      onLink: (urls) {
        AssetUploadBox.jumpImagePreview(context: context, urls: urls, index: 0);
      },
      onParentLink: (urls) {
        AssetUploadBox.jumpImagePreview(context: context, urls: urls, index: 0);
      },
    );
  }

  Future<void> onSend(InputAccessoryViewSession accessorySession) async {
    DLog.d([
      "发送评论",
      accessorySession.inputText,
      accessorySession.selectedModels.map((e) => e.toJson()),
    ]);

    final model = NewsDiscussDetailModel(
      customerInfo: CustomerInfoModel(
        avatar: "",
        nickname: "君行",
      ),
      message: accessorySession.inputText,
      imageUrls: accessorySession.selectedUrls,
      showTime: DateTime.now().toString().timeDescription,
    );

    NInputAccessoryViewOne.clearContent();
    final items = [...refreshController.items];
    final targetIndex = discussProvider.ascending ? discussProvider.messages.length : 0;

    items.insert(targetIndex, model);
    discussProvider.total += 1;
    refreshController.updateItems(items);
    refreshController.updateUI();
  }
}
