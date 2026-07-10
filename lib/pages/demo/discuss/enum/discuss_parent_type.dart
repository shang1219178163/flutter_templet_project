/// 父评论类型
///
/// 当 parentId > 0 时必传，用于区分同 ID 的根评论和子回复。
enum DiscussParentType {
  /// 文章
  article(
    value: 'ARTICLE',
    desc: '文章',
  ),

  /// 根评论
  root(
    value: 'ROOT',
    desc: '根评论',
  ),

  /// 子回复
  reply(
    value: 'REPLY',
    desc: '子回复',
  );

  const DiscussParentType({
    required this.value,
    required this.desc,
  });

  /// 接口值
  final String value;

  /// 描述
  final String desc;

  /// 默认值
  static const DiscussParentType defaultValue = DiscussParentType.article;

  /// 根据接口值解析
  static DiscussParentType fromValue(String? value) {
    return DiscussParentType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => defaultValue,
    );
  }

  @override
  String toString() => value;
}
