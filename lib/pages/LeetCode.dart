

import 'package:flutter/material.dart';

class LeetCode extends StatefulWidget {

  const LeetCode({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _LeetCodeState createState() => _LeetCodeState();
}

class _LeetCodeState extends State<LeetCode> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () => print(e),
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: Text(arguments.toString())
    );
  }

  /// 寻找数组的中心索引
  int pivotIndex(List<int> nums) {
    final sum = nums.reduce((value, e) => value + e);

    var left = 0;
    for(var i = 0; i < nums.length; i++) {
      var value = nums[i];
      if (left * 2 + value == sum) {
        return i;
      } else {
        left += value;
      }
    }
    return -1;
  }

  /// 搜索插入位置
  /// 给定一个排序数组和一个目标值，在数组中找到目标值，并返回其索引。如果目标值不存在于数组中，返回它将会被按顺序插入的位置。
  int ? searchInsert(List<int> nums, int target) {
    for(var i = 0; i < nums.length; i++) {
      if(nums[i] == target) {
        return i;
      }
      if(nums[i] > target) {
        return i;
      }
    }
    return nums.length;
  }
}