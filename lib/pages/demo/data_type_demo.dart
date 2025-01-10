//
//  TestDataTyeDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/5/1 07:45.
//  Copyright © 2024/5/1 shang. All rights reserved.
//

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_type_writer_text.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/generic_comparable_ext.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/service_protocol_info_ext.dart';
import 'package:flutter_templet_project/extension/type_util.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/map_ext.dart';
import 'package:flutter_templet_project/extension/object_ext.dart';
import 'package:flutter_templet_project/extension/snack_bar_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/mixin/app_lifecycle_state_mixin.dart';
import 'package:flutter_templet_project/model/NPerson.dart';
import 'package:flutter_templet_project/util/Codable.dart';
import 'package:flutter_templet_project/util/Singleton.dart';
import 'package:flutter_templet_project/vendor/amap_location/location_detail_model.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quiver/collection.dart';

/// 基础类型数据测试
class DataTypeDemo extends StatefulWidget {
  const DataTypeDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<DataTypeDemo> createState() => _DataTypeDemoState();
}

class _DataTypeDemoState extends State<DataTypeDemo> with WidgetsBindingObserver, AppLifecycleStateOriginMixin {
  bool get hideApp => Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

  late final specialItems = <ActionRecord>[
    (e: "Singleton", action: onSingleton),
    (e: "Equals", action: onEquals),
    (e: "Comparable", action: onComparable),
  ];

  late final items = <ActionRecord>[
    (e: "String", action: onString),
    (e: "Date", action: onDate),
    (e: "List", action: onList),
    (e: "Map", action: onMap),
    (e: "LruMap", action: onLruMap),
    (e: "Set", action: onSet),
    (e: "bool", action: onBool),
    (e: "Record", action: onRecord),
    (e: "Object", action: onObject),
  ];

  @override
  void initState() {
    super.initState();

    appLifecycleStateChanged = (state) {
      switch (state) {
        case AppLifecycleState.resumed:
          {
            ToastUtil.show("resumed");
          }
          break;
        case AppLifecycleState.paused:
          {
            ToastUtil.show("resumed");
          }
          break;
        default:
          break;
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
              actions: [
                'done',
              ]
                  .map((e) => TextButton(
                        child: Text(
                          e,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => debugPrint(e),
                      ))
                  .toList(),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionBox(items: specialItems),
            buildSectionBox(items: items),
            // NTypeWriterText(
            //   text: 60.generateChars(),
            // ),
          ]
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      e,
                      // Divider(height: 16,),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget buildSectionBox({
    required List<ActionRecord> items,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((e) {
        return InkWell(
          onTap: e.action,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: NText(
              e.e,
              color: context.primaryColor,
            ),
          ),
        );
      }).toList(),
    );
  }

  void onSingleton() {
    final shard = Singleton();
    final shard1 = Singleton.instance;
    final shard2 = Singleton.getInstance();
    debugPrint("Singleton: ${shard == shard1 && shard1 == shard2}");
  }

  void onEquals() {
    var map = <(int, int), String>{};
    map[(1, 2)] = "1,2";
    map[(3, 4)] = "3,4";
    debugPrint("map: ${map}");

    final list1 = ["aaa"];
    final list2 = ["aaa"];
    debugPrint("${DateTime.now()} list ==: ${list1 == list2}");
    debugPrint("${DateTime.now()} list listEquals: ${listEquals(list1, list2)}");

    final map1 = {"a": "aa"};
    final map2 = {"a": "aa"};
    debugPrint("${DateTime.now()} map ==: ${map1 == map2}");
    debugPrint("${DateTime.now()} map mapEquals: ${mapEquals(map1, map2)}");

    final set1 = {'a'};
    final set2 = {'a'};
    debugPrint("${DateTime.now()} set ==: ${set1 == set2}");
    debugPrint("${DateTime.now()} set setEquals: ${setEquals(set1, set2)}");

    final user = LocationDetailModel(description: "aaa");
    final user1 = LocationDetailModel(description: "aaa");
    debugPrint("user: ${user.toJson() == user1.toJson()}");

    final sameUser = user == user1;
    debugPrint("sameUser: ${sameUser}");

    final result = identical(user, user1); //检查两个对象引用是否指向同一对象。
    debugPrint("result: ${result}");

    final bob = NPerson(name: "Bob", age: 40);
    final bob1 = NPerson(name: "Bob", age: 40);
    debugPrint("NPerson:${bob == bob1}"); // false
    debugPrint("NPerson bob: ${bob.hashCode}"); // false
    debugPrint("NPerson bob1: ${bob.hashCode1}"); // false
  }

  void onComparable() {
    final now = DateTime.now();
    final before = now.subtract(Duration(hours: 1));
    final after = now.add(Duration(hours: 1));

    final d1 = Duration(hours: 1);
    final d2 = Duration(hours: 2);
    DLog.d("now: $now");
    DLog.d("before: $before");
    DLog.d("after: $after");
    DLog.d("now.inRange(before, after): ${now.inRange(before, after)}");
    DLog.d("before.clamp(now, after): ${before.clamp(now, after)}");
    DLog.d("now > before: ${now > before}");
    DLog.d("now > after: ${now > after}");
    DLog.d("d1 > d2: ${d1 > d2}");
    DLog.d("d1 < d2: ${d1 < d2}");

    // [log] DLog 2024-11-09 09:47:02.634885 now: 2024-11-09 09:47:02.634465
    // [log] DLog 2024-11-09 09:47:02.635243 before: 2024-11-09 08:47:02.634465
    // [log] DLog 2024-11-09 09:47:02.635631 after: 2024-11-09 10:47:02.634465
    // [log] DLog 2024-11-09 09:47:02.635907 now.inRange(before, after): true
    // [log] DLog 2024-11-09 09:47:02.636189 before.clamp(now, after): 2024-11-09 09:47:02.634465
    // [log] DLog 2024-11-09 09:47:02.636434 now > before: true
    // [log] DLog 2024-11-09 09:47:02.636705 now > after: false
    // [log] DLog 2024-11-09 09:47:02.636899 d1 > d2: false
    // [log] DLog 2024-11-09 09:47:02.637086 d1 < d2: true
  }

  Future<void> onString() async {
    final a = 'Eats shoots leaves'.splitMapJoin((RegExp(r'shoots')),
        onMatch: (m) => m[0] ?? "", // (or no onMatch at all)
        onNonMatch: (n) => '*'); // Result: "*shoots*"
    ddlog(a);

    final b = 'Eats shoots leaves'.splitMapJoin(
      (RegExp(r's|o')),
      onMatch: (m) => "_",
    );
    ddlog(b);

    final c = 'Eats shoots leaves'.split(RegExp(r's|o'));
    ddlog(c);

    final d = "easy_refresh_plugin".toCamlCase("_");
    ddlog(d);

    final d1 = "easyRefreshPlugin".toUncamlCase("_");
    ddlog(d1);

    final d2 = "easyRefreshPlugin".toCapitalize();
    ddlog(d2);

    var aa = 85.99999;
    var bb = 488.236;
    var cc = 488.3;

    ddlog(aa.toStringAsExponential(2));
    ddlog(aa.toStringAsFixed(2));
    ddlog(aa.toStringAsPrecision(2));

    showSnackBar(SnackBar(content: Text(d2)));

    int j = 0; //第n次匹配
    String pigLatin(String words) => words.replaceAllMapped(RegExp(r'([a|e])', caseSensitive: false), (Match m) {
          for (var i = 0; i < m.groupCount; i++) {
            ddlog("${j}_m[${i}]/${m.groupCount - 1}: ${m[i]}");
            j++;
          }

          final result = "${m[1]}*";
          return result;
        });
    final result = pigLatin('I have a secret now!');
    ddlog(result); // 'Iway avehay away ecretsay ownay!'

    String? a1;
    String? a2 = "a2";
    String? a3;
    String? a4 = "a4";
    final resultA = a1.or("") + a2.or("") + a3.or("") + a4.or("");
    final resultB = [a1, a2, a3, a4].map((e) => e ?? "").toList();
    final resultC = [a1, a2, a3, a4].removeNull();

    a1.isNotEmpty;

    ddlog("a1.isNotEmptyNew: ${a1.isNotEmpty}");
    return;

    // String a5 = a4.or(Text(e));
    // final a13 = a3.map((e) => Text(e));
    // final a14 = a4.map((e) => Text(e));
    // ddlog("result13: ${[a13, a14]}");
    // return;

    ddlog("resultA: $resultA");
    ddlog("resultB: $resultB");
    ddlog("resultC: $resultC");

    final listA = [
      a1.convert((v) => Text("A1")),
      a2.convert((v) => Text("A2")),
      a3.convert((v) => Text("A3")),
      a4.convert((v) => Text("A4")),
    ];
    ddlog(listA);

    // 使用正则表达式删除左边的所有0
    String strZero = "000123450";
    String resultZero = strZero.replaceFirst(RegExp(r'^0+'), '');
    debugPrint('resultZero: $resultZero');

    final serviceInfo = await Service.getInfo();
    serviceInfo.printIsarLink();
  }

  void onDate() {
    final now = DateTime.now();
    final dateStr = "$now".substring(0, 10);
    debugPrint("dateStr: ${dateStr}");
  }

  void onList() {
    final array1 = [
      1,
      [
        2,
        3,
      ],
      [
        4,
        [
          5,
          6,
          [7, 8]
        ]
      ]
    ];
    final array1New = array1.flatMap();
    debugPrint('array1New:$array1New');

    return;
    double? z;
    double? z1;
    final list = [z, z1];
    debugPrint('z1:$list');

    List<String>? items;
    final zz = items?[0];
    debugPrint('zz:$zz');

    try {
      List<String>? listNew = [];
      // debugPrint('first: ${listNew.first}');

      listNew = ["a", "b", "c"];
      for (var i = 0; i < listNew.length; i++) {
        final e = listNew[i];
        debugPrint('e: $e');
      }
      for (var i = listNew.length - 1; i >= 0; i--) {
        final e = listNew[i];
        debugPrint('倒叙e: $e');
      }
    } catch (exception) {
      debugPrint(exception.toString());
    }

    final arr = [];
    final arrNew = arr.take(1);
    debugPrint('arrNew: ${arrNew.isEmpty}');

    String? maxline;
    // maxline = map["aa'a'a"];
    final flag = (maxline?.isNotEmpty == true);
    debugPrint('flag: $flag');
    maxline = "1";
    final flag1 = (maxline?.isNotEmpty == true);
    debugPrint('flag1: $flag1');

    final randomItems = List.generate(9, (index) {
      final sufix = 3.generateChars(
        chars: "0123456789",
      );
      return "选项$sufix";
    });
    ddlog("randomItems.sorted(): ${randomItems.sorted()}");

    final strides = List.generate(20, (index) => "选项$index").splitStride(
      by: 4,
      onItem: (start, end, items) {
        debugPrint("splitStride onItem $start $end: ${items[start]}, ${items[end]}");
        return items.getRange(start, end);
      },
    );
    ddlog("strides: ${strides}");
  }

  void onSet() {}

  Future<void> onMap() async {
    var map = <String, dynamic>{
      'msgType': '5',
      'msgTag': '官方号',
      'msgUnreadNum': 3,
    };

    ddlog('map.toQueryString():${map.toQueryString()}');

    final _memoryMap = <String, dynamic>{};
    _memoryMap['msgTag'] = null;
    _memoryMap["sss"] = "ssss";

    final info = await PackageInfo.fromPlatform();

    await CacheService().set("info", info.data);
    final result = CacheService().get("info");
    ddlog("info:${result}");

    Map? a1;
    ddlog("a1.isNotEmptyNew: ${a1.isNotEmptyNew}");

    // 示例动态 Map
    Map<String, dynamic> params = {
      'name': 'John Doe',
      'age': 25,
      'isStudent': true,
      'courses': ['Math', 'Science'], // 复杂值需要处理
    };

    // 转换为查询字符串
    String queryString = params.toQueryString();
    ddlog('Query String: $queryString');
    return;

    mapSorted();
  }

  void mapSorted() {
    Map<String, int> unsortedMap = {
      'pinch': 3,
      'banana': 5,
      'apple': 3,
      'cherry': 2,
    };

    // 根据 Value 和 Key 进行排序
    sortValueAndKey<K extends Comparable, V extends Comparable>(
      MapEntry<K, V> a,
      MapEntry<K, V> b, {
      bool isAsc = true,
    }) {
      int result = isAsc ? a.value.compareTo(b.value) : b.value.compareTo(a.value);
      if (result != 0) {
        return result;
      }
      return isAsc ? a.key.compareTo(b.key) : b.key.compareTo(a.key); // 如果值相同，按键排序
    }

    // // 自定义排序（首先按值排序，如果值相同按键排序）
    // var sortedMap = Map.fromEntries(
    //   unsortedMap.entries.toList()..sort(sortValueAndKey),
    // );
    //
    // final sortedMapNew = unsortedMap.sortedBy(
    //   (k) => k.value,
    //   compare: sortValueAndKey,
    // );
    // final sortedMapNew1 = unsortedMap.sortedBy(
    //   (k) => k.value,
    //   isAsc: false,
    //   compare: sortValueAndKey,
    // );
    // ddlog('sortedMap: $sortedMap');
    // ddlog('sortedMapNew: $sortedMapNew');
    // ddlog('sortedMapNew1: $sortedMapNew1');
    // return;

    // 模型属性排序
    Map<String, MapItem> data2 = {
      "2022-11-01": MapItem(count: 12, name: "book"),
      "2022-11-12": MapItem(count: 2, name: "pencil"),
      "2022-11-05": MapItem(count: 18, name: "keyboard"),
      "2022-11-24": MapItem(count: 8, name: "scissors"),
    };

    final sortByCount = data2.sortedBy((k) => k.value.count).toString();
    final sortByName = data2.sortedBy((k) => k.value.name).toString();
    ddlog('Sort by Count: > $sortByCount');
    ddlog('Sort by Name : > $sortByName');
    return;
  }

  void onLruMap() {
    final map = {'a': 1, 'b': 11, 'c': 111};

    final lruMap = LruMap(maximumSize: 10);
    final list = List.generate(20, (i) => i).toList();
    for (var i = 0; i < list.length; i++) {
      final key = "key$i";
      lruMap.addAll({key: map});
      if (i > 9) {
        ddlog("lruMap[key3]: ${lruMap["key3"]}");
      }
      ddlog("lruMap: $i, ${lruMap.length}, ${lruMap.keys.map((e) => e)}");
    }
  }

  void onBool() {}

  Future<void> onRecord() async {
    (List<String> a, Map<String, dynamic> b) re = ([], {});
    debugPrint("re:${re}");

    re.$1.add("a");
    re.$2["a"] = "aa";
    debugPrint("re1:${re}");

    ({int a, int b}) recordAB = (a: 1, b: 2);

    (double lat, double lon) geoLocation(String name) => (231.23, 36.8219);

    var record1 = ('first', 2, true, 'last');
    debugPrint("record1.1:${record1.$1}");
    debugPrint("record1.2:${record1.$2}");
    debugPrint("record1.3:${record1.$3}");
    debugPrint("record1.4:${record1.$4}");
  }

  void onObject() {
    testData();
    // onVersion();
  }

  removeSame() {
    List list = [
      {'id': 1, 'name': '小明'},
      {'id': 1, 'name': '小红'},
      {'id': 2, 'name': '小明'}
    ];

    final ids = list.map((e) => e['id']).toSet();
    debugPrint('ids: ${ids}');

    list.retainWhere((e) => ids.remove(e['id']));
    debugPrint('list: ${list}');
  }

  void printFormat() {
    final list = [
      '***************************************************',
      '',
      'ISAR CONNECT STARTED',
      '',
      'Open the link to connect to the Isar',
      'Inspector while this build is running.',
      '',
      '***************************************************',
    ];
    DLog.center(list);
  }

  testData() {
    const String? a = null;
    const String? a1 = "a1";
    const List<String>? array = null;
    ddlog([a.runtimeType, a1.runtimeType, array.runtimeType].asMap());

    const String? b = null;
    ddlog([a.orElse(() => "456"), b.or("333"), a.convert((v) => Text("$a")), b.convert((v) => Text("$b"))].asMap());

    final Text? z = a.convert((v) => Text("$a"));

    final nums = List<int>.generate(10, (i) => i);
    final val = nums.reduce((v, e) => v + e);
    ddlog("reduce int: $val");

    // for (var i = 0; i < nums.length; i++) {
    //   ddlog("i: ${nums[i]}");
    //   if (i >= 3) {
    //     return;
    //   }
    // }

    return;

    final array1 = nums.map((e) => "$e").toList();
    final result = array1.reduce((v, e) => v + e);
    ddlog("reduce String: $result");

    ddlog(array.orElse(() => array1));

    // 定义一个数组
    List<int> numbers = [3, 7, 2, 9, 5, 1];
    // 找到数组的最大值
    int maxValue = numbers.reduce((a, b) => a > b ? a : b);
    int maxValue1 = numbers.reduce((a, b) {
      final result = a > b ? a : b;
      DLog.d("result: $a, $b, $result");
      return result;
    });

    ddlog("maxValue: $maxValue");
  }

  void onVersion() {
    ddlog(compareVersion("1.0.33", "1.0.27")); // 输出 1
    ddlog(compareVersion("1.0.0", "1.0.0")); // 输出 0
    ddlog(compareVersion("1.0.1", "1.0.2")); // 输出 -1
    ddlog(compareVersion("2.1", "2.1.0")); // 输出 0
    ddlog(compareVersion("3.2.1", "3.2.0")); // 输出 1
    ddlog(compareVersion("3.2.0", "3.2")); // 输出 0
  }

  int compareVersion(String version1, String version2) {
    ddlog("__${version1.compareVersion(version2)}"); // 输出 -1

    // 将版本号字符串分割成整数列表
    List<int> v1 = version1.split('.').map(int.parse).toList();
    List<int> v2 = version2.split('.').map(int.parse).toList();

    // 获取最大长度
    int maxLength = v1.length > v2.length ? v1.length : v2.length;

    // 补全较短的版本号列表
    for (var i = v1.length; i < maxLength; i++) {
      v1.add(0);
    }
    for (var i = v2.length; i < maxLength; i++) {
      v2.add(0);
    }

    // 比较每个部分的值
    for (var i = 0; i < maxLength; i++) {
      final result = v1[i].compareTo(v2[i]);
      if (result != 0) {
        return result;
      }
    }

    // 如果所有部分都相等，则返回 0
    return 0;
  }
}

/// 测试类
class MapItem implements Codable {
  MapItem({
    required this.name,
    required this.count,
  });
  final String name;
  final int count;

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "count": count,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
