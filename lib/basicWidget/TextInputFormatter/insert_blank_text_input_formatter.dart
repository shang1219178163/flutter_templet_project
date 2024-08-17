import 'package:flutter/services.dart';

/// 每四位数字加空格
class InsertBlankTextInputFormatter extends TextInputFormatter {
  InsertBlankTextInputFormatter({
    this.step = 4,
  });

  final int step;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // print(" baseoffse is  ${newValue.selection.baseOffset}");
    //光标的位置 从0开始
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    //获取输入的文本
    var inuptData = newValue.text;
    //创建字符缓存体
    var stringBuffer = StringBuffer();

    for (var i = 0; i < inuptData.length; i++) {
      //获取每一个字条 inuptData[i]
      stringBuffer.write(inuptData[i]);
      //index 当前字条的位置
      var index = i + 1;
      //每四个字条中间添加一个空格 最后一位不在考虑范围里
      if (index % step == 0 && inuptData.length != index) {
        stringBuffer.write("  ");
      }
    }
    return TextEditingValue(
      //当前的文本
      text: stringBuffer.toString(),
      //光标的位置
      selection: TextSelection.collapsed(
        //设置光标的位置在 文本最后
        offset: stringBuffer.toString().length,
      ),
    );
  }
}
