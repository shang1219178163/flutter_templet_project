import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_box_segment_control.dart';

/// 展示用中英语言。
enum NLangEnum {
  en('EN'),
  zh('中文');

  const NLangEnum(this.label);

  /// 分段控件文案。
  final String label;
}

/// 可嵌入的中英切换控件。
class NLangSegmentControl extends StatelessWidget {
  const NLangSegmentControl({
    super.key,
    required this.value,
    required this.onChanged,
  });

  /// 当前语言。
  final NLangEnum value;

  /// 切换回调。
  final ValueChanged<NLangEnum> onChanged;

  @override
  Widget build(BuildContext context) {
    return NBoxSegmentControl<NLangEnum>(
      items: NLangEnum.values,
      index: value.index,
      onChanged: (i) => onChanged(NLangEnum.values[i]),
      itemBuilder: (context, language, selected) {
        return Text(language.label);
      },
    );
  }
}
