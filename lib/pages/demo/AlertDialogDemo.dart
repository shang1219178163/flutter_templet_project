import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_templet_project/basicWidget/chioce_list.dart';
import 'package:flutter_templet_project/basicWidget/chioce_wrap.dart';
import 'package:flutter_templet_project/basicWidget/NNUserPrivacy.dart';
import 'package:flutter_templet_project/basicWidget/NNWebView.dart';
import 'package:flutter_templet_project/basicWidget/NNPopupRoute.dart';
import 'package:flutter_templet_project/basicWidget/NNAlertDialog.dart';

import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/richText_extension.dart';
import 'package:flutter_templet_project/extension/widget_extension.dart';
import 'package:flutter_templet_project/extension/alertDialog_extension.dart';
import 'package:get/get.dart';

import 'package:popover/popover.dart';

import 'package:styled_widget/styled_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'AlertSheetDemo.dart';

class AlertDialogDemo extends StatefulWidget {
  @override
  _AlertDialogDemoState createState() => _AlertDialogDemoState();
}

class _AlertDialogDemoState extends State<AlertDialogDemo>
    with SingleTickerProviderStateMixin {
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
——曼德拉《漫漫人生路》
""";

  Object? sex = 1;

  Map<String, Widget> map = {
    'topCenter': Text("topCenter"),
    'Center': Text("Center"),
    'bottomCenter': Text("bottomCenter"),
  };

  var alignment = Alignment.center;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text("$widget"),
          actions: [
            TextButton(
                onPressed: () {
                  ddlog(Icons.extension);
                },
                child: Icon(
                  Icons.extension,
                  color: Colors.white,
                )
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(45),
            child: CupertinoSegmentedControl(
              unselectedColor: Colors.blue,
              selectedColor: Colors.white,
              borderColor: Colors.transparent,
              pressedColor: Colors.green,
              onValueChanged: (Object value) {
                print('onValueChanged:$value');
              },
              children: map,
            ),
          ),
        ),
        body: Flow(
          delegate: TestFlowDelegate(
              margin: EdgeInsets.all(10.0),
              spacing: 5,
              flowHeight: double.infinity),
          children: titles.map((e) => OutlinedButton(
            onPressed: () {
              // ddlog(e);
              _onPressed(titles.indexOf(e));
            },
            child: Text('${e}_${titles.indexOf(e)}')))
          .toList(),
        ));
  }

  void _onPressed(int e) {
    final screenSize = MediaQuery.of(context).size;

    ddlog(screenSize);
    switch (e) {
      case 1:
        showAlertDialog();
        break;

      case 2:
        {
          CupertinoAlertDialog(
            title: Text(title),
            content: LinearProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(Colors.blue),
              value: .5,
            ).padding(top: 15),
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
          showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: 'barrierLabel',
            transitionDuration: Duration(milliseconds: 200),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return Center(
                child: Container(
                  height: 300,
                  width: 250,
                  color: Colors.white,
                  // child: TextButton(
                  //   child: Text("button"),
                  //   onPressed: () { ddlog("button"); },
                  // ),
                  child: ChioceWrap(
                    children: titles.map((e) => Text(e)).toList(),
                    indexs: [0],
                    callback: (indexs) {
                      ddlog(indexs);
                    },
                  ))
              .decorated(
                  color: Color(0xff7AC1E7), shape: BoxShape.circle),
              );
            });
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
              height: 50,
              width: 100,
              color: Colors.green,
              child: TextButton(
                child: Text("Button"),
                onPressed: () {
                  ddlog("Button");
                  ddlog(widget);
                  ddlog(this);
                },
              ),
            ),
            onPop: () => print('Popover was popped!'),
            direction: PopoverDirection.bottom,
            width: 200,
            height: 400,
            arrowHeight: 15,
            arrowWidth: 30,
          );
        }
        break;

      case 13:
        {
          Size size = Size(120, 120);
          Navigator.push(
            context,
            NNPopupRoute(
              onClick: () {
                print("exit");
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
          Size screenSize = MediaQuery.of(context).size;
          Size size = Size(screenSize.width - 30, 300);
          Navigator.push(context,
            NNPopupRoute(
              alignment: alignment,
              onClick: () {
                ddlog("exit");
                //点击空白处
                Navigator.of(context).pop();
              },
              child: Container(
                // color: Colors.white,
                // width: size.width,
                // height: size.height,
                // padding: EdgeInsets.only(top: 8, left: 58, bottom: 0, right: 58),
                child: buildAlertColumn(context),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular((10.0)), // 圆角度
                ),
              ),
            ),
          );
        }
        break;
      case 15:
        {
          // final list = [null, "aaa"];
          // ddlog(list);

          Navigator.push(context,
            NNPopupRoute(
              alignment: alignment,
              onClick: () {
                ddlog("exit");
                //点击空白处
                Navigator.of(context).pop();
              },
              // child: buildAlertColumn(context, marginHor: 15),
              child: NNAlertDialog(
                marginHor: 10,
                title: Text(
                  title1,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                content: Text(
                  message1,
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                actionCancell: TextButton(
                  onPressed: () {
                    ddlog("取消");
                    Navigator.of(context).pop();
                  },
                  child: Text("取消"),
                ),
                actionConfirm: TextButton(
                  onPressed: () {
                    ddlog("确定");
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
          double spacingVer = 8;
          double spacingHor = 15;

          Navigator.push(
            context,
            NNPopupRoute(
              alignment: alignment,
              onClick: () {
                ddlog("exit");
                //点击空白处
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
              context: context,
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return Center(
                  child: Text('showGeneralDialog'),
                );
              });
        }
        break;
      case 19:
        {}
        break;
      default:
        showCupertinoAlertDialog();
        break;
    }
  }

  Widget _buildButton(String title, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        height: 45,
        child: Center(child: Text(title)),
      ),
    );
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Center(
          child: Text(title,
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            )),
        ),
      ),
    );
  }

  void showCupertinoAlertDialog() {
    CupertinoAlertDialog(
      title: Text(title),
      content: Text(message, textAlign: TextAlign.start),
      actions: ["取消", "确定"].map((e) => _buildButton(e, () => Navigator.pop(context),)).toList(),
    ).toShowCupertinoDialog(context: context);
    // .toShowDialog(context);
  }

  void showAlertDialog() {
    AlertDialog(
      title: Text(title),
      content: Text(message).textAlignment(TextAlign.start),
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
    final list = [
      ChioceModel(
          title: Text("微信支付"),
          subtitle: Text("微信支付，不止支付"),
          secondary: Icon(Icons.camera),
          selected: false),
      ChioceModel(
          title: Text("阿里支付"),
          subtitle: Text("支付就用支付宝"),
          secondary: Icon(Icons.palette),
          selected: false),
      ChioceModel(
          title: Text("银联支付"),
          subtitle: Text("不打开APP就支付"),
          secondary: Icon(Icons.payment),
          selected: false),
    ];

    CupertinoAlertDialog(
      title: Text("ChioceList ${isMutiple ? '多选' : '单选'}"),
      content: ChioceList(
        isMutiple: isMutiple,
        backgroudColor: Colors.black.withAlpha(10),
        children: list,
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
        children: titles.map((e) => Text(e)).toList(),
        indexs:[0],
        callback: (indexs) {
          ddlog(indexs);
        },
      ),
      actions: ["确定",].map((e) => _buildButton(e, () => Navigator.pop(context),)).toList(),
    ).toShowCupertinoDialog(context: context);
  }
  ///自约束
  Widget buildAlertColumn(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    double spacingVer = 8;
    double spacingHor = 15;
    double width = screenSize.width - spacingHor * 2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: spacingVer,
            left: spacingHor,
            bottom: spacingVer,
            right: spacingHor),
          child: Text(title1),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: spacingHor, bottom: spacingVer, right: spacingHor),
          child: Text(message1),
        ),
        Container(
          width: MediaQuery.of(context).size.width - spacingHor * 2,
          height: 0.5,
          color: Colors.grey[400],
        ),
        Container(
          width: MediaQuery.of(context).size.width - 60,
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
                  height: 55, child: VerticalDivider(color: Colors.grey[400])),
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
    Size screenSize = MediaQuery.of(context).size;
    double spacingVer = 8;
    double spacingHor = 15;

    return GestureDetector(
      onTap: () {
        ddlog("tap Container");
      },
      child: Container(
        width: screenSize.width - 30,
        decoration: BoxDecoration(
          color: Colors.white,
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

  ///创建 WebView
  Widget buildWebView(BuildContext context, {required String initialUrl}) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 100,
          leading: Container(
            child: Row(
              children: [Icons.chevron_left, Icons.close]
                  .map(
                    (e) => IconButton(
                      icon: Icon(e),
                      iconSize: 30,
                      // color: Theme.of(context).accentColor,
                      onPressed: () {
                        if (e == Icons.chevron_left) {
                          Navigator.of(context).pop();
                        } else if (e == Icons.close) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: [
            Icons.refresh,
          ]
              .map(
                (e) => IconButton(
                  icon: Icon(e),
                  iconSize: 30,
                  // color: Theme.of(context).accentColor,
                  onPressed: () {},
                ),
              )
              .toList(),
        ),
        body: WebView(initialUrl: initialUrl));
  }

  showUserPrivacy() {
    var linkMap = {
      '《用户协议》': 'https://flutter.dev',
      '《隐私政策》': 'https://flutter.dev',
    };

    String text = """
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
          children: RichTextExt.createTextSpans(context,
              text: text, linkMap: linkMap, onTap: (key, value) {
                ddlog(key);
                ddlog(value);
              })),
    );

    showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return NNUserPrivacy(
            title: Text('用户隐私及协议', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
  EdgeInsets margin = EdgeInsets.zero;
  double spacing = 8.0;
  double flowHeight = double.infinity;

  TestFlowDelegate(
      {required this.margin, required this.spacing, required this.flowHeight});

  @override
  void paintChildren(FlowPaintingContext context) {
    var x = margin.left;
    var y = margin.top;
    //计算每一个子widget的位置
    for (int i = 0; i < context.childCount; i++) {
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
