//
//  TestDataTyeDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/5/1 07:45.
//  Copyright © 2024/5/1 shang. All rights reserved.
//

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/map_ext.dart';
import 'package:flutter_templet_project/extension/snack_bar_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/model/NPerson.dart';
import 'package:flutter_templet_project/util/Singleton.dart';
import 'package:flutter_templet_project/vendor/amap_location/location_detail_model.dart';
import 'package:get/get.dart';
import 'package:quiver/collection.dart';

typedef ButtonRecord = ({String name, VoidCallback action});

/// 基础类型数据测试
class TestDataTyeDemo extends StatefulWidget {
  const TestDataTyeDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<TestDataTyeDemo> createState() => _TestDataTyeDemoState();
}

class _TestDataTyeDemoState extends State<TestDataTyeDemo> {
  bool get hideApp =>
      Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

  late final specialItems = <ButtonRecord>[
    (name: "Singleton", action: onSingleton),
    (name: "Equals", action: onEquals),
  ];

  late final items = <ButtonRecord>[
    (name: "String", action: onString),
    (name: "List", action: onList),
    (name: "Map", action: onMap),
    (name: "LruMap", action: onLruMap),
    (name: "Set", action: onSet),
    (name: "bool", action: onBool),
    (name: "Record", action: onRecord),
  ];

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
          ]
              .map(
                (e) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
    required List<ButtonRecord> items,
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
              e.name,
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
    debugPrint(
        "${DateTime.now()} list listEquals: ${listEquals(list1, list2)}");

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

  void onString() {
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

    showSnackBar(SnackBar(content: Text(d2)));
  }

  void onList() {
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
  }

  void onSet() {}

  void onMap() {
    var map = <String, dynamic>{
      'msgType': '5',
      'msgTag': '官方号',
      'msgUnreadNum': 3,
    };

    ddlog('getUrlParams():${getUrlParams(map: map)}');
    ddlog('map.join():${map.join()}');

    final _memoryMap = <String, dynamic>{};

    _memoryMap['msgTag'] = null;
    ddlog('_memoryMap:${_memoryMap}');
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

  void onRecord() {
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

  getUrlParams({Map<String, dynamic> map = const {}}) {
    if (map.keys.isEmpty) {
      return '';
    }
    var paramStr = '';
    map.forEach((key, value) {
      paramStr += '$key=$value&';
    });
    var result = paramStr.substring(0, paramStr.length - 1);
    return result;
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
    DLog.format(list);
  }
}
