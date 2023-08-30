import 'dart:convert';

import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/cache/CacheService.dart';

class TestPageOne extends StatefulWidget {

  const TestPageOne({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _TestPageOneState createState() => _TestPageOneState();
}

class _TestPageOneState extends State<TestPageOne> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;
    debugPrint("$this, build");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () => onDone(),
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: B(),
    );
  }

  @override
  void didUpdateWidget(TestPageOne oldWidget) {
    debugPrint("$this, didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  onDone() {
    debugPrint("$this, onDone");

    final nums = [1,3,5,6];
    final result = searchInsert(nums, 5);
    debugPrint("onDone $result");
    // print("onDone ${nums.reversed}");
    // for (int i = 0; i < nums.length; i++) {
    //   print("onDone ${i}_${nums[i]}");
    // }
    //
    // for(int i = nums.length - 1; i >= 0; i--) {
    //   print("onDone_ ${i}_${nums[i]}");
    // }


    // CacheService()["a"] = "aa";
    // final a = CacheService()["a"];
    // debugPrint("a $a");
    //
    // CacheService()["a1"] = {"aa" : "aaa"};
    // final a1 = CacheService()["a1"];
    // debugPrint("a1 $a1");
    //
    // CacheService()["a2"] = ["aa", "bb"];
    // final a2 = CacheService()["a2"];
    // debugPrint("a2 $a2");
    //
    //
    // CacheService()["a3"] = true;
    // final a3 = CacheService()["a3"];
    // debugPrint("a3 $a3");
    //
    // CacheService()["a4"] = 99;
    // final a4 = CacheService()["a4"];
    // debugPrint("a4 $a4");


    final a = jsonEncode(99);
    final a1 = jsonEncode("99");
    final a2 = jsonEncode(true);
    final a3 = jsonEncode([99]);
    final a4 = jsonEncode({"99": 99});
    debugPrint([a, a1, a2, a3, a4].join("\n"));

    final b = jsonEncode(a);
    final b1 = jsonEncode(a1);
    final b2 = jsonEncode(a2);
    final b3 = jsonEncode(a3);
    final b4 = jsonEncode(a4);
    debugPrint([b, b1, b2, b3, b4].join("\n"));


    setState(() {});
  }

  int searchInsert(List<int> nums, int target) {
    for(var i = nums.length - 1; i >= 0; i--) {
      var curr = nums[i];
      if(curr == target) {
        return i;
      } else if(curr < target ) {
        return i;
      }
    }
    return -1;
  }

  int ? searchInsertNew(List<int> nums, int target) {
    for(var i = 0; i<nums.length; i++) {
      if(nums[i] == target || nums[i] > target) {
        return i;
      }
    }
    return nums.length;
  }
}

class B extends StatefulWidget {
  const B({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BState();
}

class BState extends State {
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;
    debugPrint("$this, build");

    return Scaffold(
        appBar: AppBar(
          title: Text("$this"),
          actions: ['done',].map((e) => TextButton(
            onPressed: () => debugPrint("$e"),
            child: Text(e,
              style: TextStyle(color: Colors.white),
            ),)
          ).toList(),
        ),
        body: Text(arguments.toString())
    );
  }

  /// AState调用[AState.reload]后，[AState.didUpdateWidget]不会调用, [BState.didUpdateWidget]会调用
  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    debugPrint("$this, didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }
}