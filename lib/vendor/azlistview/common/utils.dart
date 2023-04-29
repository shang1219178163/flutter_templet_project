import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/vendor/azlistview/common/index.dart';

class Utils {
  static String getImgPath(String name, {String format: 'png'}) {
    if (name.contains(".")) {
      return 'assets/images/$name';
    }
    return 'assets/images/$name.$format';
  }

  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: 2),
      ),
    );
  }

  static Widget getSusItem(
      BuildContext context,
      String tag,
      {double susHeight = 40, Color
      color = const Color(0xFFF3F4F5)
  }) {
    if (tag == '★') {
      tag = '★ 热门城市';
    }
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 16.0),
      color: color,
      alignment: Alignment.centerLeft,
      child: Text(
        '$tag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xFF666666),
        ),
      ),
    );
  }

  static Widget getListItem(BuildContext context, CityModel model,
      {double susHeight = 40}) {
    return ListTile(
      title: Text(model.name),
      onTap: () {
        LogUtil.e("onItemClick : $model");
        Utils.showSnackBar(context, 'onItemClick : ${model.name}');
      },
    );
//    return Column(
//      mainAxisSize: MainAxisSize.min,
//      children: <Widget>[
//        Offstage(
//          offstage: !(model.isShowSuspension == true),
//          child: getSusItem(context, model.getSuspensionTag(),
//              susHeight: susHeight),
//        ),
//        ListTile(
//          title: Text(model.name),
//          onTap: () {
//            LogUtil.e("onItemClick : $model");
//            Utils.showSnackBar(context, 'onItemClick : ${model.name}');
//          },
//        )
//      ],
//    );
  }

  static Widget getWeChatListItem(
    BuildContext context,
    ContactInfo model, {
    double susHeight = 40,
    Color? defHeaderBgColor,
  }) {
    return getWeChatItem(context, model, defHeaderBgColor: defHeaderBgColor);
//    return Column(
//      mainAxisSize: MainAxisSize.min,
//      children: <Widget>[
//        Offstage(
//          offstage: !(model.isShowSuspension == true),
//          child: getSusItem(context, model.getSuspensionTag(),
//              susHeight: susHeight),
//        ),
//        getWeChatItem(context, model, defHeaderBgColor: defHeaderBgColor),
//      ],
//    );
  }

  static Widget getWeChatItem(
    BuildContext context,
    ContactInfo model, {
    Color? defHeaderBgColor,
  }) {
    DecorationImage? image;
//    if (model.img != null && model.img.isNotEmpty) {
//      image = DecorationImage(
//        image: CachedNetworkImageProvider(model.img),
//        fit: BoxFit.contain,
//      );
//    }
    return Container(
        decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
              color: Color(0xfff4f4f4)
          )
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4.0),
            color: model.bgColor ?? defHeaderBgColor,
            image: image,
            border: Border.all(
                width: 1.0
            ),
          ),
          child: model.iconData == null
              ? null
              : Icon(
                  model.iconData,
                  color: Colors.white,
                  size: 20,
                ),
        ),
        title: Text(model.name*3,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          LogUtil.e("onItemClick : $model");
          Utils.showSnackBar(context, 'onItemClick : ${model.name}');
        },
      ),
    );
  }
}
