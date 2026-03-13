import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:pinyin/pinyin.dart';
import 'package:provider/provider.dart';

class AreaCodePopup extends StatefulWidget {
  const AreaCodePopup({
    super.key,
    required this.areaList,
    required this.onChange,
  });

  final List<AreaCodeEntity> areaList;

  final ValueChanged<AreaCodeEntity> onChange;

  static List<AreaCodeEntity>? areaCodeList;

  static Future show(BuildContext context, {required ValueChanged<AreaCodeEntity> onChange}) async {
    //读取json
    const String jsonPath = 'assets/data/area_code.json';
    final content = await DefaultAssetBundle.of(context).loadString(jsonPath);
    areaCodeList ??= jsonDecode(content).map<AreaCodeEntity>((e) => AreaCodeEntity.fromJson(e)).toList();
    if (!context.mounted) {
      return;
    }
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      isScrollControlled: true,
      builder: (context) {
        return AreaCodePopup(
          areaList: areaCodeList!,
          onChange: onChange,
        );
      },
      context: context,
    );
  }

  @override
  State<AreaCodePopup> createState() => _AreaCodePopupState();
}

class _AreaCodePopupState extends State<AreaCodePopup> {
  late List<AreaInfo> models;

  @override
  void initState() {
    super.initState();

    //排列添加models
    models = List.generate(widget.areaList.length, (index) {
      //获取索引表
      AreaCodeEntity areaCode = widget.areaList[index];
      ////获取中文首个字的拼音的第一个字母
      String chineseName = areaCode.chineseName!;
      String pinyin = PinyinHelper.getShortPinyin(chineseName);
      String name = pinyin.isEmpty ? '#' : pinyin.substring(0, 1).toUpperCase();

      return AreaInfo(
        area: widget.areaList[index],
        tagIndex: name,
      );
    });

    SuspensionUtil.sortListBySuspensionTag(models);
  }

  @override
  Widget build(BuildContext context) {
    late final themeProvider = context.read<ThemeProvider>();

    return Scaffold(
      // backgroundColor: themeProvider.color242434OrWhite,
      body: Column(
        children: [
          // const SizedBox(height: 36),
          Theme(
            data: Theme.of(context).copyWith(
              appBarTheme: AppBarTheme(
                color: Colors.white,
                titleTextStyle: TextStyle(color: Colors.black),
                iconTheme: IconThemeData(color: Colors.black),
                elevation: 0,
                scrolledUnderElevation: 0,
              ),
            ),
            child: AppBar(
              // backgroundColor: Colors.transparent,
              title: Text('选择国家或地区'),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: AzListView(
              itemCount: models.length,
              physics: const BouncingScrollPhysics(),
              susPosition: const Offset(0, 40),
              indexBarData: SuspensionUtil.getTagIndexList(models),
              indexBarOptions: IndexBarOptions(
                textStyle: TextStyle(color: AppColor.cancelColor, fontSize: 10),
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    widget.onChange(models[index].area);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 16, right: 28),
                    padding: const EdgeInsets.only(top: 18, bottom: 18),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: themeProvider.lineColor,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${models[index].area.chineseName}',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14, color: themeProvider.titleColor).copyWith(height: 1),
                        ),
                        Text(
                          '+${models[index].area.phoneCode}',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14, color: themeProvider.titleColor).copyWith(height: 1),
                        ),
                      ],
                    ),
                  ),
                );
              },
              data: models,
            ),
          ),
        ],
      ),
    );
  }
}

class AreaInfo extends ISuspensionBean {
  AreaInfo({
    required this.area,
    required this.tagIndex,
  });

  final AreaCodeEntity area;

  final String tagIndex;

  @override
  String getSuspensionTag() {
    return tagIndex;
  }
}

class AreaCodeEntity {
  AreaCodeEntity({
    this.englishName,
    this.chineseName,
    this.countryCode,
    this.phoneCode,
  });

  String? englishName;

  String? chineseName;

  String? countryCode;

  String? phoneCode;

  AreaCodeEntity.fromJson(Map<String, dynamic> json) {
    englishName = json['english_name'];
    chineseName = json['chinese_name'];
    countryCode = json['country_code'];
    phoneCode = json['phone_code'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['english_name'] = englishName;
    map['chinese_name'] = chineseName;
    map['country_code'] = countryCode;
    map['phone_code'] = phoneCode;
    return map;
  }
}
