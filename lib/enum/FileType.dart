import 'package:flutter_templet_project/generated/assets.dart';

/// 文件类型
enum IMFileType {
  unknow(Assets.imagesIconFileWord),
  docx(Assets.imagesIconFileWord),
  doc(Assets.imagesIconFileWord),
  xls(Assets.imagesIconFileExcel),
  xlsx(Assets.imagesIconFileExcel),
  ppt(Assets.imagesIconFilePpt),
  pptx(Assets.imagesIconFilePpt),
  pdf(Assets.imagesIconFilePdf);

  const IMFileType(this.iconName);

  final String iconName;
}
