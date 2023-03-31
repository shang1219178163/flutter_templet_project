import 'package:flutter/material.dart';


import 'package:flutter/material.dart';

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