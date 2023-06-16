
///选择通用模型
class SelectModel<T> {

  SelectModel({
    required this.id,
    required this.title,
    this.data,
    this.isSelected = false,
  });

  String? id;

  String? title;

  bool? isSelected;
  /// 通用数据
  T? data;


  SelectModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    id = json['id'];
    title = json['title'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['isSelected'] = isSelected;
    return data;
  }
}
