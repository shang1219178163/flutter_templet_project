//
//  NewsDiscussRootModel.dart
//
//  Created by JsonToModel on 2026-07-07 09:38.
//

/// 查询评论分页列表
class NewsDiscussRootModel {
  NewsDiscussRootModel({
    this.code,
    this.msg,
    this.data,
  });

  int? code;

  String? msg;

  NewsDiscussDataModel? data;

  NewsDiscussRootModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? NewsDiscussDataModel.fromJson(json['data'] as Map<String, dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['msg'] = msg;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class NewsDiscussDataModel {
  NewsDiscussDataModel({
    this.page,
    this.hasFeatured,
    this.totalCommentCount,
  });

  NewsDiscussPageModel? page;

  /// 有精选
  bool? hasFeatured;

  int? totalCommentCount;

  NewsDiscussDataModel.fromJson(Map<String, dynamic> json) {
    page = json['page'] != null ? NewsDiscussPageModel.fromJson(json['page'] as Map<String, dynamic>) : null;
    hasFeatured = json['hasFeatured'];
    totalCommentCount = json['totalCommentCount'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (page != null) {
      map['page'] = page!.toJson();
    }
    map['hasFeatured'] = hasFeatured;
    map['totalCommentCount'] = totalCommentCount;
    return map;
  }
}

class NewsDiscussPageModel {
  NewsDiscussPageModel({
    this.rootComment,
    this.total,
    this.items,
  });

  int? total;

  NewsDiscussDetailModel? rootComment;

  List<NewsDiscussDetailModel>? items;

  NewsDiscussPageModel.fromJson(Map<String, dynamic> json) {
    rootComment = json['rootComment'] != null
        ? NewsDiscussDetailModel.fromJson(json['rootComment'] as Map<String, dynamic>)
        : null;
    total = json['total'];
    if (json['items'] != null) {
      final array = List<Map<String, dynamic>>.from(json['items'] ?? []);
      items = array.map((e) => NewsDiscussDetailModel.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    map['items'] = items?.map((v) => v.toJson()).toList();
    return map;
  }
}

class CustomerInfoModel {
  CustomerInfoModel({
    this.customerId,
    this.nickname,
    this.avatar,
  });

  int? customerId;

  String? nickname;

  String? avatar;

  CustomerInfoModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    nickname = json['nickname'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['customerId'] = customerId;
    map['nickname'] = nickname;
    map['avatar'] = avatar;
    return map;
  }
}

/// 资讯评论详情
class NewsDiscussDetailModel {
  NewsDiscussDetailModel({
    this.commentId,
    this.parentId,
    this.customerId,
    this.customerInfo,
    this.replyToCustomerInfo,
    this.message,
    this.imageUrls,
    this.replyCount,
    this.likeNumber,
    this.like,
    this.canDelete,
    this.createTime,
    this.showTime,
    this.parent,
    this.replyList,
    this.followNumber,
  });

  /// 根评论 ID
  int? commentId;

  /// 父评论ID
  int? parentId;

  /// 评论人用户ID
  int? customerId;

  /// 评论人信息
  CustomerInfoModel? customerInfo;

  /// 被回复人信息
  CustomerInfoModel? replyToCustomerInfo;

  /// 评论内容
  String? message;

  /// 图片完整URL列表
  List<String>? imageUrls;

  /// 回复数
  int? replyCount;

  /// 点赞数
  int? likeNumber;

  /// 当前登录用户是否已点赞
  bool? like;

  /// 当前登录用户是否有权删除
  bool? canDelete;

  /// 创建时间
  String? createTime;

  /// 展示用相对时间（如：发布 2小时前、发布 3天前）
  String? showTime;

  NewsDiscussDetailModel? parent;

  /// 子回复列表（树形嵌套）
  List<NewsDiscussDetailModel>? replyList;

  int? followNumber;

  List<String>? parentImageUrls;

  String? parentContent;

  int? get userId => customerInfo?.customerId;
  String? get avatar => customerInfo?.avatar;
  String? get nickName => customerInfo?.nickname;

  /// 展开更多回复
  bool get hasMoreReplies {
    var total = replyCount ?? 0;
    var previewCount = (replyList ?? []).length;
    return total > previewCount;
  }

  /// 更多条数
  int get moreCount {
    return (replyCount ?? 0) - (replyList ?? []).length;
  }

  NewsDiscussDetailModel.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    parentId = json['parentId'];
    customerId = json['customerId'];
    customerInfo =
        json['customerInfo'] != null ? CustomerInfoModel.fromJson(json['customerInfo'] as Map<String, dynamic>) : null;
    replyToCustomerInfo = json['replyToCustomerInfo'] != null
        ? CustomerInfoModel.fromJson(json['replyToCustomerInfo'] as Map<String, dynamic>)
        : null;
    message = json['content'];
    if (json['imageUrls'] != null) {
      imageUrls = List<String>.from(json['imageUrls'] ?? []);
    }
    replyCount = json['replyCount'];
    likeNumber = json['likeCount'];
    like = json['isLike'];
    canDelete = json['canDelete'];
    createTime = json['createTime'];
    showTime = json['showTime'];
    if (json['replyList'] != null) {
      final array = List<Map<String, dynamic>>.from(json['replyList'] ?? []);
      replyList = array.map((e) => NewsDiscussDetailModel.fromJson(e)).toList();
    }
    followNumber = json['followNumber'];

    parent = json['parent'] != null ? NewsDiscussDetailModel.fromJson(json['parent'] as Map<String, dynamic>) : null;
    parentContent = json['parentContent'];
    parentImageUrls = List<String>.from(json['parentImageUrls'] ?? <String>[]);
    if (replyToCustomerInfo != null) {
      parent ??= NewsDiscussDetailModel(
        customerInfo: replyToCustomerInfo,
        parentId: parentId,
        message: parentContent,
        imageUrls: parentImageUrls,
      );
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['commentId'] = commentId;
    map['parentId'] = parentId;
    map['customerId'] = customerId;
    if (customerInfo != null) {
      map['customerInfo'] = customerInfo!.toJson();
    }
    if (replyToCustomerInfo != null) {
      map['replyToCustomerInfo'] = replyToCustomerInfo!.toJson();
    }
    map['content'] = message;
    map['imageUrls'] = imageUrls;
    map['likeCount'] = likeNumber;
    map['isLike'] = like;
    map['canDelete'] = canDelete;
    map['createTime'] = createTime;
    map['showTime'] = showTime;
    map['parent'] = parent;
    map['replyList'] = replyList?.map((v) => v.toJson()).toList();
    map['followNumber'] = followNumber;
    return map;
  }
}
