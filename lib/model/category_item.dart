// --- CategoryItem Model (树状结构) ---
class CategoryItem {
  final int id;
  final String name;
  final String? logo; // logo 可能为空，所以是可空类型 String?
  final List<CategoryItem>? children; // children 可能为空，所以是可空类型 List?

  CategoryItem({
    required this.id,
    required this.name,
    this.logo,
    this.children,
  });

  // 工厂构造函数，用于从 JSON 创建 CategoryItem 实例（支持递归）
  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    // 处理 children 字段的递归解析
    var childrenList = json['children'] as List?;
    List<CategoryItem>? parsedChildren;
    if (childrenList != null) {
      parsedChildren = childrenList.map((childJson) => CategoryItem.fromJson(childJson)).toList();
    }

    return CategoryItem(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      children: parsedChildren,
    );
  }
}
