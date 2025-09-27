import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/inner_shadow.dart';
import 'package:flutter_templet_project/pages/neomorphism/neomorphism_custom_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuple/tuple.dart';

class NeomorphismCardsScreen extends StatefulWidget {
  NeomorphismCardsScreen({Key? key}) : super(key: key);

  @override
  _NeomorphismCardsScreenState createState() => _NeomorphismCardsScreenState();
}

class _NeomorphismCardsScreenState extends State<NeomorphismCardsScreen> {
  bool status = true;

  final items = [
    Tuple3(
      0,
      false,
      Icon(
        Icons.home,
        color: Color(0xFF4D70A6),
      ),
    ),
    Tuple3(
      1,
      true,
      Icon(
        FontAwesomeIcons.film,
        color: Color(0xFF4D70A6),
      ),
    ),
    Tuple3(
      2,
      false,
      Icon(
        FontAwesomeIcons.database,
        color: Color(0xFF4D70A6),
      ),
    ),
    Tuple3(
      3,
      false,
      Icon(
        Icons.chat_bubble,
        color: Color(0xFF4D70A6),
      ),
    ),
    Tuple3(
      4,
      false,
      Icon(
        Icons.settings,
        color: Color(0xFF4D70A6),
      ),
    ),
  ];

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(1080, 2160),
    );
    return Scaffold(
        backgroundColor: Color(0xFFF1F3F6),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                // height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.symmetric(horizontal: 120.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 100.h,
                    ),
                    Text(
                      "Cards",
                      style: TextStyle(
                          color: Color(0xFF4D70A6),
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                    buildButtonBar(),
                    SizedBox(
                      height: 20.h,
                    ),
                    buildAppleCard(),
                    SizedBox(
                      height: 40.h,
                    ),
                    buildAppleCardFooter(),
                    SizedBox(
                      height: 60.h,
                    ),
                    Text(
                      "Today",
                      style: TextStyle(
                          color: Color(0xFF4D70A6),
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                    listTile(
                        "Starbucks Coffee",
                        "55.00 \$",
                        Icon(
                          Icons.local_drink,
                          color: Color(0xFF4D70A6),
                        )),
                    listTile(
                        "Transfer to Acidney D.",
                        "55.00 \$",
                        Icon(
                          FontAwesomeIcons.rightLeft,
                          color: Color(0xFF4D70A6),
                        )),
                  ],
                )),
          ),
        ));
  }

  Widget buildButtonBar() {
    return StatefulBuilder(builder: (context, setState) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((e) {
          return InkWell(
            hoverColor: Colors.transparent,
            onTap: () {
              selectedIndex = e.item1;
              setState(() {});
            },
            child: buildButton(
              e.item3,
              selected: selectedIndex == e.item1,
            ),
          );
        }).toList(),
      );
    });
  }

  /// 内外阴影
  Decoration buildShadowDecoration({double radius = 10}) {
    return BoxDecoration(
        color: Color(0xFFF1F3F6),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        boxShadow: [
          BoxShadow(
              offset: Offset(10, 10),
              color: Color(0xFF4D70A6).withOpacity(0.2),
              blurRadius: 16),
          BoxShadow(
              offset: Offset(-10, -10),
              color: Color.fromARGB(170, 255, 255, 255),
              blurRadius: 10),
        ]);
  }

  Widget buildAppleCard() {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          height: 520.h,
          margin: EdgeInsets.symmetric(
            vertical: 15.h,
          ),
          decoration: buildShadowDecoration(radius: 20),
        ),
        Positioned(
          top: 30,
          left: 20,
          child: Icon(
            FontAwesomeIcons.apple,
            size: 40,
            color: Color(0xFF4D70A6).withOpacity(0.5),
          ),
        ),
        Positioned(
          bottom: 30,
          right: 20,
          child: Icon(
            FontAwesomeIcons.ccMastercard,
            size: 40,
            color: Color(0xFF4D70A6).withOpacity(0.5),
          ),
        ),
        Positioned(
          bottom: 60,
          left: 20,
          child: Text(
            "Márcio Quimbundo",
            style: TextStyle(color: Color(0xFF4D70A6)),
          ),
        ),
      ],
    );
  }

  Widget buildAppleCardFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          child: CustomSwitch(
            activeColor: Color(0xFFF1F3F6),
            value: status,
            onChanged: (value) {
              setState(() {
                status = value;
              });
            },
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          "Active",
          style: TextStyle(
              color: Color(0xFF4D70A6),
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        Text(
          "Foce ID before payment",
          style: TextStyle(
            color: Color(0xFF4D70A6).withOpacity(.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget listTile(String title, String cost, Icon icon) {
    return Container(
      // width: double.infinity,
      // alignment: Alignment.center,
      height: 230.h,
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: buildShadowDecoration(radius: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 30,
          ),
          buildCard(icon),
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF4D70A6).withOpacity(.7)),
                ),
                Text(
                  cost,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D70A6).withOpacity(.7)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildCard(Widget child, {double radius = 10}) {
    return Container(
      height: 130.h,
      width: 130.h,
      // margin: EdgeInsets.symmetric(vertical: 30),
      decoration: buildShadowDecoration(radius: radius),
      child: child,
    );
  }

  Widget buildButton(Widget child, {bool selected = false}) {
    if (!selected) {
      return buildCard(child);
    }
    return Stack(
      children: <Widget>[
        InnerShadow(
          color: Color(0xFF4D70A6).withOpacity(.2),
          offset: Offset(5, 5),
          blur: 2,
          child: Container(
            height: 130.h,
            width: 130.h,
            margin: EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFF1F3F6),
            ),
            child: child,
          ),
        ),
        Positioned(
          bottom: 10,
          left: 23,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xFF4D70A6),
            ),
          ),
        )
      ],
    );
  }
}
