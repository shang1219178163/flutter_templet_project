import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/model/category_item.dart';
import 'package:flutter_templet_project/util/dlog.dart';

class IsolateSimpleWidget extends StatefulWidget {
  const IsolateSimpleWidget({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<IsolateSimpleWidget> createState() => IsolateSimpleWidgetState();
}

class IsolateSimpleWidgetState extends State<IsolateSimpleWidget> {
  var content = "点击计算按钮,开始计算";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Text(content),
          ),
          Container(
            height: 500,
            width: double.infinity,
            padding: EdgeInsets.all(8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                TextButton(
                  onPressed: () async {
                    //flutter中创建isolate---compute()方法, 函数只能是顶级函数
                    var result = await compute(sum, 1000000);
                    final num = int.parse('$result');
                    final numFmt = NumberFormat('0,000.00');
                    final fmtValue = numFmt.format(num);
                    content = "计算结果$fmtValue";
                    setState(() {});
                  },
                  child: Text('计算'),
                ),
                TextButton(
                  onPressed: () async {
                    final list = await fetchData();
                    DLog.d(list.map((e) => [e.name, e.children?.map((e) => e.name).join("_")].join("\n")));
                  },
                  child: Text('fetchData'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<CategoryItem>> fetchData() async {
    final res = await rootBundle.loadString('assets/data/football.json');
//     final Map<String, dynamic> map = jsonDecode(res);
    final map = await compute(jsonDecode, res);
    final data = map["data"];
    final code = map["code"];
    if (code != 0) {
      return Future.value([]);
    }

    final List<dynamic> categorys = data['categorys'];
    final result = categorys.map((json) => CategoryItem.fromJson(json)).toList();
    return Future.value(result);
  }
}

//计算0到 num 数值的总和
int sum(int num) {
  var count = 0;
  while (num > 0) {
    count = count + num;
    num--;
  }
  return count;
}
