import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';
import 'package:tuple/tuple.dart';

class AutocompleteDemo extends StatefulWidget {

  final String? title;

  AutocompleteDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _AutocompleteDemoState createState() => _AutocompleteDemoState();
}

class _AutocompleteDemoState extends State<AutocompleteDemo> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Column(
          children: [
            Autocomplete(
              optionsBuilder: buildOptions,
              onSelected: onSelected,
            ),
          ],
        )
    );
  }

  Future<Iterable<String>> buildOptions( TextEditingValue textEditingValue ) async {
    if (textEditingValue.text == '') {
      return const Iterable<String>.empty();
    }
    return searchByArgs(textEditingValue.text);
  }

  Future<Iterable<String>> searchByArgs(String args) async{
    // 模拟网络请求
    await Future.delayed(const Duration(milliseconds: 200));
    List<String> data = getTitles(tuples: _tuples);
    return data.where((String name) => name.contains(args));
  }

  void onSelected(val) {
    print('val:$val');
  }
}

List<String> getTitles({required List<Tuple2<String, List<Tuple2<String, String>>>> tuples}) {
  // List<String> arr = [];
  // tuples.forEach((element) {
  //   final tmp = element.item2.map((e) => e.item1);
  //   arr.addAll(tmp);
  // });
  // print('runtimeType:${arr.runtimeType},${arr is List},${arr}');

  final titles = _tuples.flatMap((e) => e.item2.map((e) => e.item1).toList());
  final titlesNew = List<String>.from(titles);
  // print('titles runtimeType:${titles.runtimeType},${titles.every((element) => element is String)},');
  // print('titlesNew runtimeType:${titlesNew.runtimeType}');
  return titlesNew;
}

var _tuples = [
  Tuple2("特殊功能", _specials),
  Tuple2("动画相关", _animateds),
  Tuple2("系统组件demo", _list),
  Tuple2("自定义组件", _customs),
  Tuple2("第三方组件", _vendors),
  Tuple2("其它", _others)

];


var _list = [
  Tuple2(APPRouter.alertDialogDemo, "AlertDialog", ),
  Tuple2(APPRouter.alertSheetDemo, "AlertSheet", ),
  Tuple2(APPRouter.appWebViewDemo, "appWebViewDemo", ),

  Tuple2(APPRouter.backdropFilterDemo, "backdropFilterDemo", ),

  Tuple2(APPRouter.cupertinoTabScaffoldDemo, "CupertinoTabScaffoldDemo", ),
  Tuple2(APPRouter.cupertinoFormDemo, "cupertinoFormDemo", ),
  Tuple2(APPRouter.contextMenuActionDemo, "cupertinoFormDemo", ),

  Tuple2(APPRouter.dataTableDemo, "dateTableDemo", ),
  Tuple2(APPRouter.dataTableDemoNew, "dataTableDemoNew", ),
  Tuple2(APPRouter.draggableDemo, "draggableDemo", ),
  Tuple2(APPRouter.draggableScrollableSheetDemo, "draggableScrollableSheetDemo", ),

  Tuple2(APPRouter.expandIconDemo, "expandIconDemo", ),
  Tuple2(APPRouter.expandIconDemoNew, "ExpandIconDemoNew", ),

  Tuple2(APPRouter.gridViewDemo, "GridView", ),
  Tuple2(APPRouter.gridPaperDemo, "gridPaperDemo", ),

  Tuple2(APPRouter.menuDemo, "MenuDemo", ),

  Tuple2(APPRouter.pageViewDemo, "PageViewDemo", ),
  Tuple2(APPRouter.pageViewTabBarWidget, "PageViewTabBarWidget", ),

  Tuple2(APPRouter.pickerDemo, "pickerDemo", ),
  Tuple2(APPRouter.progressHudDemo, "ProgressHudDemo", ),
  Tuple2(APPRouter.progressHudDemoNew, "ProgressHudDemoNew", ),
  Tuple2(APPRouter.progressIndicatorDemo, "ProgressIndicatorDemo", ),

  Tuple2(APPRouter.reorderableListViewDemo, "reorderableListViewDemo", ),
  Tuple2(APPRouter.recordListDemo, "textFieldDemo", ),

  Tuple2(APPRouter.segmentControlDemo, "segmentControlDemo", ),
  Tuple2(APPRouter.snackBarDemo, "SnackBar", ),
  Tuple2(APPRouter.sliderDemo, "sliderDemo", ),
  Tuple2(APPRouter.stepperDemo, "stepperDemo", ),
  Tuple2(APPRouter.slidableDemo, "SlidableDemo", ),
  Tuple2(APPRouter.sliverAppBarDemo, "SliverAppBarDemo", ),
  Tuple2(APPRouter.sliverFamilyDemo, "SliverFamilyDemo", ),
  Tuple2(APPRouter.sliverFamilyPageViewDemo, "sliverFamilyPageViewDemo", ),
  Tuple2(APPRouter.sliverPersistentHeaderDemo, "sliverPersistentHeaderDemo", ),

  Tuple2(APPRouter.tabBarDemo, "tabBarDemo", ),
  Tuple2(APPRouter.textlessDemo, "textlessDemo", ),
  Tuple2(APPRouter.textFieldDemo, "textFieldDemo", ),
  Tuple2(APPRouter.textViewDemo, "textViewDemo", ),

  Tuple2(APPRouter.layoutBuilderDemo, "layoutBuilderDemo", ),
  Tuple2(APPRouter.tableDemo, "tableDemo", ),
  Tuple2(APPRouter.nestedScrollViewDemo, "nestedScrollViewDemo", ),

  Tuple2(APPRouter.popoverDemo, "popoverDemo", ),
  Tuple2(APPRouter.absorbPointerDemo, "absorbPointerDemo", ),
  Tuple2(APPRouter.willPopScopeDemo, "willPopScopeDemo", ),

  Tuple2(APPRouter.futureBuilderDemo, "futureBuilderDemo", ),
  Tuple2(APPRouter.streamBuilderDemo, "streamBuilderDemo", ),
  Tuple2(APPRouter.bannerDemo, "bannerDemo", ),

  Tuple2(APPRouter.indexedStackDemo, "indexedStackDemo", ),
  Tuple2(APPRouter.responsiveColumnDemo, "responsiveColumnDemo", ),
  Tuple2(APPRouter.offstageDemo, "offstageDemo", ),
  Tuple2(APPRouter.bottomAppBarDemo, "bottomAppBarDemo", ),
  Tuple2(APPRouter.calendarDatePickerDemo, "calendarDatePickerDemo", ),
  Tuple2(APPRouter.chipDemo, "chipDemo", ),
  Tuple2(APPRouter.chipFilterDemo, "chipFilterDemo", ),
  Tuple2(APPRouter.bottomSheetDemo, "bottomSheetDemo", ),
  Tuple2(APPRouter.timePickerDemo, "timePickerDemo", ),
  Tuple2(APPRouter.shaderMaskDemo, "ShaderMaskDemo", ),
  Tuple2(APPRouter.blurViewDemo, "blurViewDemo", ),
  Tuple2(APPRouter.boxDemo, "boxDemo", ),
  Tuple2(APPRouter.mouseRegionDemo, "mouseRegionDemo", ),
  Tuple2(APPRouter.navigationBarDemo, "navigationBarDemo", ),
  Tuple2(APPRouter.shortcutsDemo, "shortcutsDemo", ),
  Tuple2(APPRouter.shortcutsDemoOne, "shortcutsDemoOne", ),
  Tuple2(APPRouter.transformDemo, "动画", ),
  Tuple2(APPRouter.fittedBoxDemo, "fittedBox", ),
  Tuple2(APPRouter.coloredBoxDemo, "coloredBoxDemo", ),
  Tuple2(APPRouter.positionedDirectionalDemo, "positionedDirectionalDemo", ),
  Tuple2(APPRouter.statefulBuilderDemo, "statefulBuilderDemo", ),
  Tuple2(APPRouter.valueListenableBuilderDemo, "valueListenableBuilderDemo", ),
  Tuple2(APPRouter.overflowBarDemo, "水平溢出自动垂直排列", ),
  Tuple2(APPRouter.navigationToolbarDemo, "navigationToolbar", ),
  Tuple2(APPRouter.selectableTextDemo, "文字选择", ),
  Tuple2(APPRouter.materialBannerDemo, "一个 Banner", ),
  Tuple2(APPRouter.autocompleteDemo, "自动填写", ),
  Tuple2(APPRouter.flutterFFiTest, "ffi", ),


];

var _specials = [
  Tuple2(APPRouter.systemIconsPage, "flutter 系统 Icons", ),
  Tuple2(APPRouter.systemColorPage, "flutter 系统 颜色", ),
  Tuple2(APPRouter.localImagePage, "本地图片", ),
  Tuple2(APPRouter.providerRoute, "providerRoute", ),
  Tuple2(APPRouter.stateManagerDemo, "状态管理", ),

  Tuple2(APPRouter.tabBarPageViewDemo, "tabBarPageViewDemo", ),
  Tuple2(APPRouter.tabBarReusePageDemo, "tabBarReusePageDemo", ),

  Tuple2(APPRouter.githubRepoDemo, "githubRepoDemo", ),
  Tuple2(APPRouter.hitTest, "hitTest", ),
  Tuple2(APPRouter.textViewDemo, "textViewDemo", ),
  Tuple2(APPRouter.flutterFFiTest, "ffi", ),
  Tuple2(APPRouter.mergeImagesDemo, "图像合并", ),
  Tuple2(APPRouter.mergeNetworkImagesDemo, "网络图像合并", ),
  Tuple2(APPRouter.drawImageNineDemo, "图像拉伸", ),

];

var _animateds = [
  // Tuple2(APPRouter.animatedIconDemo, "AnimatedIconDemo", ),
  Tuple2(APPRouter.animatedDemo, "animatedDemo", ),

  Tuple2(APPRouter.animatedSwitcherDemo, "animatedSwitcherDemo", ),
  Tuple2(APPRouter.animatedWidgetDemo, "animatedWidgetDemo", ),
  Tuple2(APPRouter.animatedGroupDemo, "animatedGroupDemo", ),

];

var _customs = [
  Tuple2(APPRouter.datePickerPage, "DatePickerPage", ),
  Tuple2(APPRouter.dateTimeDemo, "dateTimeDemo", ),
  Tuple2(APPRouter.hudProgressDemo, "HudProgressDemo", ),
  Tuple2(APPRouter.localNotifationDemo, "localNotifationDemo", ),
  Tuple2(APPRouter.locationPopView, "locationPopView", ),
  Tuple2(APPRouter.numberStepperDemo, "NumberStepperDemo", ),
  Tuple2(APPRouter.numberFormatDemo, "numberFormatDemo", ),
  Tuple2(APPRouter.steperConnectorDemo, "steperConnectorDemo", ),

];

var _vendors = [
  Tuple2(APPRouter.carouselSliderDemo, "carouselSliderDemo", ),
  Tuple2(APPRouter.timelinesDemo, "timelinesDemo", ),
  Tuple2(APPRouter.timelineDemo, "timelineDemo", ),
  Tuple2(APPRouter.qrCodeScannerDemo, "扫描二维码", ),
  Tuple2(APPRouter.qrFlutterDemo, "生成二维码", ),
  Tuple2(APPRouter.scribbleDemo, "scribble 画板", ),
  Tuple2(APPRouter.aestheticDialogsDemo, "aestheticDialogs 对话框", ),
  Tuple2(APPRouter.customTimerDemo, "自定义计时器", ),
  Tuple2(APPRouter.skeletonDemo, "骨架屏", ),
  Tuple2(APPRouter.smartDialogPageDemo, "弹窗", ),
  Tuple2(APPRouter.ratingBarDemo, "星评", ),
  Tuple2(APPRouter.dragAndDropDemo, "文件拖拽", ),

];

var _others = [
  Tuple2(APPRouter.borderDemo, "buttonBorderDemo", ),
  Tuple2(APPRouter.clipDemo, "clipDemo", ),

  Tuple2(APPRouter.navgationBarDemo, "transparentNavgationBarDemo", ),
  Tuple2(APPRouter.richTextDemo, "richTextDemo", ),
  Tuple2(APPRouter.loginPage, "LoginPage", ),
  Tuple2(APPRouter.loginPage2, "LoginPage2", ),
  Tuple2(APPRouter.testPage, "testPage", ),

];
