/// 评论模块错误码
enum DiscussErrorType {
  /// 评论内容不能为空
  contentEmpty(
    value: 10191,
    desc: '评论内容不能为空',
  ),

  /// 评论内容包含敏感词汇，请修改
  containsSensitiveWords(
    value: 10192,
    desc: '评论内容包含敏感词汇，请修改',
  ),

  /// 系统繁忙，请稍后重试
  systemBusy(
    value: 10193,
    desc: '系统繁忙，请稍后重试',
  ),

  /// 图片数量超出限制
  imageTooMany(
    value: 10195,
    desc: '图片数量超出限制',
  ),

  /// 资讯不存在
  articleNotExist(
    value: 10196,
    desc: '资讯不存在',
  ),

  /// 评论不存在
  commentNotExist(
    value: 10197,
    desc: '评论不存在',
  ),

  /// 只能删除自己的评论
  deleteForbidden(
    value: 10198,
    desc: '只能删除自己的评论',
  ),

  /// parentType 不合法
  parentTypeInvalid(
    value: 10199,
    desc: 'parentType 不合法',
  ),

  /// 目标类型不合法
  targetTypeInvalid(
    value: 10201,
    desc: '目标类型不合法',
  );

  const DiscussErrorType({
    required this.value,
    required this.desc,
  });

  /// 错误码
  final int value;

  /// 错误描述
  final String desc;

  /// 根据错误码获取枚举
  static DiscussErrorType? valueOf(int? v) {
    return values.where((e) => e.value == v).firstOrNull;
  }

  /// 是否为已知错误码
  static bool contains(int? code) => valueOf(code) != null;
}
