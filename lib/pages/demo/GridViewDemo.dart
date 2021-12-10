import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';
import 'package:styled_widget/styled_widget.dart';

class GridViewDemo extends StatefulWidget {

  @override
  _GridViewDemoState createState() => _GridViewDemoState();
}

class _GridViewDemoState extends State<GridViewDemo> {

  var titles = ["默认样式", "ListTile", "添加子视图", "3", "4", "5", "6", "7", "8"];



  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text("$widget"),
          actions: [
            TextButton(onPressed: (){

            }, child: Text("done")),
          ],
        ),
        // body: buildWrap(context).padding(all: 10)
        body: buildGridView(titles)

    );
  }


  void _onPressed(int e) {
    ddlog(e);
  }

  Widget buildGridView(List<String> list) {
    return GridView.count(
      padding: EdgeInsets.all(15.0),
      //一行多少个
      crossAxisCount: 2,
      //滚动方向
      scrollDirection: Axis.vertical,
      // 左右间隔
      crossAxisSpacing: 8,
      // 上下间隔
      mainAxisSpacing: 8,
      //宽高比
      childAspectRatio: 3 / 4,

      children: [
        GridTile(
          header: GridTileBar(
            title: Text('title', style: TextStyle(color: Colors.black),),
            subtitle: Text('subtitle', style: TextStyle(color: Colors.black),),
            leading: Icon(Icons.add, color: Colors.black,),
            trailing: Text("trailing", style: TextStyle(color: Colors.black),),
          )
              .decorated(color: Colors.green)
          ,
          child: Container(
              child: Center(
                child: Text("GridTileBar"),
              )
          )
              .decorated(color: Theme.of(context).primaryColor)
          ,
          footer: Text('footer', textAlign: TextAlign.center,)
              .decorated(color: Colors.green),
        ),

        GridPaper(
          interval: 1,
          divisions: 2,
          subdivisions: 4,
          color: Colors.transparent,
          child: FadeInImage(
              image: NetworkImage("https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80"),
              placeholder: AssetImage('assets/img_404.png'),
              fit: BoxFit.cover),
        ),

        Container(
          child: FlutterLogo(),
        )
            .border(all: 1, color: Colors.lightBlue,)
            .gestures(onTap: () => {
          ddlog("item")
        }),

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
            child: Text("Card",
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
          ),
        ),
        buildCard(context),
      ],
    );
  }

  Widget buildCard(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              // leading: Icon(Icons.album),
              title: Text('这是一个 Card 子视图'),
              // subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: Text('YES'),
                  onPressed: () { ddlog('YES'); },
                ),
                SizedBox(width: 8),
                TextButton(
                  child: Text('NO'),
                  onPressed: () { ddlog('NO'); },
                ),
                SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

}


