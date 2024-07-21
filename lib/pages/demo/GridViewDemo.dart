import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/im_group_avatar.dart';
import 'package:flutter_templet_project/basicWidget/n_grid_view.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/map_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/model/user_model.dart';
import 'package:flutter_templet_project/util/R.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:get/get.dart';

class GridViewDemo extends StatefulWidget {
  const GridViewDemo({Key? key}) : super(key: key);

  @override
  _GridViewDemoState createState() => _GridViewDemoState();
}

class _GridViewDemoState extends State<GridViewDemo> {
  var titles = ["默认样式", "ListTile", "添加子视图", "3", "4", "5", "6", "7", "8"];

  Color get primaryColor => Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
        actions: [
          TextButton(onPressed: () {}, child: Text("done")),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            buildNGridView(),
            Container(
              height: 200,
              child: buildGridView(titles),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed(int e) {
    ddlog(e);
  }

  Widget buildGridView(List<String> list) {
    final style = TextStyle(color: Colors.black, fontSize: 12);
    return GridView.count(
      padding: EdgeInsets.all(15.0),
      //一行多少个
      crossAxisCount: 5,
      //滚动方向
      scrollDirection: Axis.vertical,
      // 左右间隔
      crossAxisSpacing: 8,
      // 上下间隔
      mainAxisSpacing: 8,
      //宽高比
      childAspectRatio: 3 / 5,

      children: [
        GridTile(
          header: DecoratedBox(
            decoration: BoxDecoration(
              // color: Colors.transparent,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            child: GridTileBar(
              title: Text(
                'title',
                style: style,
              ).toBorder(color: ColorExt.random),
              subtitle: Text(
                'subtitle',
                style: style,
              ).toBorder(color: ColorExt.random),
              // leading: Icon(
              //   Icons.add,
              //   color: Colors.black,
              //   size: 14,
              // ).toColoredBox(),
              // trailing: Text(
              //   "trailing",
              //   style: style,
              // ).toColoredBox(),
            ),
          ),
          footer: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text(
              'footer',
              textAlign: TextAlign.center,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Center(
              child: Text("GridTileBar"),
            ),
          ),
        ),
        GridPaper(
          interval: 1,
          divisions: 2,
          subdivisions: 4,
          color: Colors.transparent,
          child: FadeInImage(
            image: NetworkImage(
              "https://images.unsplash"
              ".com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80",
            ),
            placeholder: 'img_404.png'.toAssetImage(),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.lightBlue,
            ),
          ),
          child: FlutterLogo(),
        ),
        Card(
          color: Theme.of(context).primaryColor,
          //z轴的高度，设置card的阴影
          elevation: 20.0,
          //设置shape，这里设置成了R角
          shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.all(Radius.circular(20.0)),),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.zero,
                bottomLeft: Radius.zero,
                bottomRight: Radius.circular(20.0)),
          ),
          //对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
          clipBehavior: Clip.antiAlias,
          semanticContainer: false,
          child: Container(
            color: Colors.deepPurpleAccent,
            width: 200,
            height: 150,
            alignment: Alignment.center,
            child: Text(
              "Card",
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
          ),
        ),
        buildCard(context),
      ],
    );
  }

  Widget buildCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Text(
                  '这是一个 Card 子视图',
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                // subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size(50, 18),
                    ),
                    onPressed: () {
                      ddlog('YES');
                    },
                    child: Text('YES'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size(50, 18),
                    ),
                    onPressed: () {
                      ddlog('NO');
                    },
                    child: Text('NO'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNGridView() {
    final indexs = List.generate(10, (index) => index);
    final memberList = indexs
        .map((e) => UserModel(
              id: e.toString(),
              name: "用户名称${IntExt.random(max: 10000, min: 1000)}",
              nickName: "${4.generateChars()}",
              avatar: R.image.urls[IntExt.random(max: R.image.urls.length)],
            ))
        .toList();

    return Container(
      // height: 170,
      padding: const EdgeInsets.only(
        top: 16,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          NGridView(
            children: buildGroupAvatars(
              list: memberList,
              onTap: (model) {
                ddlog(model.toJson().filter((key, value) => value != null));
              },
              onAdd: () {
                ddlog("onAdd");
              },
              onDel: () {
                ddlog("onDel");
              },
              itemWidth: 54,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NText(
                  '查看更多群成员',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: fontColor737373,
                ),
                Image(
                  image: 'icon_arrow_right.png'.toAssetImage(),
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 渲染 avatar group 中的头像
  List<Widget> buildGroupAvatars({
    required List<UserModel> list,
    ValueChanged<UserModel>? onTap,
    VoidCallback? onAdd,
    VoidCallback? onDel,
    int showLength = 10,
    double itemWidth = 54,
  }) {
    List<UserModel> listNew =
        list.length > showLength ? list.sublist(0, showLength) : list;

    List<Widget> listView = listNew.map(
      (e) {
        var avatarUrl = e.avatar;
        String title = e.name ?? '';
        // String memberAccount = e.userId ?? "";
        String subtitle = e.nickName ?? "";

        return ImGroupAvatar(
          onTap: () => onTap?.call(e),
          avatar: avatarUrl,
          title: title,
          subtitle: subtitle,
          width: itemWidth,
        );
      },
    ).toList();
    listView.add(ImGroupAvatar(
      onTap: onAdd,
      avatar: "",
      placeholder: const AssetImage("assets/images/icon_user_add.png"),
      title: "",
      subtitle: "",
      width: itemWidth,
    ));
    listView.add(ImGroupAvatar(
      onTap: onDel,
      avatar: "",
      placeholder: const AssetImage("assets/images/icon_user_del.png"),
      title: "",
      subtitle: "",
      width: itemWidth,
    ));
    return listView;
  }
}
