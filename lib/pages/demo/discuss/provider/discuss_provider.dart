import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/pages/demo/discuss/enum/discuss_sort_type.dart';
import 'package:flutter_templet_project/pages/demo/discuss/model/NewsDiscussRootModel.dart';

/// 资讯评论 Provider（页面级实例，由 ChangeNotifierProvider 管理生命周期）
class NewsDiscussProvider extends ChangeNotifier {
  NewsDiscussProvider();

  /// 文章id
  int? articleId;

  bool isAsc = false;

  /// 查询递归总数
  int totalCommentCount = 0;

  /// 查询一级列表总数
  int total = 0;

  /// 询二级评论(具体某一条评论)的回复总数
  int secondTotal = 0;

  /// 一级页面
  /// 热门
  List<NewsDiscussDetailModel> hotMessages = [];

  List<NewsDiscussDetailModel> messages = [];

  final tabItems = [DiscussSortType.newest, DiscussSortType.earliest];
  final tabIndexVN = ValueNotifier(0);
  DiscussSortType get currTabItem => tabItems[tabIndexVN.value];

  /// 升序
  bool get ascending => currTabItem != DiscussSortType.newest;

  /// 二级页面
  final secondTabItems = [DiscussSortType.newest, DiscussSortType.earliest, DiscussSortType.hottest];
  final secondTabIndexVN = ValueNotifier(0);

  DiscussSortType get currSecondTabItem => secondTabItems[secondTabIndexVN.value];

  /// 二级根评论
  NewsDiscussDetailModel? secondRootComment;

  final me = CustomerInfoModel(
    avatar: "",
    nickname: "君行",
    customerId: 999999,
  );

  /// 升序
  // bool get ascending => (tabIndexVN.value != 0);

  void notify() {
    notifyListeners();
  }

  @override
  void dispose() {
    tabIndexVN.dispose();
    secondTabIndexVN.dispose();
    super.dispose();
  }

  /// 添加评论
  Future<NewsDiscussDetailModel?> requestMessageCreate({
    required int? articleId,
    // required int? parentId,
    required NewsDiscussDetailModel? parent,
    required String content,
    List<String> imageUrls = const [],
  }) async {
    // final api = ArticleCommentAddApi(
    //   articleId: articleId,
    //   parentId: parent?.commentId,
    //   parentType: parentType.index,
    //   imageUrls: imageUrls,
    //   content: content,
    // );
    // final map = await api.fetch();
    // if (map['code'] != 0 || map["data"] == null) {
    //   ToastHelper.error(map['msg'] ?? "");
    //   return null;
    // }
    // final commentId = map["data"]?["commentId"] as int?;
    // final createTime = map["data"]?["createTime"] as String?;

    final commentId = IntExt.random(min: 1000, max: 10000);
    final createTime = DateTimeExt.stringFromDate(date: DateTime.now());
    final model = NewsDiscussDetailModel(
      commentId: commentId,
      createTime: createTime,
      showTime: (createTime ?? "").timeDescription,
      parent: parent,
      canDelete: true,
      customerInfo: me,
      replyToCustomerInfo: parent?.customerInfo,
      message: content,
      imageUrls: imageUrls,
      replyList: [],
      replyCount: 0,
    );
    return model;
  }

  /// 删除评论
  Future<bool> requestMessageDelete({
    required int? id,
  }) async {
    return true;
  }

  /// 请求列表
  Future<List<NewsDiscussDetailModel>> requestHotDiscussQuery({
    required int? articleId,
    int? hotLimit = 20,
  }) async {
    final jsonStr = await rootBundle.loadString('assets/data/discuss.json');
    final Map<String, dynamic> json = jsonDecode(jsonStr);
    final rootModel = NewsDiscussRootModel.fromJson(json);
    final dataModel = rootModel.data?.page;
    final followItems = (dataModel?.items ?? []);
    return followItems;
  }

  /// 请求列表
  Future<List<NewsDiscussDetailModel>> requestDiscussQuery({
    required int? articleId,
    int? pageNum = 1,
    int? pageSize = 20,
  }) async {
    final jsonStr = await rootBundle.loadString('assets/data/discuss.json');
    final Map<String, dynamic> json = jsonDecode(jsonStr);
    final rootModel = NewsDiscussRootModel.fromJson(json);
    final dataModel = rootModel.data?.page;
    final followItems = (dataModel?.items ?? []);
    return followItems;
  }

  /// 点赞
  Future<Map<String, dynamic>> requestLikeForModel({
    required NewsDiscussDetailModel model,
  }) async {
    final isLikeOld = model.like ?? false;
    final isLike = !isLikeOld;
    // final api = ArticleLikeApi(
    //   targetId: model.commentId,
    //   targetType: model.parentId == null ? DiscussParentType.root : DiscussParentType.reply,
    //   isLike: !isLikeOld,
    // );
    // final map = await api.fetch();
    // if (map['code'] != 0) {
    //   ToastHelper.error(map['msg']);
    //   return {};
    // }
    final map = {};
    final dataMap = map["data"] as Map<String, dynamic>? ?? <String, dynamic>{};
    dataMap["like"] = isLike;
    dataMap["likeNumber"] = dataMap["likeCount"];
    return dataMap;
  }
}
