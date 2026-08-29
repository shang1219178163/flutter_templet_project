import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:github_language_colors/github_language_colors.dart';

class CityModel extends ISuspensionBean {

  CityModel({
    required this.name,
    this.tagIndex,
    this.namePinyin,
  });

  CityModel.fromJson(Map<String, dynamic> json) : name = json['name'];
  String name;
  String? tagIndex;
  String? namePinyin;

  Map<String, dynamic> toJson() => {
        'name': name,
//        'tagIndex': tagIndex,
//        'namePinyin': namePinyin,
//        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => tagIndex!;

  @override
  String toString() => jsonEncode(this);
}

class ContactInfo extends ISuspensionBean {

  ContactInfo({
    required this.name,
    this.tagIndex,
    this.namePinyin,
    this.bgColor,
    this.iconData,
    this.img,
    this.id,
    this.firstLetter,
  });

  ContactInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        img = json['img'],
        id = json['id']?.toString(),
        firstLetter = json['firstLetter'];
  String name;
  String? tagIndex;
  String? namePinyin;

  Color? bgColor;
  IconData? iconData;

  String? img;
  String? id;
  String? firstLetter;

  Map<String, dynamic> toJson() => {
//        'id': id,
        'name': name,
        'img': img,
//        'firstLetter': firstLetter,
//        'tagIndex': tagIndex,
//        'namePinyin': namePinyin,
//        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => tagIndex!;

  @override
  String toString() => jsonEncode(this);
}

class Languages extends GithubLanguage with ISuspensionBean {

  Languages.fromJson(Map<String, dynamic> json) : super.fromJson(json);
  String? tagIndex;
  String? pinyin;
  String? shortPinyin;

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    // void addIfNonNull(String fieldName, dynamic value) {
    //   if (value != null) {
    //     map[fieldName] = value;
    //   }
    // }

//    addIfNonNull('tagIndex', tagIndex);
    return map;
  }

  @override
  String getSuspensionTag() {
    return tagIndex!;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
