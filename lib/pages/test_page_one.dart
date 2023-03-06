import 'package:flutter/material.dart';


import 'package:flutter/material.dart';

class TestPageOne extends StatefulWidget {

  TestPageOne({
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
    print("$this, build");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => onDone(),)
        ).toList(),
      ),
      body: B(),
    );
  }

  @override
  void didUpdateWidget(TestPageOne oldWidget) {
    print("$this, didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  onDone() {
    print("$this, onDone");

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

    setState(() {});
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

class B extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BState();
}

class BState extends State {
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;
    print("$this, build");

    return Scaffold(
        appBar: AppBar(
          title: Text("$this"),
          actions: ['done',].map((e) => TextButton(
            child: Text(e,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => print(e),)
          ).toList(),
        ),
        body: Text(arguments.toString())
    );
  }

  /// AState调用[AState.reload]后，[AState.didUpdateWidget]不会调用, [BState.didUpdateWidget]会调用
  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    print("$this, didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }
}