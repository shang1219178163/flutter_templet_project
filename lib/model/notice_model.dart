///
///https://caijinglong.github.io/json2dart/index_ch.html
///
///

import 'package:json_annotation/json_annotation.dart';
  

@JsonSerializable()
  class NoticeModel extends Object with _$NoticeModelSerializerMixin{

  String message;

  Data data;

  String code;

  NoticeModel(this.message, this.data, this.code,);

  factory NoticeModel.fromJson(Map<String, dynamic> srcJson) => _$NoticeModelFromJson(srcJson);
  _$NoticeModelFromJson(Map<String, dynamic> srcJson) {}
}



  
@JsonSerializable()
  class Data extends Object with _$DataSerializerMixin{

  // ignore: non_constant_identifier_names
  String? end_time;

  String? content;

  String? msg_id;

  String? title;

  String? receive_status;

  String? start_time;

  String? msg_type;

  String? jump_url;

  String? shop_id;

  String? image;

  Data(this.end_time,
      this.content,
      this.msg_id,
      this.title,
      this.receive_status,
      this.start_time,
      this.msg_type,
      this.jump_url,
      this.shop_id,
      this.image,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  _$DataFromJson(Map<String, dynamic> srcJson) {}

}

  
