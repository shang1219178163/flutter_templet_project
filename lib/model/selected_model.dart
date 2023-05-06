
///选择通用模型
class SelectedModel<T> {

  SelectedModel({
    required this.data,
    this.name,
    this.isSelected = false,
  });

  String? name;

  bool? isSelected;

  T data;
}
