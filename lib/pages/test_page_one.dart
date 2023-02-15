import 'package:flutter/material.dart';

class TestPageOne extends StatelessWidget {

  const TestPageOne({
  	Key? key,
  	this.title,
  }) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? "$this"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onDone,)
        ).toList(),
      ),
      body: Text(arguments.toString())
    );
  }

  onDone() {
    print("onDone");

    final nums = [1,3,5,6];
    final result = searchInsert(nums, 5);
    print("onDone $result");
    // print("onDone ${nums.reversed}");
    // for (int i = 0; i < nums.length; i++) {
    //   print("onDone ${i}_${nums[i]}");
    // }
    //
    // for(int i = nums.length - 1; i >= 0; i--) {
    //   print("onDone_ ${i}_${nums[i]}");
    // }
  }

  int searchInsert(List<int> nums, int target) {
    for(int i = nums.length - 1; i >= 0; i--) {
      int curr = nums[i];
      if(curr == target) {
        return i;
      } else if(curr < target ) {
        return i;
      }
    }
    return -1;
  }

  int ? searchInsertNew(List<int> nums, int target) {
    for(int i = 0; i<nums.length; i++) {
      if(nums[i] == target || nums[i] > target) {
        return i;
      }
    }
    return nums.length;
  }
}