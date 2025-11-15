//
//  SizeFilterConvert.dart
//  flutter_templet_project
//
//  Created by shang on 2024/8/9 09:33.
//  Copyright © 2024/8/9 shang. All rights reserved.
//

import 'package:flutter_templet_project/extension/date_time_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/pages/demo/convert/ConvertProtocol.dart';

typedef LineRecord = ({String line, double num, String? comment});

class SizeFilterConvert extends ConvertProtocol {
  @override
  String get name => "tree 结构过滤大文件";

  @override
  String get message => "命令: tree -hf  > files.txt";

  @override
  String exampleTemplet() {
    return """
[2.5K]  .
├── [ 128]  ./abnormal
│   ├── [1.4K]  ./abnormal/icon_drug.png
│   └── [1.6K]  ./abnormal/icon_scheme.png
├── [ 320]  ./article
│   ├── [ 948]  ./article/icon_close.png
│   ├── [ 854]  ./article/icon_listen.png
│   ├── [ 542]  ./article/icon_pause.png
│   ├── [1.1K]  ./article/icon_play.png
│   ├── [7.8K]  ./article/icon_vinyl.png
│   ├── [ 15K]  ./article/icon_wechat.png
│   ├── [ 19K]  ./article/icon_wechat_friends.png
│   └── [ 11K]  ./article/voice_playing.json
├── [ 192]  ./dialog
│   ├── [ 25K]  ./dialog/img_dialog_bg.png
│   ├── [ 53K]  ./dialog/img_message.png
│   ├── [ 65K]  ./dialog/img_privacy.png
│   └── [ 63K]  ./dialog/img_setting.png
├── [ 384]  ./doctor_team
│   ├── [1.1K]  ./doctor_team/icon_document.png
│   ├── [1.8K]  ./doctor_team/icon_intro.png
│   ├── [4.3K]  ./doctor_team/icon_profile.png
│   ├── [3.3K]  ./doctor_team/icon_skilful.png
│   ├── [2.1K]  ./doctor_team/icon_team_member.png
│   ├── [125K]  ./doctor_team/img_bind_doctor.png
│   ├── [120K]  ./doctor_team/img_grade.png
│   ├── [ 20K]  ./doctor_team/img_practice.png
│   ├── [ 18K]  ./doctor_team/img_qualification.png
│   └── [120K]  ./doctor_team/img_save_doctor.png
├── [ 448]  ./health_index
│   ├── [3.2K]  ./health_index/icon_chart_custom.png
│   ├── [3.9K]  ./health_index/icon_chart_glucose.png
│   ├── [6.9K]  ./health_index/icon_chart_heart.png
│   ├── [ 358]  ./health_index/icon_chart_identification.png
│   ├── [4.0K]  ./health_index/icon_chart_oxygen.png
│   ├── [2.9K]  ./health_index/icon_chart_pressure.png
│   ├── [3.4K]  ./health_index/icon_chart_pulse.png
│   ├── [4.7K]  ./health_index/icon_chart_stature.png
│   ├── [4.4K]  ./health_index/icon_chart_temperature.png
│   ├── [5.4K]  ./health_index/icon_chart_weight.png
│   ├── [3.4K]  ./health_index/icon_no_more.png
│   └── [ 23K]  ./health_index/img_health_head.png
├── [1.2K]  ./health_plan
│   ├── [1.3K]  ./health_plan/icon_article.png
│   ├── [8.0K]  ./health_plan/icon_dagl.png
│   ├── [8.2K]  ./health_plan/icon_famb.png
│   ├── [ 494]  ./health_plan/icon_interest_arrow.png
│   ├── [1.4K]  ./health_plan/icon_interest_left.png
│   ├── [1.4K]  ./health_plan/icon_interest_right.png
│   ├── [8.5K]  ./health_plan/icon_mydc.png
│   ├── [1.3K]  ./health_plan/icon_notice.png
│   ├── [8.4K]  ./health_plan/icon_other.png
│   ├── [8.4K]  ./health_plan/icon_pic_text.png
│   ├── [ 723]  ./health_plan/icon_service_mark.png
│   ├── [3.9K]  ./health_plan/icon_service_select.png
│   ├── [8.1K]  ./health_plan/icon_sfgl.png
│   ├── [ 13K]  ./health_plan/icon_use_dagl.png
│   ├── [ 14K]  ./health_plan/icon_use_famb.png
│   ├── [ 14K]  ./health_plan/icon_use_mydc.png
│   ├── [ 14K]  ./health_plan/icon_use_other.png
│   ├── [ 14K]  ./health_plan/icon_use_pic_text.png
│   ├── [ 14K]  ./health_plan/icon_use_sfgl.png
│   ├── [ 14K]  ./health_plan/icon_use_video.png
│   ├── [ 14K]  ./health_plan/icon_use_voice.png
│   ├── [ 14K]  ./health_plan/icon_use_xjgl.png
│   ├── [ 13K]  ./health_plan/icon_use_yyfk.png
│   ├── [8.4K]  ./health_plan/icon_video.png
│   ├── [ 12K]  ./health_plan/icon_vip.png
│   ├── [7.4K]  ./health_plan/icon_voice.png
│   ├── [8.4K]  ./health_plan/icon_xjgl.png
│   ├── [8.1K]  ./health_plan/icon_yyfk.png
│   ├── [ 61K]  ./health_plan/img_doctor.png
│   ├── [ 88K]  ./health_plan/img_doctor_1.png
│   ├── [165K]  ./health_plan/img_gold_card.png
│   ├── [ 67K]  ./health_plan/img_gold_light.png
│   ├── [5.7K]  ./health_plan/img_logo.png
│   ├── [130K]  ./health_plan/img_service_guide.png
│   ├── [371K]  ./health_plan/img_service_interest.png
│   └── [ 13K]  ./health_plan/line_health_plan.png
├── [1.2K]  ./home
│   ├── [ 11K]  ./home/icom_home_bt1.png
│   ├── [1.3K]  ./home/icon_add.png
│   ├── [ 424]  ./home/icon_doctor_arrow.png
│   ├── [1.6K]  ./home/icon_exceed_right.png
│   ├── [113K]  ./home/icon_home_bg.png
│   ├── [ 17K]  ./home/icon_home_bgjd.png
│   ├── [ 94K]  ./home/icon_home_calendar.png
│   ├── [2.5K]  ./home/icon_important_news.png
│   ├── [2.5K]  ./home/icon_important_news_text.png
│   ├── [1.8K]  ./home/icon_logo.png
│   ├── [ 933]  ./home/icon_msg_dtlb.png
│   ├── [1.0K]  ./home/icon_msg_jkxj.png
│   ├── [1.7K]  ./home/icon_msg_myddc.png
│   ├── [1.5K]  ./home/icon_msg_new.png
│   ├── [1023]  ./home/icon_msg_rcap.png
│   ├── [1.6K]  ./home/icon_msg_rctx.png
│   ├── [1.1K]  ./home/icon_msg_wdxx.png
│   ├── [1.1K]  ./home/icon_msg_yczb.png
│   ├── [1.6K]  ./home/icon_msg_yyyc.png
│   ├── [1.2K]  ./home/icon_msg_zcsc.png
│   ├── [2.4K]  ./home/icon_notice.png
│   ├── [ 481]  ./home/icon_reminder_pack_up.png
│   ├── [ 474]  ./home/icon_reminder_unfold.png
│   ├── [ 624]  ./home/icon_report_arrow.png
│   ├── [4.0K]  ./home/img_abnormal_feedback.png
│   ├── [3.7K]  ./home/img_buy_medical.png
│   ├── [ 84K]  ./home/img_cartoon_doctor.png
│   ├── [ 12K]  ./home/img_home_head.png
│   ├── [8.5K]  ./home/img_my_files.png
│   ├── [8.5K]  ./home/img_my_record.png
│   ├── [ 16K]  ./home/img_popular_science.png
│   ├── [5.9K]  ./home/img_popular_science_text.png
│   ├── [ 14K]  ./home/img_rehabilitation.png
│   ├── [5.3K]  ./home/img_rehabilitation_text.png
│   ├── [ 44K]  ./home/img_scan.png
│   └── [113K]  ./home/img_scan_bottom.png
├── [ 438]  ./icon_add_host.png
├── [8.8K]  ./icon_app_logo.png
├── [ 837]  ./icon_arrow_right.png
├── [ 947]  ./icon_arrow_right_.png
├── [ 461]  ./icon_big_plus.png
├── [1.4K]  ./icon_camera.png
├── [1.2K]  ./icon_clear.png
├── [1.4K]  ./icon_close.png
├── [ 613]  ./icon_close_host.png
├── [ 817]  ./icon_copy.png
├── [1.2K]  ./icon_delete.png
├── [ 540]  ./icon_edit.png
├── [ 13K]  ./icon_im_auto_replay.png
├── [1.7K]  ./icon_index_down.png
├── [1.5K]  ./icon_index_up.png
├── [1.0K]  ./icon_keyboard_delete.png
├── [1.3K]  ./icon_label.png
├── [2.8K]  ./icon_label_host.png
├── [ 226]  ./icon_minus_host.png
├── [ 393]  ./icon_more_spot.png
├── [1.7K]  ./icon_multiple.png
├── [ 451]  ./icon_multiple_line.png
├── [ 215]  ./icon_multiple_none.png
├── [ 696]  ./icon_multiple_selected.png
├── [1.2K]  ./icon_notice.png
├── [1.2K]  ./icon_notice_yellow.png
├── [ 309]  ./icon_plus_white.png
├── [ 760]  ./icon_screen.png
├── [2.1K]  ./icon_search.png
├── [1.7K]  ./icon_sex_male.png
├── [1.6K]  ./icon_sex_woman.png
├── [1.2K]  ./icon_share.png
├── [1.9K]  ./icon_single.png
├── [ 746]  ./icon_single_line.png
├── [ 477]  ./icon_single_none.png
├── [ 980]  ./icon_single_selected.png
├── [ 929]  ./icon_time_host.png
├── [ 647]  ./icon_tips_red.png
├── [2.2K]  ./img_article_default.png
├── [ 883]  ./img_default.png
├── [128K]  ./img_doctor_default.png
├── [1.3K]  ./img_drug_default.png
├── [283K]  ./img_group_default.png
├── [ 86K]  ./img_health_manage_default.png
├── [879K]  ./img_launch.png
├── [ 14K]  ./img_logo.png
├── [ 43K]  ./img_page_data.png
├── [ 42K]  ./img_page_delete.png
├── [ 42K]  ./img_page_fail.png
├── [ 93K]  ./img_page_head.png
├── [ 31K]  ./img_page_offShelf.png
├── [ 44K]  ./img_page_success.png
├── [129K]  ./img_patient_m_default.png
├── [159K]  ./img_patient_w_default.png
├── [ 416]  ./login
│   ├── [ 192]  ./login/ali_auth
│   │   ├── [ 34K]  ./login/ali_auth/app_logo.png
│   │   ├── [1.1M]  ./login/ali_auth/background.png
│   │   ├── [ 90K]  ./login/ali_auth/login_btn.png
│   │   └── [5.5K]  ./login/ali_auth/login_btn_unchecked.png
│   ├── [4.7K]  ./login/icon_apple.png
│   ├── [3.5K]  ./login/icon_center_logo.png
│   ├── [ 705]  ./login/icon_close.png
│   ├── [1.7K]  ./login/icon_eye_close.png
│   ├── [2.0K]  ./login/icon_eye_open.png
│   ├── [4.0K]  ./login/icon_phone.png
│   ├── [4.7K]  ./login/icon_pwd.png
│   ├── [ 307]  ./login/icon_read_tips.png
│   ├── [5.4K]  ./login/icon_wechat.png
│   └── [790K]  ./login/img_login_bg.png
├── [ 320]  ./medicine
│   ├── [3.2K]  ./medicine/icon_chinese_medicine.png
│   ├── [4.8K]  ./medicine/icon_instrument.png
│   ├── [2.1K]  ./medicine/icon_label_class_a.png
│   ├── [2.2K]  ./medicine/icon_label_class_b.png
│   ├── [1.5K]  ./medicine/icon_label_rx.png
│   ├── [3.1K]  ./medicine/icon_western_medicine.png
│   ├── [ 17K]  ./medicine/img_apply_rp.png
│   └── [6.7K]  ./medicine/img_apply_rp_none.png
├── [ 416]  ./message
│   ├── [ 62K]  ./message/bg_consultation_service.png
│   ├── [ 57K]  ./message/bg_rehabilitation_service.png
│   ├── [6.0K]  ./message/icon_consultation_service.png
│   ├── [1.1K]  ./message/icon_consultation_title.png
│   ├── [3.7K]  ./message/icon_disease_data_added.png
│   ├── [3.5K]  ./message/icon_disease_data_noadded.png
│   ├── [1.4K]  ./message/icon_rehab_guidance.png
│   ├── [6.9K]  ./message/icon_rehabilitation_service.png
│   ├── [1.3K]  ./message/icon_rehabilitation_title.png
│   ├── [2.4K]  ./message/icon_system_msg.png
│   └── [ 13K]  ./message/image_disease_data_bg.webp
├── [1.0K]  ./mine
│   ├── [ 477]  ./mine/arrow_down.png
│   ├── [1.4K]  ./mine/icon_answer.png
│   ├── [1.0K]  ./mine/icon_ask.png
│   ├── [2.8K]  ./mine/icon_bind_doctor.png
│   ├── [1.1K]  ./mine/icon_down_arrow.png
│   ├── [ 44K]  ./mine/icon_files.png
│   ├── [1.9K]  ./mine/icon_follow_up.png
│   ├── [1.7K]  ./mine/icon_my_file.png
│   ├── [2.2K]  ./mine/icon_my_order.png
│   ├── [2.0K]  ./mine/icon_my_plan.png
│   ├── [1.9K]  ./mine/icon_pic.png
│   ├── [2.1K]  ./mine/icon_pic_grey.png
│   ├── [3.6K]  ./mine/icon_setting.png
│   ├── [3.6K]  ./mine/icon_treatment_records.png
│   ├── [1.2K]  ./mine/icon_type_record.png
│   ├── [1.1K]  ./mine/icon_up_arrow.png
│   ├── [1.4K]  ./mine/icon_user_auth.png
│   ├── [ 800]  ./mine/icon_user_right.png
│   ├── [ 23K]  ./mine/img_consultation_order.png
│   ├── [ 61K]  ./mine/img_file_healthy.png
│   ├── [ 69K]  ./mine/img_file_history.png
│   ├── [ 52K]  ./mine/img_file_record.png
│   ├── [ 77K]  ./mine/img_file_self.png
│   ├── [ 97K]  ./mine/img_mine_head.png
│   ├── [407K]  ./mine/img_my_files_bg.png
│   ├── [ 26K]  ./mine/img_my_upload.png
│   ├── [ 23K]  ./mine/img_product_order.png
│   ├── [ 42K]  ./mine/img_real_name.png
│   ├── [ 29K]  ./mine/img_rehabilitation_order.png
│   ├── [275K]  ./mine/img_user_auth_m.png
│   └── [277K]  ./mine/img_user_auth_w.png
├── [ 384]  ./nav
│   ├── [2.1K]  ./nav/icon_home.png
│   ├── [   0]  ./nav/icon_home.svg
│   ├── [5.0K]  ./nav/icon_home_hover.png
│   ├── [1.5K]  ./nav/icon_message.png
│   ├── [   0]  ./nav/icon_message.svg
│   ├── [1.3K]  ./nav/icon_message_hover.png
│   ├── [2.3K]  ./nav/icon_mine.png
│   ├── [1.8K]  ./nav/icon_mine_hover.png
│   ├── [1.8K]  ./nav/icon_schedule.png
│   └── [1.5K]  ./nav/icon_schedule_hover.png
├── [ 768]  ./order
│   ├── [3.1K]  ./order/icon_already_pay.png
│   ├── [2.9K]  ./order/icon_cancel.png
│   ├── [3.0K]  ./order/icon_complete.png
│   ├── [3.7K]  ./order/icon_express_phone.png
│   ├── [ 597]  ./order/icon_mass_triangle.png
│   ├── [1.5K]  ./order/icon_nav.png
│   ├── [2.1K]  ./order/icon_payment_alipay.png
│   ├── [1.6K]  ./order/icon_payment_behalf.png
│   ├── [1.3K]  ./order/icon_payment_offline.png
│   ├── [ 44K]  ./order/icon_payment_species.png
│   ├── [1.9K]  ./order/icon_payment_wechat.png
│   ├── [2.7K]  ./order/icon_refund.png
│   ├── [3.3K]  ./order/icon_refund_fail.png
│   ├── [ 399]  ./order/icon_split_line.png
│   ├── [2.7K]  ./order/icon_wait_pay.png
│   ├── [ 94K]  ./order/img_express_head.png
│   ├── [109K]  ./order/img_goods_card.png
│   ├── [5.5K]  ./order/img_num.png
│   ├── [3.4K]  ./order/img_order_sawtooth.png
│   ├── [ 33K]  ./order/img_pay_fail.png
│   ├── [ 31K]  ./order/img_pay_success.png
│   └── [ 23K]  ./order/img_pay_wait.png
├── [1.1K]  ./question
│   ├── [ 155]  ./question/icon_add.png
│   ├── [ 438]  ./question/icon_add_host.png
│   ├── [ 837]  ./question/icon_arrow_right.png
│   ├── [ 461]  ./question/icon_big_plus.png
│   ├── [1.2K]  ./question/icon_clear.png
│   ├── [ 613]  ./question/icon_close_host.png
│   ├── [ 645]  ./question/icon_delete.png
│   ├── [2.2K]  ./question/icon_dotted_line.png
│   ├── [2.8K]  ./question/icon_medication.png
│   ├── [1.7K]  ./question/icon_multiple.png
│   ├── [ 451]  ./question/icon_multiple_line.png
│   ├── [ 215]  ./question/icon_multiple_none.png
│   ├── [ 696]  ./question/icon_multiple_selected.png
│   ├── [1.1K]  ./question/icon_pack_down.png
│   ├── [1.1K]  ./question/icon_pack_up.png
│   ├── [3.1K]  ./question/icon_repor_time.png
│   ├── [2.5K]  ./question/icon_save_draft.png
│   ├── [1.9K]  ./question/icon_single.png
│   ├── [ 746]  ./question/icon_single_line.png
│   ├── [ 477]  ./question/icon_single_none.png
│   ├── [ 980]  ./question/icon_single_selected.png
│   ├── [1.5K]  ./question/icon_star_select.png
│   ├── [1.4K]  ./question/icon_star_unselect.png
│   ├── [ 295]  ./question/icon_sub_down.png
│   ├── [ 297]  ./question/icon_sub_up.png
│   ├── [1.5K]  ./question/icon_title_left.png
│   ├── [1.5K]  ./question/icon_title_right.png
│   ├── [1.2K]  ./question/icon_video_link.png
│   ├── [ 58K]  ./question/img_answer_head.png
│   ├── [ 42K]  ./question/img_invalid.png
│   ├── [3.5K]  ./question/img_scoring_tips.png
│   └── [ 44K]  ./question/img_success.png
├── [ 448]  ./report
│   ├── [ 730]  ./report/icon_alert_close.png
│   ├── [5.6K]  ./report/icon_alert_image.png
│   ├── [5.4K]  ./report/icon_alert_pdf.png
│   ├── [ 403]  ./report/icon_down.png
│   ├── [ 463]  ./report/icon_more.png
│   ├── [1.1K]  ./report/icon_pdf.png
│   ├── [ 506]  ./report/icon_pdf_close.png
│   ├── [1.4K]  ./report/icon_select.png
│   ├── [ 504]  ./report/icon_tip.png
│   ├── [ 603]  ./report/icon_unselect.png
│   ├── [155K]  ./report/image_bg.png
│   └── [175K]  ./report/image_detail_bg.png
├── [ 288]  ./reservation
│   ├── [5.4K]  ./reservation/icon_font_reject.png
│   ├── [ 63K]  ./reservation/icon_result_calendar_green.png
│   ├── [ 56K]  ./reservation/icon_result_calendar_red.png
│   ├── [ 61K]  ./reservation/icon_result_calendar_yellow.png
│   ├── [1.4K]  ./reservation/icon_result_pass.png
│   ├── [1.2K]  ./reservation/icon_result_reject.png
│   └── [ 834]  ./reservation/icon_result_think.png
├── [ 672]  ./rp
│   ├── [1.4K]  ./rp/icon_chinese_medicine.png
│   ├── [1.6K]  ./rp/icon_detection.png
│   ├── [2.0K]  ./rp/icon_instrument.png
│   ├── [1.2K]  ./rp/icon_paper.png
│   ├── [1.7K]  ./rp/icon_people.png
│   ├── [1.3K]  ./rp/icon_refuse.png
│   ├── [1007]  ./rp/icon_remark.png
│   ├── [1.0K]  ./rp/icon_western_medicine.png
│   ├── [142K]  ./rp/img_doctor.png
│   ├── [ 33K]  ./rp/img_examine.png
│   ├── [ 32K]  ./rp/img_expired.png
│   ├── [243K]  ./rp/img_follow_up.png
│   ├── [8.0K]  ./rp/img_item_bg.png
│   ├── [ 40K]  ./rp/img_not_used.png
│   ├── [227K]  ./rp/img_recommend_medication.png
│   ├── [ 38K]  ./rp/img_refused.png
│   ├── [243K]  ./rp/img_treatment_recommendation.png
│   ├── [243K]  ./rp/img_treatment_records.png
│   └── [ 39K]  ./rp/img_used.png
├── [ 224]  ./scan
│   ├── [1.4K]  ./scan/icon_flashlight_close.png
│   ├── [1.1K]  ./scan/icon_flashlight_open.png
│   ├── [ 815]  ./scan/icon_input.png
│   ├── [1.1K]  ./scan/icon_photo.png
│   └── [2.9K]  ./scan/img_scan_identify.png
├── [ 544]  ./schedule
│   ├── [ 826]  ./schedule/icon_complete.png
│   ├── [ 568]  ./schedule/icon_incomplete.png
│   ├── [2.2K]  ./schedule/icon_note.png
│   ├── [ 615]  ./schedule/icon_pending.png
│   ├── [3.4K]  ./schedule/icon_position.png
│   ├── [ 13K]  ./schedule/icon_rec_cat.png
│   ├── [3.5K]  ./schedule/icon_scheme_text.png
│   ├── [ 14K]  ./schedule/icon_shopping_cart.png
│   ├── [ 550]  ./schedule/icon_uncomplete.png
│   ├── [8.4K]  ./schedule/img_complete_bg.png
│   ├── [ 13K]  ./schedule/img_incomplete_bg.png
│   ├── [ 19K]  ./schedule/img_pending_bg.png
│   ├── [ 38K]  ./schedule/img_recommend_medication.png
│   ├── [ 43K]  ./schedule/rec_drug_bg.png
│   └── [ 12K]  ./schedule/rec_left_flot_btn.gif
├── [ 160]  ./service
│   ├── [1.6K]  ./service/icon_audio.png
│   ├── [2.5K]  ./service/icon_image_text.png
│   └── [1.5K]  ./service/icon_video.png
├── [ 608]  ./system_msg
│   ├── [1.3K]  ./system_msg/icon_abnormal.png
│   ├── [1.9K]  ./system_msg/icon_abnormal_active.png
│   ├── [1.1K]  ./system_msg/icon_arrange.png
│   ├── [1.6K]  ./system_msg/icon_arrange_active.png
│   ├── [ 466]  ./system_msg/icon_arrow_down.png
│   ├── [1.4K]  ./system_msg/icon_myddc.png
│   ├── [2.6K]  ./system_msg/icon_myddc_active.png
│   ├── [1.4K]  ./system_msg/icon_qfxx.png
│   ├── [2.5K]  ./system_msg/icon_qfxx_active.png
│   ├── [1.3K]  ./system_msg/icon_remind.png
│   ├── [1.9K]  ./system_msg/icon_remind_active.png
│   ├── [1.3K]  ./system_msg/icon_sfwj.png
│   ├── [2.0K]  ./system_msg/icon_sfwj_active.png
│   ├── [1.4K]  ./system_msg/icon_xjgl.png
│   ├── [2.4K]  ./system_msg/icon_xjgl_active.png
│   ├── [1.2K]  ./system_msg/icon_zcsc.png
│   └── [1.8K]  ./system_msg/icon_zcsc_active.png
└── [ 320]  ./template
    ├── [ 867]  ./template/icon_read_aloud.png
    ├── [1.4K]  ./template/icon_shopping_cart.png
    ├── [2.6K]  ./template/icon_weChat.png
    ├── [2.9K]  ./template/icon_weChat_moments.png
    ├── [ 49K]  ./template/img_health_hat.png
    ├── [6.8K]  ./template/img_health_text.png
    ├── [6.0K]  ./template/img_rehab_text.png
    └── [273K]  ./template/img_scheme_head.png
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
    final exports = lines.where((e) {
      if (!e.contains("[") || !e.contains("]")) {
        return false;
      }
      // if (e.contains("dialog/")) {
      //   DLog.d("${lines.indexOf(content)}:$e");
      // }

      var parts = e.split(RegExp(r'[\[\]]'));
      final size = parts[1];
      if (!size.contains("K")) {
        return false;
      }
      final num = double.tryParse(size.replaceFirst("K", "").trim()) ?? 0;
      final result = num > 20.0; //大于 20 kb都显示
      // if (result) {
      //   DLog.d("${lines.indexOf(content)}:$e, $num, $result");
      // }
      return result;
    }).toList();

    final filterExports = exports.map((e) {
      var parts = e.split(RegExp(r'[\[\]]'));
      final sizeStr = parts[1];
      final numStr = sizeStr.replaceFirst("K", "").trim();
      final num = double.tryParse(numStr) ?? 0;
      final result = (line: e, num: num, comment: "");
      return result;
    }).toList();

    final totalSize = filterExports.map((e) => e.num).reduce((v, e) => v + e);
    final totalSizeDesc = "${(totalSize / 1024).toStringAsFixed(2)}M";

    var clsName = "BigFile";
    var clsNameNew = clsName;

    final fileName = "${clsNameNew.toUncamlCase("_")}_${DateTime.now().toString19()}"
        ".dart";
    final contentNew = """
${exports.join("\n")}

totalSize: $totalSizeDesc
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
