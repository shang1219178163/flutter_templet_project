import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

// import 'dart:html';

late String likes = "0",
    gotpoints = "0",
    popularity = "0",
    totalPoints = "0",
    details = "-",
    pac = "-",
    date = "-";

class GlassmorphismDemoOne extends StatefulWidget {
  final String? title;

  GlassmorphismDemoOne({Key? key, this.title}) : super(key: key);

  @override
  _GlassmorphismDemoOneState createState() => _GlassmorphismDemoOneState();
}

class _GlassmorphismDemoOneState extends State<GlassmorphismDemoOne> {
  @override
  void initState() {
    // TODO: implement initState
    maintest();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.asset("images/bg_glassmophism.png").image,
                fit: BoxFit.cover),
          ),
          child: SafeArea(
            child: GlassmorphicContainer(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.98,
              borderRadius: 15,
              blur: 7,
              alignment: Alignment.bottomCenter,
              border: 2,
              linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF75035).withAlpha(55),
                    Color(0xFFffffff).withAlpha(45),
                  ],
                  stops: [
                    0.3,
                    1,
                  ]),
              borderGradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    Color(0xFF4579C5).withAlpha(100),
                    Color(0xFFFFFFF).withAlpha(55),
                    Color(0xFFF75035).withAlpha(10),
                  ],
                  stops: [
                    0.06,
                    0.95,
                    1
                  ]),
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: MediaQuery.of(context).size.height * 0.3 - 70,
                          left: 40,
                          child: Container(
                            width: 100,
                            height: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [
                                Color(0xFFBC1642),
                                Color(0xFFCB5AC6),
                              ]),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 50,
                          left: 30,
                          child: Container(
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              gradient: LinearGradient(colors: [
                                Color(0xFFFDFC47),
                                Color(0xFF24FE41),
                              ]),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            glassCard(context),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                "images/logo_glassmophism.png",
                                height: 30,
                              ),
                            ),
                            GlassmorphicContainer(
                              width: MediaQuery.of(context).size.width * 0.9 - 20,
                              height: MediaQuery.of(context).size.height * 0.4 - 20,
                              borderRadius: 35,
                              margin: EdgeInsets.all(10),
                              blur: 10,
                              alignment: Alignment.bottomCenter,
                              border: 2,
                              linearGradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFFFFF).withAlpha(0),
                                    Color(0xFFFFFFF).withAlpha(0),
                                  ],
                                  stops: [
                                    0.3,
                                    1,
                                  ]),
                              borderGradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFFFFF).withAlpha(01),
                                    Color(0xFFFFFFF).withAlpha(100),
                                    Color(0xFFFFFFF).withAlpha(01),
                                  ],
                                  stops: [
                                    0.2,
                                    0.9,
                                    1,
                                  ]),
                              child: Body2(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Widget glassCard(var context) {
  double textScaleFactor = MediaQuery.textScaleFactorOf(context);
  return GlassmorphicFlexContainer(
      flex: 2,
      borderRadius: 15,
      padding: EdgeInsets.all(35),
      blur: 14,
      alignment: Alignment.bottomCenter,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0FFFF).withOpacity(0.2),
          Color(0xFF0FFFF).withOpacity(0.2),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0FFFF).withOpacity(1),
          Color(0xFFFFFFF),
          Color(0xFF0FFFF).withOpacity(1),
        ],
      ),
      child: Column(
        key: UniqueKey(),
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.003),
                Image.asset(
                  "images/pub_dev_logo.png",
                  scale: 1.7,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.003),
                InkWell(
                  onTap: () {
                    // launchPubDev();
                  },
                  child: Text(
                    pac,
                    style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 24.0 / textScaleFactor,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  "Published on $date",
                  style: TextStyle(
                    fontFamily: 'RobotoMono',
                    fontSize: 16.0 / textScaleFactor,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Published by Ritick Saha\n(The Flutter Foundry)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'RobotoMono',
                    fontStyle: FontStyle.italic,
                    fontSize: 16.0 / textScaleFactor,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RichText(
                  text: TextSpan(
                    text:
                        '${int.parse(likes) > 1000 ? int.parse(likes).toStringAsExponential() : int.parse(likes)}',
                    style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 26.0 / textScaleFactor,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '\nLikes',
                        style: TextStyle(
                          fontFamily: 'RobotoMono',
                          fontSize: 15.0 / textScaleFactor,
                          color: Colors.white60,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: '$gotpoints',
                    style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 26.0 / textScaleFactor,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '/$totalPoints',
                        style: TextStyle(
                          fontFamily: 'RobotoMono',
                          fontSize: 15.0 / textScaleFactor,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(
                        text: '\n    Pub Point',
                        style: TextStyle(
                          fontFamily: 'RobotoMono',
                          fontSize: 15.0 / textScaleFactor,
                          color: Colors.white60,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: ' $popularity%',
                    style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 26.0 / textScaleFactor,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '\nPopularity',
                        style: TextStyle(
                          fontFamily: 'RobotoMono',
                          fontSize: 15.0 / textScaleFactor,
                          color: Colors.white60,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  "Small Package Discription:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'RobotoMono',
                    fontStyle: FontStyle.italic,
                    fontSize: 18.0 / textScaleFactor,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "$details",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontStyle: FontStyle.italic,
                      fontSize: 18.0 / textScaleFactor,
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.001),
              ],
            ),
          ),
        ],
      ));
}

class Body2 extends StatelessWidget {
  const Body2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Sign In',
            style: TextStyle(
              fontFamily: 'Futura Md BT',
              fontSize: 24.0,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'An example Use Case Of GlassmorphicContainer',
            style: TextStyle(
              fontFamily: 'Futura Md BT',
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white54, width: 0.5),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Text(
                'Your Email',
                style: TextStyle(
                  fontFamily: 'Futura Md BT',
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white54, width: 0.5),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Text(
                'Password',
                style: TextStyle(
                  fontFamily: 'Futura Md BT',
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Next',
                style: TextStyle(
                  fontFamily: 'Futura Md BT',
                  fontSize: 24.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              ClipOval(
                child: Container(
                  height: 50,
                  width: 50,
                  color: Colors.white,
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

Future<int> maintest() async {
  final response = await http.Client()
      .get(Uri.parse("https://pub.dev/packages/glassmorphism/score"));
  if (response.statusCode == 200) {
    var document = parse(response.body);
    likes =
        document.getElementsByClassName("score-key-figure-value")[0].innerHtml;
    gotpoints =
        document.getElementsByClassName("score-key-figure-value")[1].innerHtml;
    totalPoints = "110";
    popularity =
        document.getElementsByClassName("score-key-figure-value")[2].innerHtml;
    details = document.getElementsByClassName("detail-lead-text")[0].innerHtml;
    pac = document.getElementsByClassName("code")[0].innerHtml;
    date = document.getElementsByClassName("metadata")[0].children[0].innerHtml;

    print("+++++++++++++++++++++++++++++++++++++++++++++++++");
    print("++                                             ++");
    print("++   It seams that your internet is working.   ++");
    print("++                                             ++");
    print("+++++++++++++++++++++++++++++++++++++++++++++++++");
    return 1;
  } else {
    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++");
    print("++                                                 ++");
    print("++   It seams that your internet is not working.   ++");
    print("++                                                 ++");
    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++");
    return 0;
  }
}
