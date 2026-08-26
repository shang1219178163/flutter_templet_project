import 'package:flutter/material.dart';
// import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_templet_project/Model/app_update_model.dart';
import 'package:flutter_templet_project/util/dlog.dart';

class AppUpdateCard extends StatefulWidget {
  const AppUpdateCard({
    super.key,
    required this.data,
    this.isExpand = false,
    this.showExpand = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
  });

  final AppUpdateItemModel data;

  final bool isExpand;

  final bool showExpand;

  final EdgeInsets padding;

  @override
  _AppUpdateCardState createState() => _AppUpdateCardState();
}

class _AppUpdateCardState extends State<AppUpdateCard> {
  late bool _isExpand = widget.isExpand;

  @override
  void didUpdateWidget(covariant AppUpdateCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isExpand != widget.isExpand) {
      _isExpand = widget.isExpand;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildTopSection(),
          buildBottomSection(),
        ],
      ),
    );
  }

  void onChanged() {
    setState(() {
      _isExpand = !_isExpand;
    });
  }

  Widget buildTopSection() {
    return Row(
      //Row控件，用来水平摆放子Widget
      children: <Widget>[
        ClipRRect(
          //圆⻆矩形裁剪控件
          borderRadius: BorderRadius.circular(8.0), //圆⻆半径为8
          // child: Image.asset(data.appIcon, width: 60, height: 60),
          child: FlutterLogo(
            size: 60,
          ),
        ),
        Expanded(
          //Expanded控件，用来拉伸中间区域
          child: Column(
            //Column控件，用来垂直摆放子Widget
            mainAxisAlignment: MainAxisAlignment.center, //垂直方向居中对⻬
            crossAxisAlignment: CrossAxisAlignment.start, //水平方向居左对⻬
            children: <Widget>[
              Text(widget.data.appName, maxLines: 1, overflow: TextOverflow.ellipsis), //App名字
              Text(widget.data.appDate, maxLines: 1), //App更新日期
            ],
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () => DLog.d('Make a Note'),
          child: Text("更新"),
        ),
      ],
    );
  }

  Widget buildBottomSection() {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        //Column控件用来垂直摆放子Widget
        crossAxisAlignment: CrossAxisAlignment.start, //水平方向距左对⻬
        children: <Widget>[
          Stack(
            // alignment: Alignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    // color: Colors.greenAccent,
                    // border: Border.all(color: Colors.red, width: 1),
                    ),
                child: Text(
                  widget.data.appDescription,
                  maxLines: _isExpand ? null : 2,
                ),
              ),
              if (widget.showExpand)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    alignment: Alignment.bottomRight,
                    decoration: BoxDecoration(
                        // color: Colors.green,
                        // border: Border.all(color: Colors.blue, width: 2),
                        ),
                    child: TextButton(
                      onPressed: onChanged,
                      child: Text(
                        _isExpand ? '收起' : "展开",
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Text("${widget.data.appVersion} • ${widget.data.appSize} MB"),
        ],
      ),
    );
  }
}

class NNListUpdateAppWidget extends StatelessWidget {
  final List<AppUpdateItemModel> list;

  const NNListUpdateAppWidget({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      cacheExtent: 180,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final data = list[index];
        return AppUpdateCard(data: data);
      },
      separatorBuilder: (context, index) {
        return Divider(indent: 16, endIndent: 16);
      },
    );
  }
}
