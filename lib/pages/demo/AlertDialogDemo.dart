import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';

import 'package:flutter_templet_project/basicWidget/chioce_list.dart';
import 'package:flutter_templet_project/basicWidget/chioce_wrap.dart';
import 'package:flutter_templet_project/basicWidget/n_cancel_and_confirm_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_user_privacy.dart';
import 'package:flutter_templet_project/basicWidget/n_webview_page.dart';
import 'package:flutter_templet_project/basicWidget/n_popup_route.dart';
import 'package:flutter_templet_project/basicWidget/n_alert_dialog.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/snack_bar_ext.dart';

import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/rich_text_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/extension/dialog_ext.dart';
import 'package:flutter_templet_project/mixin/dialog_mixin.dart';

import 'package:popover/popover.dart';

import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter_templet_project/pages/demo/AlertSheetDemo.dart';

class AlertDialogDemo extends StatefulWidget {
  const AlertDialogDemo({Key? key}) : super(key: key);

  @override
  _AlertDialogDemoState createState() => _AlertDialogDemoState();
}

class _AlertDialogDemoState extends State<AlertDialogDemo>
    with SingleTickerProviderStateMixin, DialogMixin {
  var itemSize = Size(70, 70);

  var titles = [
    "iOS风格",
    "安卓风格",
    "进度条",
    "进度环",
    "流水布局",
    "单选列表",
    "多选列表",
    "单选菜单",
    "多选菜单",
    "性别选择",
    "自定义",
    "aboutDialog",
    "Popover",
    "NNPopupRoute",
    "NNPopupRoute Alert",
    "NNPopupRoute 自定义",
    "NNPopupRoute 顶部消息",
    "隐私协议",
    "Dialog",
    "DialogMixin - presentDialog",
    "DialogMixin - presentDialogAlert",
    "DialogMixin - presentCupertinoAlert",
  ];

  final title = "新版本 v${2.1}";
  final message = """
1、支持立体声蓝牙耳机，同时改善配对性能;
2、提供屏幕虚拟键盘;
3、更简洁更流畅，使用起来更快;
4、修复一些软件在使用时自动退出bug;
5、新增加了分类查看功能;
""";

  final title1 = "曼德拉《漫漫人生路》";
  final message1 = """
如果发出声音是危险的，那就保持沉默;
如果自觉无力发光，那就别去照亮别人。
但是——不要习惯了黑暗就为黑暗辩护;
不要为自己的苟且而得意洋洋;
不要嘲讽那些比自己更勇敢、更有热量的人们。
我们可以卑微如尘土，不可扭曲如蛆虫。
——曼德拉《漫漫人生路》""";

  Object? sex = 1;

  List<Alignment> alignments = [
    Alignment.topLeft,
    Alignment.topCenter,
    Alignment.topRight,
    Alignment.centerLeft,
    Alignment.center,
    Alignment.centerRight,
    Alignment.bottomLeft,
    Alignment.bottomCenter,
    Alignment.bottomRight,
  ];


  Map<String, Widget> map = {
    'topCenter': Text("topCenter"),
    'Center': Text("Center"),
    'bottomCenter': Text("bottomCenter"),
  };

  Map<String, Alignment> alignmentMap = {
    'topCenter': Alignment.topCenter,
    'Center': Alignment.center,
    'bottomCenter': Alignment.bottomCenter,
  };

  var alignment = Alignment.center;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
        actions: [
          TextButton(
            onPressed: () {
              APPThemeService().changeTheme();
            },
            child: Icon(Icons.extension,
              color: Colors.white,
            )
          )
        ],
        bottom: _buildAppbarBottom(),
      ),
      body: buildBody(),
    );
  }

  _buildAppbarBottom() {
    return PreferredSize(
      preferredSize: Size.fromHeight(45),
      child: Container(
        // color: Colors.red,
        height: 45,
        width: double.infinity,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            var e = alignments[index];
            var name = e.toString().split('.')[1];

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              // color: index %2 == 0 ? Colors.yellow : Colors.green,
              // child: Center(child: Text(name)),
              child: TextButton(
                onPressed: () {
                  alignment = e;
                  showSnackBar(SnackBar(content: Text(name)),);
                  debugPrint("alignment:$alignment ${alignment.x} ${alignment.y}");
                },
                child: Text(name, style: TextStyle(color: Colors.white),)
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(height: 8);
          },
          itemCount: alignments.length,
        ),
      ),
    );
    //
    // return PreferredSize(
    //   preferredSize: Size.fromHeight(45),
    //   child: CupertinoSegmentedControl(
    //     unselectedColor: Colors.blue,
    //     selectedColor: Colors.white,
    //     borderColor: Colors.transparent,
    //     pressedColor: Colors.green,
    //     onValueChanged: (String value) {
    //       print('onValueChanged:$value');
    //       alignment = alignmentMap[value] ?? Alignment.center;
    //     },
    //     children: map,
    //   ),
    // );
  }

  void _onPressed(int e) {
    switch (e) {
      case 1:
        showAlertDialog();
        break;
      case 2:
        {
          CupertinoAlertDialog(
            title: Text(title),
            content: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(Colors.blue),
                value: .5,
              ),
            ),
            actions: ["确定",].map((e) => _buildButton(e, () => Navigator.pop(context),)).toList(),
          ).toShowCupertinoDialog(context: context);
          // .toShowDialog(context);
        }
        break;
      case 3:
        {
          CupertinoAlertDialog(
            title: Text(title),
            content: SizedBox(
              height: 160,
              child: Padding(
                padding: const EdgeInsets.only(left: 36, right: 36, top: 16, bottom: 0,),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                  value: .7,
                ),
              ),
            ),
            actions: ["确定1",].map((e) => _buildButton(e, () => Navigator.pop(context),)).toList(),
          ).toShowCupertinoDialog(context: context);
          // .toShowDialog(context);
        }
        break;
      case 4:
        {
          CupertinoAlertDialog(
            title: Text(title),
            content: buildWrap(context),
            actions: ["确定",].map((e) => _buildButton(e, () => Navigator.pop(context),)).toList(),
          ).toShowCupertinoDialog(context: context);
          // .toShowDialog(context);
        }
        break;
      case 5:
        {
          showChioceListAlertDialog(isMutiple: false);
        }
        break;
      case 6:
        {
          showChioceListAlertDialog(isMutiple: true);
        }
        break;
      case 7:
        {
          showChioceWrapAlertDialog(isMutiple: false);
        }
        break;
      case 8:
        {
          showChioceWrapAlertDialog(isMutiple: true);
        }
        break;
      case 9:
        {
          CupertinoAlertDialog(
            title: Text("性别"),
            content: RadioTileSexWidget(
              selectedIndex: 0,
            ),
            actions: ["确定",].map((e) => _buildButton(e, () => Navigator.pop(context),)).toList(),
          ).toShowCupertinoDialog(context: context);
          // .toShowDialog(context);
        }
        break;
      case 10:
        {
          Container(
            height: 300,
            width: MediaQuery.of(context).size.width - 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: ChioceWrap(
                        indexs: [0],
                        callback: (indexs) {
                          ddlog(indexs);
                        },
                        children: titles.map((e) => Text(e)).toList(),
                      ),
                    ),
                  ),
                ),
                NCancelAndConfirmBar(
                  cancelBgColor: Theme.of(context).dialogBackgroundColor,
                  confirmBgColor: Theme.of(context).colorScheme.secondary,
                  bottomRadius: const Radius.circular(16),
                  onCancel: (){
                    debugPrint("onCancel");
                  },
                  onConfirm: (){
                    debugPrint("onConfirm");
                  }
                )
              ],
            )
          ).toShowGeneralDialog(
            context: context,
            barrierDismissible: true,
            onBarrier: (){
              Navigator.of(context).pop();
            }
          );
        }
        break;
      case 11:
        {
          showAboutDialog(
            context: context,
            // applicationIcon: FlutterLogo(size: 50,),
            applicationName: '应用程序',
            applicationVersion: '1.0.0',
            applicationLegalese: message1,
            children: <Widget>[
              Container(
                height: 30,
                color: Colors.red,
              ),
              Container(
                height: 30,
                color: Theme.of(context).primaryColor,
              ),
              Container(
                height: 30,
                color: Colors.green,
              )
            ],
          );
        }
        break;
      case 12:
        {
          showPopover(
            context: context,
            transitionDuration: Duration(milliseconds: 150),
            bodyBuilder: (context) => Container(
              height: 150,
              width: 100,
              color: Colors.green,
              child: TextButton(
                onPressed: () {
                  ddlog("Button");
                },
                child: Text("Button"),
              ),
            ),
            onPop: () => debugPrint('Popover was popped!'),
            // direction: PopoverDirection.bottom,
            // width: 200,
            // height: 400,
            // arrowHeight: 15,
            // arrowWidth: 30,
          );
        }
        break;
      case 13:
        {
          var size = Size(120, 120);
          Navigator.push(
            context,
            NPopupRoute(
              onClick: () {
                debugPrint("exit");
              },
              child: Container(
                color: Colors.red,
                width: size.width,
                height: size.height,
                child: TextButton.icon(
                  onPressed: () {
                    ddlog("刷新");
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.refresh),
                  label: Text("刷新"),
                ),
              ),
            ),
          );
        }
        break;
      case 14:
        {
          var screenSize = MediaQuery.of(context).size;
          var size = Size(screenSize.width - 40, 300);
          Navigator.push(context,
            NPopupRoute(
              alignment: alignment,
              onClick: () {
                ddlog("exit");
                //点击空白处
                Navigator.of(context).pop();
              },
              child: Container(
                // width: size.width,
                // height: size.height,
                margin: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Theme.of(context).dialogBackgroundColor,
                  borderRadius: BorderRadius.circular(10), // 圆角度
                ),
                child: buildAlertColumn(),
              ),
            ),
          );
        }
        break;
      case 15:
        {
          Navigator.push(context,
            NPopupRoute(
              alignment: alignment,
              onClick: () {
                Navigator.of(context).pop();
              },
              // child: buildAlertColumn(context, marginHor: 15),
              child: NAlertDialog(
                header: Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 12),
                  child: Text(
                    title1,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                content: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    message1,
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                ),
                cancelButton: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("取消"),
                ),
                confirmButton: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("确定"),
                ),
                // actions: ["选择A", "选择B", "选择C", "选择D"].map((e) => TextButton(onPressed: (){
                //   ddlog(e);
                //   Navigator.pop(context);
                // }, child: Text(e),)).toList(),
              ),
            ),
          );
        }
        break;
      case 16:
        {
          Navigator.push(
            context,
            NPopupRoute(
              alignment: alignment,
              onClick: () {
                Navigator.of(context).pop();
              },
              // child: buildAlertColumn(context, marginHor: 15),
              child: buildNoticationView(context),
              // child: SlideTransition(
              //   position: animation,
              //   child: buildNoticationView(context),
              // )
            ),
          );
        }
        break;
      case 17:
        {
          showUserPrivacy();
        }
        break;
      case 18:
        {
          showGeneralDialog(
            barrierDismissible: false,
              context: context,
              pageBuilder: (context, animation, secondaryAnimation) {
                return Center(
                  child: Container(
                    height: 400,
                    color: Colors.red,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 100),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                        child: Text('showGeneralDialog弹窗', style: TextStyle(fontSize: 17),)
                    )
                  ),
                );
              }
              );
        }
        break;
      case 19:
        {
          presentDialog(
            context: context,
            scrollController: ScrollController(),
            buttonBarHeight: 60,
            content: Container(
              height: 400,
              color: Colors.green,
            ),
            hasCancelButton: false,
            onCancel: () {
              Navigator.of(context).pop();
            },
            onConfirm: () {
              Navigator.of(context).pop();
            }
          );
        }
        break;
      case 20:
        {
          presentDialogAlert(
            context: context,
            scrollController: ScrollController(),
            title: title,
            message: message,
            content: Container(
              height: 400,
              color: Colors.green,
            ),
            // hasCancelButton: false,
            // cancellBgColor: context.dialogBackgroundColor,
            confirmBgColor: context.primaryColor,
            onCancel: () {
              Navigator.of(context).pop();
            },
            onConfirm: () {
              Navigator.of(context).pop();
            }
          );
        }
        break;
      case 21:
        {
          presentCupertinoAlert(context,
            content: Text("presentCupertinoAlert"),
            onConfirm: () async {
              // Navigator.of(context).pop();
            }
          );
        }
        break;
      default:
        showCupertinoAlertDialog();
        break;
    }
  }


  buildBody() {
    // return Flow(
    //   delegate: TestFlowDelegate(
    //     margin: EdgeInsets.all(10.0),
    //     spacing: 5,
    //     flowHeight: double.infinity
    //   ),
    //   children: titles.map((e) => OutlinedButton(
    //       onPressed: () {
    //         // ddlog(e);
    //         _onPressed(titles.indexOf(e));
    //       },
    //       child: Text('${e}_${titles.indexOf(e)}')))
    //       .toList(),
    // );

    return SingleChildScrollView( 
      child: Container(
        padding: EdgeInsets.all(8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: titles.map((e) => OutlinedButton(
            onPressed: () {
              _onPressed(titles.indexOf(e));
            },
            child: Text('${e}_${titles.indexOf(e)}')
          ),
          ).toList(),
        ),
      ),
    );
  }

  Widget _buildButton(String title, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        height: 45,
        child: Center(child: Text(title)),
      ),
    );
  }

  showCupertinoAlertDialog() {
    CupertinoAlertDialog(
      title: Text(title),
      content: Text(message, textAlign: TextAlign.start),
      actions: ["取消", "确定"].map((e) => TextButton(
        onPressed: () => Navigator.pop(context),
        child: Container(
          height: 45,
          child: Center(child: Text(e)),
        ),
      )).toList(),
    ).toShowCupertinoDialog(context: context);
  }

  showAlertDialog() {
    AlertDialog(
      title: Text(title),
      content: Text(message, textAlign: TextAlign.start),
      actions: ["取消", "确定"].map((e) => TextButton(
        onPressed: () {
          ddlog(e);
          Navigator.pop(context);
        },
        child: Text(e),
      )).toList(),
    ).toShowCupertinoDialog(context: context);
    // .toShowDialog(context: context);
  }

  Wrap buildWrap(BuildContext context) {
    return Wrap(
      spacing: 8.0, // 主轴(水平)方向间距
      runSpacing: -8.0, // 纵轴（垂直）方向间距
      alignment: WrapAlignment.start, //沿主轴方向居中
      children: titles.map((e) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: TextButton.icon(
          onPressed: () {
            ddlog(titles.indexOf(e));
            // }, icon: Icon(Icons.check_circle_outline), label: Text("Button"))).toList(),
          },
          icon: Icon(Icons.radio_button_unchecked_outlined),
          label: Text(e),
          style: OutlinedButton.styleFrom(
            primary: Colors.black87,
            side: BorderSide(width: 1, color: Colors.transparent),
          ),
        ),
      ))
      .toList(),
    );
  }

  //多选/单选
  showChioceListAlertDialog({bool isMutiple = false}) {

    CupertinoAlertDialog(
      title: Text("ChioceList ${isMutiple ? '多选' : '单选'}"),
      content: ChioceList(
        isMutiple: isMutiple,
        // backgroudColor: Colors.black.withAlpha(10),
        children: payTypes,
        indexs: [0],
        canScroll: false,
        callback: (indexs) {
          ddlog([indexs.runtimeType, indexs]);
        },
      ),
      actions: ["确定",].map((e) => _buildButton(e, () => Navigator.pop(context),)).toList(),
    ).toShowDialog(context: context);
    // .toShowDialog(context);
  }

  showChioceWrapAlertDialog({bool isMutiple = false}) {
    CupertinoAlertDialog(
      title: Text("ChioceWrap ${isMutiple ? '多选' : '单选'}"),
      content: ChioceWrap(
        isMutiple: isMutiple,
        indexs:[0],
        callback: (indexs) {
          ddlog(indexs);
        },
        children: titles.map((e) => Text(e)).toList(),
      ),
      actions: ["确定",].map((e) => _buildButton(e, () => Navigator.pop(context),)).toList(),
    ).toShowCupertinoDialog(context: context);
  }
  ///自约束
  Widget buildAlertColumn() {
    // Size screenSize = MediaQuery.of(context).size;
    // double width = screenSize.width - spacingHor * 2;

    var spacingVer = 8.0;
    var spacingHor = 15.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacingHor,
            vertical: spacingVer,
          ),
          child: Text(title1, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        ),
        Container(
          // color: Colors.green,
          padding: EdgeInsets.only(
            left: spacingHor,
            right: spacingHor,
            bottom: spacingVer
          ),
          child: Text(message1),
        ),
        Container(
          height: 0.5,
          color: Colors.grey[400],
        ),
        Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    ddlog("取消");
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.cancel_outlined),
                  label: Text("取消"),
                ),
              ),
              Container(
                height: 55,
                child: VerticalDivider(color: Colors.grey[400])
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    ddlog("确定");
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.check),
                  label: Text("确定"),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildNoticationView(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var spacingVer = 8.0;
    var spacingHor = 15.0;

    return GestureDetector(
      onTap: () {
        ddlog("tap Container");
      },
      child: Container(
        width: screenSize.width - 30,
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.circular((10.0)), // 圆角度
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: spacingVer,
                  left: spacingHor,
                  bottom: spacingVer,
                  right: spacingHor),
              child: Text(
                title1,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: spacingHor, bottom: spacingVer, right: spacingHor),
              child: Text(
                message1,
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
            // Container(
            //   width: MediaQuery.of(context).size.width - spacingHor*2,
            //   height: 0.5,
            //   color: Colors.grey[400],
            // ),
          ],
        ),
      ),
    );
  }

  showUserPrivacy() {
    var linkMap = {
      '《用户协议》': 'https://flutter.dev',
      '《隐私政策》': 'https://flutter.dev',
    };

    var text = """
亲爱的xxxx用户，感谢您信任并使用xxxxAPP！
xxxx十分重视用户权利及隐私政策并严格按照相关法律法规的要求，对《用户协议》和《隐私政策》进行了更新,特向您说明如下：
1.为向您提供更优质的服务，我们会收集、使用必要的信息，并会采取业界先进的安全措施保护您的信息安全；
2.基于您的明示授权，我们可能会获取设备号信息、包括：设备型号、操作系统版本、设备设置、设备标识符、MAC（媒体访问控制）地址、IMEI（移动设备国际身份码）、广告标识符（“IDFA”与“IDFV”）、集成电路卡识别码（“ICCD”）、软件安装列表。我们将使用三方产品（友盟、极光等）统计使用我们产品的设备数量并进行设备机型数据分析与设备适配性分析。（以保障您的账号与交易安全），且您有权拒绝或取消授权；
3.您可灵活设置伴伴账号的功能内容和互动权限，您可在《隐私政策》中了解到权限的详细应用说明；
4.未经您同意，我们不会从第三方获取、共享或向其提供您的信息；
5.您可以查询、更正、删除您的个人信息，我们也提供账户注销的渠道。
请您仔细阅读并充分理解相关条款，其中重点条款已为您黑体加粗标识，方便您了解自己的权利。如您点击“同意”，即表示您已仔细阅读并同意本《用户协议》及《隐私政策》，将尽全力保障您的合法权益并继续为您提供优质的产品和服务。如您点击“不同意”，将可能导致您无法继续使用我们的产品和服务。
""";
    final textRich = Text.rich(
      TextSpan(
          text: '登录即代表同意并阅读，',
          // style: TextStyle(fontSize: 14),
          // children: AttributedString(
          //     context: context,
          //     text: text,
          //     linkMap: protocolMap,
          //     onTap: (key, value){
          //       ddlog(key);
          //       ddlog(value);
          //     }
          // ).textSpans,
          children: RichTextExt.createTextSpans(
            text: text,
            textTaps: linkMap.keys.toList(),
   onLink    onLink: (textTap){
              ddlog(textTap);
            },
          )
      ),
    );

    showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return NUserPrivacy(
            title: Text('用户隐私及协议',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: textRich,
            onCancel: () {
              ddlog("Cancel");
              Navigator.of(context).pop();
            },
            onConfirm: () {
              ddlog("Confirm");
              Navigator.of(context).pop();
            },
          );
        });
  }
}

class TestFlowDelegate extends FlowDelegate {

  TestFlowDelegate({
    this.margin = const EdgeInsets.all(0),
    this.spacing = 8.0,
    this.flowHeight = double.infinity
  });

  EdgeInsets margin;

  double spacing;

  double flowHeight;

  @override
  void paintChildren(FlowPaintingContext context) {
    var x = margin.left;
    var y = margin.top;
    //计算每一个子widget的位置
    for (var i = 0; i < context.childCount; i++) {
      var w = context.getChildSize(i)!.width + x + margin.right;
      if (w < context.size.width) {
        context.paintChild(i, transform: Matrix4.translationValues(x, y, 0.0));
        x = w + margin.left;
      } else {
        x = margin.left;
        y += context.getChildSize(i)!.height + spacing;
        //绘制子widget(有优化)
        context.paintChild(i, transform: Matrix4.translationValues(x, y, 0.0));
        x += context.getChildSize(i)!.width + margin.left + margin.right;
      }
    }
  }

  @override
  getSize(BoxConstraints constraints) {
    //指定Flow的大小
    // return Size(double.infinity, 250.0);
    return Size(double.infinity, flowHeight);
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }
}
