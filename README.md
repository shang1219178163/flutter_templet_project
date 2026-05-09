# flutter_templet_project

个人模板工程, 支持 iOS, andriod, web, mac, window.

achive：
```
flutter build ios --release --dart-define=CHANNEL=GSY --dart-define=LANGUAGE=Dart
```

## 一、项目结构
#### 1、树形结构图
```
├── android (包含 fastlane 打包脚本)
├── ios (包含 fastlane 打包脚本)
├── lib
│   ├── APPThemeSettings.dart (主题设置)
│   ├── basicWidget (组件封装,N开头的是稳定版,核心之一)
│   ├── cache (数据缓存和文件管理类)
│   ├── enum (枚举类型)
│   ├── eventbus (弃用)
│   ├── extension (类型功能扩展,核心之一)
│   ├── main.dart (项目入口)
│   ├── mixin (mixin 封装,通常是赋予类各种共用方法和属性,提高代码复用性,简化冗余代码)
│   ├── model (测试数据载体)
│   ├── network (网络封装)
│   ├── pages (各种 demo 演示页)
│   ├── provider (各种状态管理库测试 demo 目录)
│   ├── routes (路由管理)
│   ├── service (网络状态管理,前后台切换状态封装单例类)
│   ├── util (没有合适地方放的公用工具类)
│   └── vendor (引入的第三方及二次封装示例)
```

#### 2、basicWidget 自定义基础组件 200+

```.
├── CircleLayout.dart
├── CircleSectorProgressIndicator.dart
├── EnhanceTab
│   ├── en_tab_bar.dart
│   └── en_tab_bar_demo.dart
├── ExpandButtons
│   ├── expand_icons.dart
│   └── expand_layout.dart
├── FloatingActionButtonLocationOffset.dart
├── GradientBoundPainter.dart
├── NRequestBox
│   ├── n_request_box.dart
│   └── n_request_box_demo.dart
├── NSystemThemeTab.dart
├── NTree
│   ├── NTree.dart
│   └── NTreeDemo.dart
├── PickerUtil.dart
├── PromptBuilder.dart
├── RectProgressClipper.dart
├── SliverCustomRefreshLoadWidget.dart
├── TextInputFormatter
│   ├── block_text_input_formatter.dart
│   ├── decimal_input_formatter.dart
│   ├── fraction_digits_text_input_formatter.dart
│   ├── insert_blank_text_input_formatter.dart
│   └── int_clamp_text_input_formatter.dart
├── TicketUI.dart
├── ToastWidget.dart
├── WheelPainter.dart
├── after_layout_builder.dart
├── animated_group.dart
├── app_update_card.dart
├── app_upgrade_view.dart
├── asset_image_stretch.dart
├── basicWidget.txt
├── chioce_list.dart
├── chioce_wrap.dart
├── custom_swiper.dart
├── custome_animated.dart
├── dashed_decoration.dart
├── drag_destination_view.dart
├── enhance
│   ├── bottom_navigation_bar
│   │   └── n_bottom_navigation_bar.dart
│   ├── en_app_bar
│   │   └── en_app_bar.dart
│   ├── en_sliding_segmented_control
│   │   ├── en_sliding_segmented_control.dart
│   │   ├── n_sliding_segmented_control.dart
│   │   └── n_sliding_segmented_page_view.dart
│   ├── en_dialog_sheet
│   │   ├── en_bottom_sheet.dart
│   │   ├── en_dialog.dart
│   │   ├── en_display_feature_sub_screen.dart
│   │   └── en_routes.dart
│   ├── en_expansion
│   │   └── en_expansion_tile.dart
│   └── enhance_stepper
│       └── enhance_stepper.dart
├── error_custom_widget.dart
├── fade_builder.dart
├── form
│   ├── ae_address_choose_item.dart
│   ├── ae_card.dart
│   ├── ae_choose_item.dart
│   ├── ae_date_choose_item.dart
│   ├── ae_horizal_choose_item.dart
│   ├── ae_horizal_choose_mutil_item.dart
│   ├── ae_input_item.dart
│   ├── ae_judge_item.dart
│   ├── ae_patient_card.dart
│   ├── ae_questionnaire_card.dart
│   ├── ae_section_header.dart
│   ├── ae_single_choose_item.dart
│   ├── ae_textfiled.dart
│   ├── ae_time_choose_item.dart
│   ├── ae_time_line.dart
│   ├── ae_upload_document_item.dart
│   └── ae_upload_image_item.dart
├── horizontal_cell.dart
├── hud
│   ├── CirclePulseLoadingWidget.dart
│   ├── ToastDialog.dart
│   └── progresshud.dart
├── im_group_avatar.dart
├── im_reciple_bottom_sheet.dart
├── im_sound_record_bar.dart
├── im_sound_recording_page.dart
├── im_textfield_bar.dart
├── im_tip_bell_cell.dart
├── inner_shadow.dart
├── keep_alive_wrapper.dart
├── layout_log_print.dart
├── list_subtitle_cell.dart
├── marquee_widget.dart
├── merge_images_widget.dart
├── n_account_sheet.dart
├── n_account_sheet_new.dart
├── n_adaptive_text.dart
├── n_alert_dialog.dart
├── n_alignment_drawer.dart
├── n_animated_finger.dart
├── n_app_bar.dart
├── n_app_bar_them_change.dart
├── n_autocomplete_options_view.dart
├── n_autocomplete_search.dart
├── n_avatar_badge.dart
├── n_avatar_group.dart
├── n_badge.dart
├── n_blinking_text.dart
├── n_blur_view.dart
├── n_box.dart
├── n_box_border.dart
├── n_button.dart
├── n_button_cancel.dart
├── n_button_confirm.dart
├── n_button_floor.dart
├── n_cancel_and_confirm_bar.dart
├── n_choic_bottom_bar.dart
├── n_choice_box.dart
├── n_choice_box_horizontal.dart
├── n_choice_box_one.dart
├── n_choice_expansion.dart
├── n_choice_expansion_of_model.dart
├── n_choice_filter_box.dart
├── n_chrome_segment.dart
├── n_collection_nav_widget.dart
├── n_collection_view.dart
├── n_color_Animation.dart
├── n_context_menu.dart
├── n_context_menu_region.dart
├── n_convert_view.dart
├── n_cross_fade.dart
├── n_cross_fade_mask.dart
├── n_cross_notice.dart
├── n_cupertino_picker_list_view.dart
├── n_dash_decoration.dart
├── n_dash_line.dart
├── n_date_picker.dart
├── n_date_start_end.dart
├── n_drop_menu_filter_bar.dart
├── n_drop_menu_filter_section_bar.dart
├── n_empty.dart
├── n_ensure_visible.dart
├── n_enter_ball_anim.dart
├── n_expand_text.dart
├── n_expand_text_one.dart
├── n_expand_text_vertical.dart
├── n_expand_textfield.dart
├── n_expansion_fade.dart
├── n_expansion_menu.dart
├── n_fade_page_route.dart
├── n_fade_transition.dart
├── n_fade_transition_builder.dart
├── n_file_viewer
│   ├── n_file_viewer.dart
│   └── src
│       ├── NFileReader.dart
│       ├── NFileRegistry.dart
│       ├── NFileRenderer.dart
│       └── NFileViewer.dart
├── n_filter.dart
├── n_filter_button.dart
├── n_filter_drop_box.dart
├── n_filter_section.dart
├── n_flex_separated.dart
├── n_flexible_cell.dart
├── n_flexible_space_bar.dart
├── n_floating_button.dart
├── n_footer.dart
├── n_footer_button_bar.dart
├── n_four_corner.dart
├── n_future_builder.dart
├── n_gradient_mask.dart
├── n_grid_view.dart
├── n_horizontal_scroll_widget.dart
├── n_image_indicator.dart
├── n_image_loading.dart
├── n_image_preview.dart
├── n_indicator_point.dart
├── n_inner_shadow.dart
├── n_line_progress_indicator.dart
├── n_line_segment_view.dart
├── n_list_view_segment_control.dart
├── n_long_press_menu.dart
├── n_menu_anchor.dart
├── n_menu_anchor_for_image.dart
├── n_network_image.dart
├── n_network_online.dart
├── n_order_num_unit.dart
├── n_origin_sheet.dart
├── n_overlay.dart
├── n_page_view.dart
├── n_painter_arc.dart
├── n_pair.dart
├── n_pick_request_list_box.dart
├── n_pick_users_box.dart
├── n_picker_choice_view.dart
├── n_picker_list_view.dart
├── n_picker_tool_bar.dart
├── n_pinned_tab_bar_page.dart
├── n_placeholder.dart
├── n_point_indicator.dart
├── n_pop_view_box.dart
├── n_popup_route.dart
├── n_preferred_size_widget.dart
├── n_refresh_indicator.dart
├── n_refresh_view.dart
├── n_resize.dart
├── n_resize_switch.dart
├── n_scan_photo.dart
├── n_scroll_bar.dart
├── n_search_bar.dart
├── n_section_box.dart
├── n_secure_keyboard_focus.dart
├── n_seed_color_box.dart
├── n_segment_control_emoj_view.dart
├── n_segment_control_emoji.dart
├── n_selected_cell.dart
├── n_shader_text.dart
├── n_single_ticker_stateful_builder.dart
├── n_size_transition.dart
├── n_skeleton_item.dart
├── n_skeleton_screen.dart
├── n_slidable_delete_cell.dart
├── n_slidable_tabbar.dart
├── n_slide_transition.dart
├── n_slide_transition_builder.dart
├── n_slider.dart
├── n_sliver_decorated_box.dart
├── n_sliver_page.dart
├── n_sliver_page_one.dart
├── n_sliver_persistent_header_delegate.dart
├── n_sliver_section.dart
├── n_sliver_section_list.dart
├── n_split_view.dart
├── n_swiper_gesture_detector.dart
├── n_tab_bar_colored_box.dart
├── n_tab_bar_fixed_width_indicator.dart
├── n_tab_bar_indicator_fixed.dart
├── n_tab_bar_page.dart
├── n_tab_bar_page_custom.dart
├── n_tab_bar_view.dart
├── n_tab_page_view.dart
├── n_tabbar_indicator_box.dart
├── n_tag_box.dart
├── n_tag_box_new.dart
├── n_tap_gesture_intercept.dart
├── n_target_follower.dart
├── n_text.dart
├── n_text_button.dart
├── n_text_view.dart
├── n_textfield.dart
├── n_textfield_search.dart
├── n_textfield_unit.dart
├── n_third_login.dart
├── n_ticket_clipper.dart
├── n_ticket_divder.dart
├── n_ticket_divider_painter.dart
├── n_toggle_button.dart
├── n_transition_builder.dart
├── n_tween_transition.dart
├── n_type_writer_text.dart
├── n_user_privacy.dart
├── n_webview_page.dart
├── neumorphism_button.dart
├── number_stepper.dart
├── page_indicator_widget.dart
├── picker_drug_box.dart
├── radial_button.dart
├── record_expand_text.dart
├── responsive_column.dart
├── scroll
│   ├── EndBounceScrollPhysics.dart
│   ├── NCustomScrollBehavior.dart
│   ├── custom_page_controller.dart
│   ├── custom_page_view_scroll_physics.dart
│   └── custom_tab_controller.dart
├── search_results_list_view.dart
├── section_list_view.dart
├── skeleton_item.dart
├── sliver_decorate_box.dart
├── steper_connector.dart
├── theme
│   ├── n_button_theme.dart
│   └── n_search_theme.dart
├── triangle_decoration.dart
├── triangle_path.dart
├── tween_animated_widget.dart
├── upload
│   ├── asset_upload_box.dart
│   ├── asset_upload_box.md
│   ├── asset_upload_box_demo.dart
│   ├── asset_upload_button.dart
│   ├── asset_upload_config.dart
│   ├── asset_upload_model.dart
│   ├── image_service.dart
│   └── video_service.dart
├── upload_button.dart
├── upload_document
│   ├── asset_upload_document_box.dart
│   ├── asset_upload_document_box.md
│   ├── asset_upload_document_button.dart
│   └── asset_upload_document_model.dart
├── upload_file
│   ├── n_file_upload_Item.dart
│   ├── n_file_upload_box.dart
│   ├── n_file_upload_handle.dart
│   ├── n_file_upload_model.dart
│   └── n_file_upload_pi.dart
├── voice_animation_image.dart
├── x_box_widget.dart
├── x_collection_nav_widget.dart
└── x_horizontal_scroll_widget.dart

22 directories, 294 files
```

#### 3、extension： 自定义 SDK 59种类型功能扩展
```.
├── alignment_ext.dart
├── app_bar_ext.dart
├── asset_bundle_ext.dart
├── bar_code_ext.dart
├── bool_ext.dart
├── build_context_ext.dart
├── button_ext.dart
├── change_notifier_ext.dart
├── clipboard_ext.dart
├── color_ext.dart
├── date_time_ext.dart
├── decoration_ext.dart
├── dialog_ext.dart
├── divider_ext.dart
├── dlog.dart
├── duration_ext.dart
├── edge_insets_ext.dart
├── editable_text_ext.dart
├── enum_ext.dart
├── extension.txt
├── file_ext.dart
├── flex_ext.dart
├── floating_action_button_location_ext.dart
├── function_ext.dart
├── future_ext.dart
├── generic_comparable_ext.dart
├── geometry_ext.dart
├── getx_ext.dart
├── image_ext.dart
├── list_ext.dart
├── list_nullable_ext.dart
├── map_ext.dart
├── media_query_ext.dart
├── navigator_ext.dart
├── num_ext.dart
├── number_format.dart
├── object_ext.dart
├── orientation_ext.dart
├── overlay_ext.dart
├── page_controller_ext.dart
├── platform_ext.dart
├── proxy_box_ext.dart
├── regexp_ext.dart
├── rich_text_ext.dart
├── route_ext.dart
├── scroll_controller_ext.dart
├── service_protocol_info_ext.dart
├── set_ext.dart
├── snack_bar_ext.dart
├── stack_ext.dart
├── string_ext.dart
├── system_channels_ext.dart
├── system_chrome_ext.dart
├── tab_ext.dart
├── text_painter_ext.dart
├── text_style_ext.dart
├── timer_ext.dart
├── type_util.dart
└── widget_ext.dart

1 directory, 59 files
```


## 二、Flutter SDK 大版本升级命令

flutter pub upgrade --dry-run

flutter pub outdated

flutter pub upgrade --major-versions


## 三、Flutter pub package 认证文件路径 pub-credentials.json

/Users/shang/Library/Application Support/dart/pub-credentials.json