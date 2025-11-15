//
//  PackageExportConvert.dart
//  flutter_templet_project
//
//  Created by shang on 2024/8/9 09:33.
//  Copyright © 2024/8/9 shang. All rights reserved.
//

import 'package:flutter_templet_project/extension/src/string_ext.dart';
import 'package:flutter_templet_project/pages/demo/convert/ConvertProtocol.dart';

class PackageExportConvert extends ConvertProtocol {
  @override
  String get name => "tree 结构转包导出文件";

  @override
  String get message => "命令: tree -f  > files.txt";

  /// 执行 tree -f  > files.txt
  @override
  String exampleTemplet() {
    return """
.
├── ./constant.dart
├── ./old
│   ├── ./old/README.md
│   ├── ./old/address_picker.dart
│   ├── ./old/address_picker_route.dart
│   ├── ./old/enhance_expansion_tile.dart
│   ├── ./old/flutter_picker.dart
│   ├── ./old/get_bottom_sheet.dart
│   ├── ./old/get_dialog.dart
│   ├── ./old/get_multiple_picker.dart
│   ├── ./old/get_single_picker.dart
│   ├── ./old/local_address_model.dart
│   ├── ./old/my_button.dart
│   ├── ./old/my_text.dart
│   ├── ./old/n_badge.dart
│   └── ./old/n_bottom_navigation_bar.dart
├── ./theme
│   ├── ./theme/app_bar_theme.dart
│   ├── ./theme/app_theme.dart
│   ├── ./theme/arrow_theme.dart
│   ├── ./theme/avatar_change_theme.dart
│   ├── ./theme/button_theme.dart
│   ├── ./theme/choice_box_theme.dart
│   ├── ./theme/collection_view_theme.dart
│   ├── ./theme/dash_line_theme.dart
│   ├── ./theme/date_start_end_theme.dart
│   ├── ./theme/date_time_picker_theme.dart
│   ├── ./theme/empty_theme.dart
│   ├── ./theme/expand_text_theme.dart
│   ├── ./theme/expansion_menu_theme.dart
│   ├── ./theme/expansion_order_menu_theme.dart
│   ├── ./theme/expansion_photo_menu_theme.dart
│   ├── ./theme/expansion_tile_theme.dart
│   ├── ./theme/filter_drop_box_theme.dart
│   ├── ./theme/footer_button_bar_theme.dart
│   ├── ./theme/four_corner_theme.dart
│   ├── ./theme/gradient_tag_theme.dart
│   ├── ./theme/grid_view_theme.dart
│   ├── ./theme/horizal_bar_theme.dart
│   ├── ./theme/icon_theme.dart
│   ├── ./theme/image_theme.dart
│   ├── ./theme/input_theme.dart
│   ├── ./theme/long_press_menu_theme.dart
│   ├── ./theme/navigation_bar_theme.dart
│   ├── ./theme/network_image_theme.dart
│   ├── ./theme/pair_theme.dart
│   ├── ./theme/picker_list_view_theme.dart
│   ├── ./theme/picker_tool_bar_theme.dart
│   ├── ./theme/placeholder_theme.dart
│   ├── ./theme/pop_retain_theme.dart
│   ├── ./theme/record_expansion_menu_theme.dart
│   ├── ./theme/refresh_view_theme.dart
│   ├── ./theme/search_theme.dart
│   ├── ./theme/section_header_theme.dart
│   ├── ./theme/skeleton_screen_theme.dart
│   ├── ./theme/tab_bar_theme.dart
│   ├── ./theme/target_follower_theme.dart
│   ├── ./theme/text_field_theme.dart
│   ├── ./theme/text_theme.dart
│   ├── ./theme/ticket_divder_theme.dart
│   ├── ./theme/title_theme.dart
│   └── ./theme/transition_builder_theme.dart
└── ./widget
    ├── ./widget/app_bar.dart
    ├── ./widget/arrow.dart
    ├── ./widget/avatar_change.dart
    ├── ./widget/button.dart
    ├── ./widget/choice_box.dart
    ├── ./widget/collection_view.dart
    ├── ./widget/dash_line.dart
    ├── ./widget/date_start_end.dart
    ├── ./widget/date_time_picker.dart
    ├── ./widget/empty.dart
    ├── ./widget/expand_text.dart
    ├── ./widget/expansion_cross_fade.dart
    ├── ./widget/expansion_menu.dart
    ├── ./widget/expansion_order_menu.dart
    ├── ./widget/expansion_photo_menu.dart
    ├── ./widget/expansion_tile.dart
    ├── ./widget/filter_button.dart
    ├── ./widget/filter_drop_box.dart
    ├── ./widget/footer_button_bar.dart
    ├── ./widget/four_corner.dart
    ├── ./widget/gradient_tag.dart
    ├── ./widget/grid_view.dart
    ├── ./widget/horizal_bar.dart
    ├── ./widget/icon.dart
    ├── ./widget/image.dart
    ├── ./widget/indicator.dart
    ├── ./widget/input.dart
    ├── ./widget/long_press_menu.dart
    ├── ./widget/navigation_bar.dart
    ├── ./widget/network_image.dart
    ├── ./widget/pair.dart
    ├── ./widget/picker_list_view.dart
    ├── ./widget/picker_tool_bar.dart
    ├── ./widget/placeholder.dart
    ├── ./widget/pop_retain.dart
    ├── ./widget/popup_part.dart
    ├── ./widget/record_expansion_menu.dart
    ├── ./widget/refresh_view.dart
    ├── ./widget/search.dart
    ├── ./widget/section_header.dart
    ├── ./widget/skeleton_screen.dart
    ├── ./widget/slide_transition_builder.dart
    ├── ./widget/target_follower.dart
    ├── ./widget/text.dart
    ├── ./widget/text_field.dart
    ├── ./widget/text_marquee.dart
    ├── ./widget/ticket_divder.dart
    ├── ./widget/title.dart
    ├── ./widget/transition_builder.dart
    ├── ./widget/yl_tab_bar.dart
    └── ./widget/yl_tab_bar_indicator_fixed.dart
""";
  }

  // @override
  // Future<ConvertModel?> convertFile({required File file}) async {
  //   final name = file.path.split("/").last;
  //   String content = await file.readAsString();
  //   return convert(content: content, name: name);
  // }

  @override
  Future<ConvertModel?> convert({
    required String productName,
    String? name,
    required String content,
  }) async {
    if (content.isEmpty) {
      return null;
    }

    final lines = content.split("\n");
    final darts = lines.where((e) => e.endsWith(".dart")).toList();

    final exports = darts.map((e) {
      final tmp = e.split("./").last;
      final result = "export 'src/$tmp';";
      return result;
    }).toList();

    var clsName = "PackageName";
    var clsNameNew = clsName;

    final fileName = "${clsNameNew.toUncamlCase("_")}.dart";
    final contentNew = """
library $fileName;
    
${exports.join("\n")}
    """;

    return ConvertModel(
      productName: productName,
      name: name ?? clsName,
      content: content,
      nameNew: fileName,
      contentNew: contentNew,
    );
  }
}
