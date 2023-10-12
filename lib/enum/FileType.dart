

/// 文件类型
enum IMFileType{
  // unknow("icon_file_word.png"),

  docx("icon_file_word.png"),
  doc("icon_file_word.png"),
  xls("icon_file_excel.png.png"),
  xlsx("icon_file_excel.png"),
  ppt("icon_file_ppt.png"),
  pptx("icon_file_ppt.png"),
  pdf("icon_file_pdf.png");

  const IMFileType(this.iconName);

  final String iconName;

}