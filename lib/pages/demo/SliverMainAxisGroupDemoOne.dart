//
//  SliverMainAxisGroupDemoOne.dart
//  flutter_templet_project
//
//  Created by shang on 2024/7/8 15:59.
//  Copyright © 2024/7/8 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_list_section.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

class SliverMainAxisGroupDemoOne extends StatefulWidget {
  const SliverMainAxisGroupDemoOne({
    super.key,
  });

  @override
  State<SliverMainAxisGroupDemoOne> createState() =>
      _SliverMainAxisGroupDemoOneState();
}

class _SliverMainAxisGroupDemoOneState
    extends State<SliverMainAxisGroupDemoOne> {
  final dataList = [
    NSliverSectionModel(name: '水果', items: [
      '苹果',
      '香蕉',
      '橙子',
      '葡萄',
      '芒果',
      '梨',
      '桃子',
      '草莓',
      '西瓜',
      '柠檬',
      '菠萝',
      '樱桃',
      '蓝莓',
      '猕猴桃',
      '李子',
      '柿子',
      '杏',
      '杨梅',
      '石榴',
      '木瓜'
    ]),
    NSliverSectionModel(name: '动物', items: [
      '狗',
      '猫',
      '狮子',
      '老虎',
      '大象',
      '熊',
      '鹿',
      '狼',
      '狐狸',
      '猴子',
      '企鹅',
      '熊猫',
      '袋鼠',
      '海豚',
      '鲨鱼',
      '斑马',
      '长颈鹿',
      '鳄鱼',
      '孔雀',
      '乌龟'
    ]),
    NSliverSectionModel(name: '职业', items: [
      '医生',
      '护士',
      '教师',
      '工程师',
      '程序员',
      '律师',
      '会计',
      '警察',
      '消防员',
      '厨师',
      '司机',
      '飞行员',
      '科学家',
      '记者',
      '设计师',
      '作家',
      '演员',
      '音乐家',
      '画家',
      '摄影师'
    ]),
    NSliverSectionModel(name: '菜谱', items: [
      '红烧肉',
      '糖醋排骨',
      '宫保鸡丁',
      '麻婆豆腐',
      '鱼香肉丝',
      '酸辣汤',
      '蒜蓉菠菜',
      '回锅肉',
      '水煮鱼',
      '烤鸭',
      '蛋炒饭',
      '蚝油生菜',
      '红烧茄子',
      '西红柿炒鸡蛋',
      '油焖大虾',
      '香菇鸡汤',
      '酸菜鱼',
      '麻辣香锅',
      '铁板牛肉',
      '干煸四季豆'
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('分组列表')),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            buildHeaderFooter().toSliverToBoxAdapter(),
            ...dataList.map(buildSection),
            buildHeaderFooter().toSliverToBoxAdapter(),
          ],
        ),
      ),
    );
  }

  /// 头尾
  Widget buildHeaderFooter() {
    return Container(
      height: 100,
      color: ColorExt.random,
    );
  }

  /// 分组
  Widget buildSection(NSliverSectionModel model) {
    return NSliverSection(
      model: model,
      itembuilder: (_, index) => buildItem(model.items[index]),
    );
  }

  /// 子项
  Widget buildItem(String item) {
    return InkWell(
      onTap: () {
        DLog.d("item: $item");
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            height: 50,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 10.0),
                  child: FlutterLogo(size: 30),
                ),
                Text(
                  item,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Divider(
            height: 0.5,
            color: Color(0xffe4e4e4),
            indent: 64,
          ),
        ],
      ),
    );
  }
}
