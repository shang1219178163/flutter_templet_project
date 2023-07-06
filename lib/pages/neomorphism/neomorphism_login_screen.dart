import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/pages/neomorphism/neomorphism_cards_screen.dart';
import 'package:flutter_templet_project/pages/neomorphism/neomorphism_custom_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NeomorphismLoginScreen extends StatefulWidget {
  NeomorphismLoginScreen({Key? key}) : super(key: key);

  @override
  _NeomorphismLoginScreenState createState() => _NeomorphismLoginScreenState();
}

class _NeomorphismLoginScreenState extends State<NeomorphismLoginScreen> {
  bool status = true;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(1080, 2160),
    );
    return Scaffold(
      backgroundColor: Color(0xFFF1F3F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 120.w
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 100.h,
                ),
                Text(
                  "Login",
                  style: TextStyle(
                    color: Color(0xFF4D70A6),
                    fontSize: 26,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(
                  height: 170.h,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: buildButton(FontAwesomeIcons.facebookF),
                    ),
                    SizedBox(
                      width: 60.w,
                    ),
                    Expanded(
                      child: buildButton(FontAwesomeIcons.google),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                ...buildAccountBox(),
                SizedBox(
                  height: 130.h,
                ),
                ...buildLoginBox(),
              ],
            )
          ),
        ),
      ));
  }

  Widget buildButton(IconData icon) {
    return Container(
      height: 120.h,
      margin: EdgeInsets.symmetric(vertical: 30),
      decoration: buildDecoration(),
      child: Icon(
        icon,
        color: Color(0xFF4D70A6),
      ),
    );
  }

  /// 内外阴影
  Decoration buildDecoration() {
    return BoxDecoration(
      color: Color(0xFFF1F3F6),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      boxShadow: [
        BoxShadow(
            offset: Offset(10, 10),
            color: Color(0xFF4D70A6).withOpacity(0.2),
            blurRadius: 16
        ),
        BoxShadow(
            offset: Offset(-10, -10),
            color: Color.fromARGB(170, 255, 255, 255),
            blurRadius: 10
        ),
      ]
    );
  }

  List<Widget> buildAccountBox() {
    return [
      Stack(
        children: <Widget>[
          TextField(
            style: TextStyle(color: Color(0xFF4D70A6)),
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(0xFF4D70A6),
                      width: 2
                  ),
                ),
                labelText: "Username",
                labelStyle: TextStyle(
                    color: Color(0xFF4D70A6),
                    fontSize: 14
                )
            ),
          ),
          Positioned(
            right: 1,
            bottom: 8,
            child: Container(
              height: 30,
              width: 30,
              decoration: buildDecoration(),
              child: Icon(
                Icons.check,
                color: Color(0xFF4D70A6),
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 100.h,
      ),
      TextField(
        style: TextStyle(color: Color(0xFF4D70A6)),
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide:
              BorderSide(color: Color(0xFF4D70A6), width: 2),
            ),
            labelText: "Password",
            labelStyle: TextStyle(
                color: Color(0xFF4D70A6),
                fontSize: 14
            )
        ),
      ),
      SizedBox(
        height: 70.h,
      ),
      Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              /*boxShadow: [
                        BoxShadow(
                            offset: Offset(5, 5),
                            color: Color(0xFF4D70A6).withOpacity(0.2),
                            blurRadius: 16),
                        BoxShadow(
                            offset: Offset(-10, -10),
                            color: Color.fromARGB(170, 255, 255, 255),
                            blurRadius: 10),
                      ]*/
            ),
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
            "Remember me",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Spacer(),
          Text(
            "Forgot Password?",
            style: TextStyle(
              color: Color(0xFF4D70A6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> buildLoginBox() {
    return [
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NeomorphismCardsScreen()));
        },
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          height: 120.h,
          margin: EdgeInsets.symmetric(vertical: 15),
          decoration: buildDecoration(),
          child: Text(
            "Login",
            style:
            TextStyle(color: Color(0xFF4D70A6), fontSize: 16),
          ),
        ),
      ),
      Center(
        child: RichText(
          text: TextSpan(children: <TextSpan>[
            TextSpan(
                text: "Don't have an account?",
                style: TextStyle(color: Colors.grey)),
            TextSpan(
                text: " Sign Up",
                style: TextStyle(color: Color(0xFF4D70A6))),
          ]),
        ),
      ),
    ];
  }
}
