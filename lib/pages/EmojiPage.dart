

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/header.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:tuple/tuple.dart';

class EmojiPage extends StatefulWidget {

  EmojiPage({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _EmojiPageState createState() => _EmojiPageState();
}

class _EmojiPageState extends State<EmojiPage> {

  late final items = <Tuple2<String, String>>[
    Tuple2("smileys", smileys),
    Tuple2("gesturesAndBodyParts", gesturesAndBodyParts),
    Tuple2("peopleAndFantasy", peopleAndFantasy),
    Tuple2("clothingAndAccessories", clothingAndAccessories),
    Tuple2("paleEmojis", paleEmojis),
    Tuple2("animalsAndNature", animalsAndNature),
    Tuple2("foodAndDrink", foodAndDrink),
    Tuple2("activityAndSports", activityAndSports),
    Tuple2("travelAndPlaces", travelAndPlaces),
    Tuple2("objects", objects),
    Tuple2("symbols", symbols),
    Tuple2("flags", flags),
    Tuple2("nonEmojiSymbols", nonEmojiSymbols),

  ];

  // var currentVN = ValueNotifier("🇨🇳");
  var currentVN = ValueNotifier("💯");


  static final RegExp emojiReg = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');


  static final RegExp textReg = RegExp("[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody(
        onChanged: (val){
          debugPrint(val);
          currentVN.value = val;
        }
      ),
    );
  }

  buildBody({ValueChanged<String>? onChanged}) {
    return Column(
      children: [
        buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: items.map((e) {

                final emojiTitle = e.item1.toUncamlCase(" ");
                final emojiList = e.item2.split(" ");
                return Column(
                  children: [
                    Header.h4(title: emojiTitle),
                    Wrap(
                      children: emojiList.map((e) {
                        return InkWell(
                          onTap: (){
                            onChanged?.call(e);
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              // color: ColorExt.random,
                              // border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.all(Radius.circular(0)),
                            ),
                            child: Column(
                              children: [
                                Text(e,
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                                // Text(e.runes.toList().toString(),
                                //   style: TextStyle(
                                //     fontSize: 12,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  buildHeader() {
    return Container(
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 4,
              color: Color(0xff999999).withOpacity(0.2),
              // color: Colors.red,
            ),
          ]
      ),
      child: ValueListenableBuilder(
        valueListenable: currentVN,
        builder: (context,  value, child){

          final content = "当前选择: $value";

          final Iterable<Match> matches = emojiReg.allMatches(content);
          if (matches.isEmpty) {
            return Text(content,
              style: TextStyle(
                fontSize: 16,
              ),
            );
          }

          return RichText(
            text: TextSpan(
              children: content.characters.map((e) {

                return TextSpan(
                  text: e,
                  style: TextStyle(
                    fontSize: emojiReg.allMatches(e).isEmpty ? 16.0 : 30.0,
                    color: Colors.black,
                  )
                );
              }).toList(),
            )
          );
        }
      ),
    );
  }

  final smileys = """😀 😃 😄 😁 😆 😅 😂 🤣 🥲 🥹 ☺️ 😊 😇 🙂 🙃 😉 😌 😍 🥰 😘 😗 😙 😚 😋 😛 😝 😜 🤪 🤨 🧐 🤓 😎 🥸 🤩 🥳 😏 😒 😞 😔 😟 😕 🙁 ☹️ 😣 😖 😫 😩 🥺 😢 😭 😮‍💨 😤 😠 😡 🤬 🤯 😳 🥵 🥶 😱 😨 😰 😥 😓 🫣 🤗 🫡 🤔 🫢 🤭 🤫 🤥 😶 😶‍🌫️ 😐 😑 😬 🫨 🫠 🙄 😯 😦 😧 😮 😲 🥱 😴 🤤 😪 😵 😵‍💫 🫥 🤐 🥴 🤢 🤮 🤧 😷 🤒 🤕 🤑 🤠 😈 👿 👹 👺 🤡 💩 👻 💀 ☠️ 👽 👾 🤖 🎃 😺 😸 😹 😻 😼 😽 🙀 😿 😾""";

  final gesturesAndBodyParts = """👋 🤚 🖐 ✋ 🖖 👌 🤌 🤏 ✌️ 🤞 🫰 🤟 🤘 🤙 🫵 🫱 🫲 🫸 🫷 🫳 🫴 👈 👉 👆 🖕 👇 ☝️ 👍 👎 ✊ 👊 🤛 🤜 👏 🫶 🙌 👐 🤲 🤝 🙏 ✍️ 💅 🤳 💪 🦾 🦵 🦿 🦶 👣 👂 🦻 👃 🫀 🫁 🧠 🦷 🦴 👀 👁 👅 👄 🫦 💋 🩸""";

  final peopleAndFantasy = """👶 👧 🧒 👦 👩 🧑 👨 👩‍🦱 🧑‍🦱 👨‍🦱 👩‍🦰 🧑‍🦰 👨‍🦰 👱‍♀️ 👱 👱‍♂️ 👩‍🦳 🧑‍🦳 👨‍🦳 👩‍🦲 🧑‍🦲 👨‍🦲 🧔‍♀️ 🧔 🧔‍♂️ 👵 🧓 👴 👲 👳‍♀️ 👳 👳‍♂️ 🧕 👮‍♀️ 👮 👮‍♂️ 👷‍♀️ 👷 👷‍♂️ 💂‍♀️ 💂 💂‍♂️ 🕵️‍♀️ 🕵️ 🕵️‍♂️ 👩‍⚕️ 🧑‍⚕️ 👨‍⚕️ 👩‍🌾 🧑‍🌾 👨‍🌾 👩‍🍳 🧑‍🍳 👨‍🍳 👩‍🎓 🧑‍🎓 👨‍🎓 👩‍🎤 🧑‍🎤 👨‍🎤 👩‍🏫 🧑‍🏫 👨‍🏫 👩‍🏭 🧑‍🏭 👨‍🏭 👩‍💻 🧑‍💻 👨‍💻 👩‍💼 🧑‍💼 👨‍💼 👩‍🔧 🧑‍🔧 👨‍🔧 👩‍🔬 🧑‍🔬 👨‍🔬 👩‍🎨 🧑‍🎨 👨‍🎨 👩‍🚒 🧑‍🚒 👨‍🚒 👩‍✈️ 🧑‍✈️ 👨‍✈️ 👩‍🚀 🧑‍🚀 👨‍🚀 👩‍⚖️ 🧑‍⚖️ 👨‍⚖️ 👰‍♀️ 👰 👰‍♂️ 🤵‍♀️ 🤵 🤵‍♂️ 👸 🫅 🤴 🥷 🦸‍♀️ 🦸 🦸‍♂️ 🦹‍♀️ 🦹 🦹‍♂️ 🤶 🧑‍🎄 🎅 🧙‍♀️ 🧙 🧙‍♂️ 🧝‍♀️ 🧝 🧝‍♂️ 🧛‍♀️ 🧛 🧛‍♂️ 🧟‍♀️ 🧟 🧟‍♂️ 🧞‍♀️ 🧞 🧞‍♂️ 🧜‍♀️ 🧜 🧜‍♂️ 🧚‍♀️ 🧚 🧚‍♂️ 🧌 👼 🤰 🫄 🫃 🤱 👩‍🍼 🧑‍🍼 👨‍🍼 🙇‍♀️ 🙇 🙇‍♂️ 💁‍♀️ 💁 💁‍♂️ 🙅‍♀️ 🙅 🙅‍♂️ 🙆‍♀️ 🙆 🙆‍♂️ 🙋‍♀️ 🙋 🙋‍♂️ 🧏‍♀️ 🧏 🧏‍♂️ 🤦‍♀️ 🤦 🤦‍♂️ 🤷‍♀️ 🤷 🤷‍♂️ 🙎‍♀️ 🙎 🙎‍♂️ 🙍‍♀️ 🙍 🙍‍♂️ 💇‍♀️ 💇 💇‍♂️ 💆‍♀️ 💆 💆‍♂️ 🧖‍♀️ 🧖 🧖‍♂️ 💅 🤳 💃 🕺 👯‍♀️ 👯 👯‍♂️ 🕴 👩‍🦽 🧑‍🦽 👨‍🦽 👩‍🦼 🧑‍🦼 👨‍🦼 🚶‍♀️ 🚶 🚶‍♂️ 👩‍🦯 🧑‍🦯 👨‍🦯 🧎‍♀️ 🧎 🧎‍♂️ 🏃‍♀️ 🏃 🏃‍♂️ 🧍‍♀️ 🧍 🧍‍♂️ 👭 🧑‍🤝‍🧑 👬 👫 👩‍❤️‍👩 💑 👨‍❤️‍👨 👩‍❤️‍👨 👩‍❤️‍💋‍👩 💏 👨‍❤️‍💋‍👨 👩‍❤️‍💋‍👨 👪 👨‍👩‍👦 👨‍👩‍👧 👨‍👩‍👧‍👦 👨‍👩‍👦‍👦 👨‍👩‍👧‍👧 👨‍👨‍👦 👨‍👨‍👧 👨‍👨‍👧‍👦 👨‍👨‍👦‍👦 👨‍👨‍👧‍👧 👩‍👩‍👦 👩‍👩‍👧 👩‍👩‍👧‍👦 👩‍👩‍👦‍👦 👩‍👩‍👧‍👧 👨‍👦 👨‍👦‍👦 👨‍👧 👨‍👧‍👦 👨‍👧‍👧 👩‍👦 👩‍👦‍👦 👩‍👧 👩‍👧‍👦 👩‍👧‍👧""";

  final clothingAndAccessories = """🧳 🌂 ☂️ 🧵 🪡 🪢 🪭 🧶 👓 🕶 🥽 🥼 🦺 👔 👕 👖 🧣 🧤 🧥 🧦 👗 👘 🥻 🩴 🩱 🩲 🩳 👙 👚 👛 👜 👝 🎒 👞 👟 🥾 🥿 👠 👡 🩰 👢 👑 👒 🎩 🎓 🧢 ⛑ 🪖 💄 💍 💼""";

  final paleEmojis = """👋🏻 🤚🏻 🖐🏻 ✋🏻 🖖🏻 👌🏻 🤌🏻 🤏🏻 ✌🏻 🤞🏻 🫰🏻 🤟🏻 🤘🏻 🤙🏻 🫵🏻 🫱🏻 🫲🏻 🫸🏻 🫷🏻 🫳🏻 🫴🏻 👈🏻 👉🏻 👆🏻 🖕🏻 👇🏻 ☝🏻 👍🏻 👎🏻 ✊🏻 👊🏻 🤛🏻 🤜🏻 👏🏻 🫶🏻 🙌🏻 👐🏻 🤲🏻 🙏🏻 ✍🏻 💅🏻 🤳🏻 💪🏻 🦵🏻 🦶🏻 👂🏻 🦻🏻 👃🏻 👶🏻 👧🏻 🧒🏻 👦🏻 👩🏻 🧑🏻 👨🏻 👩🏻‍🦱 🧑🏻‍🦱 👨🏻‍🦱 👩🏻‍🦰 🧑🏻‍🦰 👨🏻‍🦰 👱🏻‍♀️ 👱🏻 👱🏻‍♂️ 👩🏻‍🦳 🧑🏻‍🦳 👨🏻‍🦳 👩🏻‍🦲 🧑🏻‍🦲 👨🏻‍🦲 🧔🏻‍♀️ 🧔🏻 🧔🏻‍♂️ 👵🏻 🧓🏻 👴🏻 👲🏻 👳🏻‍♀️ 👳🏻 👳🏻‍♂️ 🧕🏻 👮🏻‍♀️ 👮🏻 👮🏻‍♂️ 👷🏻‍♀️ 👷🏻 👷🏻‍♂️ 💂🏻‍♀️ 💂🏻 💂🏻‍♂️ 🕵🏻‍♀️ 🕵🏻 🕵🏻‍♂️ 👩🏻‍⚕️ 🧑🏻‍⚕️ 👨🏻‍⚕️ 👩🏻‍🌾 🧑🏻‍🌾 👨🏻‍🌾 👩🏻‍🍳 🧑🏻‍🍳 👨🏻‍🍳 👩🏻‍🎓 🧑🏻‍🎓 👨🏻‍🎓 👩🏻‍🎤 🧑🏻‍🎤 👨🏻‍🎤 👩🏻‍🏫 🧑🏻‍🏫 👨🏻‍🏫 👩🏻‍🏭 🧑🏻‍🏭 👨🏻‍🏭 👩🏻‍💻 🧑🏻‍💻 👨🏻‍💻 👩🏻‍💼 🧑🏻‍💼 👨🏻‍💼 👩🏻‍🔧 🧑🏻‍🔧 👨🏻‍🔧 👩🏻‍🔬 🧑🏻‍🔬 👨🏻‍🔬 👩🏻‍🎨 🧑🏻‍🎨 👨🏻‍🎨 👩🏻‍🚒 🧑🏻‍🚒 👨🏻‍🚒 👩🏻‍✈️ 🧑🏻‍✈️ 👨🏻‍✈️ 👩🏻‍🚀 🧑🏻‍🚀 👨🏻‍🚀 👩🏻‍⚖️ 🧑🏻‍⚖️ 👨🏻‍⚖️ 👰🏻‍♀️ 👰🏻 👰🏻‍♂️ 🤵🏻‍♀️ 🤵🏻 🤵🏻‍♂️ 👸🏻 🫅🏻 🤴🏻 🥷🏻 🦸🏻‍♀️ 🦸🏻 🦸🏻‍♂️ 🦹🏻‍♀️ 🦹🏻 🦹🏻‍♂️ 🤶🏻 🧑🏻‍🎄 🎅🏻 🧙🏻‍♀️ 🧙🏻 🧙🏻‍♂️ 🧝🏻‍♀️ 🧝🏻 🧝🏻‍♂️ 🧛🏻‍♀️ 🧛🏻 🧛🏻‍♂️ 🧜🏻‍♀️ 🧜🏻 🧜🏻‍♂️ 🧚🏻‍♀️ 🧚🏻 🧚🏻‍♂️ 👼🏻 🤰🏻 🫄🏻 🫃🏻 🤱🏻 👩🏻‍🍼 🧑🏻‍🍼 👨🏻‍🍼 🙇🏻‍♀️ 🙇🏻 🙇🏻‍♂️ 💁🏻‍♀️ 💁🏻 💁🏻‍♂️ 🙅🏻‍♀️ 🙅🏻 🙅🏻‍♂️ 🙆🏻‍♀️ 🙆🏻 🙆🏻‍♂️ 🙋🏻‍♀️ 🙋🏻 🙋🏻‍♂️ 🧏🏻‍♀️ 🧏🏻 🧏🏻‍♂️ 🤦🏻‍♀️ 🤦🏻 🤦🏻‍♂️ 🤷🏻‍♀️ 🤷🏻 🤷🏻‍♂️ 🙎🏻‍♀️ 🙎🏻 🙎🏻‍♂️ 🙍🏻‍♀️ 🙍🏻 🙍🏻‍♂️ 💇🏻‍♀️ 💇🏻 💇🏻‍♂️ 💆🏻‍♀️ 💆🏻 💆🏻‍♂️ 🧖🏻‍♀️ 🧖🏻 🧖🏻‍♂️ 💃🏻 🕺🏻 🕴🏻 👩🏻‍🦽 🧑🏻‍🦽 👨🏻‍🦽 👩🏻‍🦼 🧑🏻‍🦼 👨🏻‍🦼 🚶🏻‍♀️ 🚶🏻 🚶🏻‍♂️ 👩🏻‍🦯 🧑🏻‍🦯 👨🏻‍🦯 🧎🏻‍♀️ 🧎🏻 🧎🏻‍♂️ 🏃🏻‍♀️ 🏃🏻 🏃🏻‍♂️ 🧍🏻‍♀️ 🧍🏻 🧍🏻‍♂️ 👭🏻 🧑🏻‍🤝‍🧑🏻 👬🏻 👫🏻 🧗🏻‍♀️ 🧗🏻 🧗🏻‍♂️ 🏇🏻 🏂🏻 🏌🏻‍♀️ 🏌🏻 🏌🏻‍♂️ 🏄🏻‍♀️ 🏄🏻 🏄🏻‍♂️ 🚣🏻‍♀️ 🚣🏻 🚣🏻‍♂️ 🏊🏻‍♀️ 🏊🏻 🏊🏻‍♂️ ⛹🏻‍♀️ ⛹🏻 ⛹🏻‍♂️ 🏋🏻‍♀️ 🏋🏻 🏋🏻‍♂️ 🚴🏻‍♀️ 🚴🏻 🚴🏻‍♂️ 🚵🏻‍♀️ 🚵🏻 🚵🏻‍♂️ 🤸🏻‍♀️ 🤸🏻 🤸🏻‍♂️ 🤽🏻‍♀️ 🤽🏻 🤽🏻‍♂️ 🤾🏻‍♀️ 🤾🏻 🤾🏻‍♂️ 🤹🏻‍♀️ 🤹🏻 🤹🏻‍♂️ 🧘🏻‍♀️ 🧘🏻 🧘🏻‍♂️ 🛀🏻 🛌🏻""";

  final animalsAndNature = """🐶 🐱 🐭 🐹 🐰 🦊 🐻 🐼 🐻‍❄️ 🐨 🐯 🦁 🐮 🐷 🐽 🐸 🐵 🙈 🙉 🙊 🐒 🐔 🐧 🐦 🐦‍⬛ 🐤 🐣 🐥 🦆 🦅 🦉 🦇 🐺 🐗 🐴 🦄 🐝 🪱 🐛 🦋 🐌 🐞 🐜 🪰 🪲 🪳 🦟 🦗 🕷 🕸 🦂 🐢 🐍 🦎 🦖 🦕 🐙 🦑 🦐 🦞 🦀 🪼 🪸 🐡 🐠 🐟 🐬 🐳 🐋 🦈 🐊 🐅 🐆 🦓 🫏 🦍 🦧 🦣 🐘 🦛 🦏 🐪 🐫 🦒 🦘 🦬 🐃 🐂 🐄 🐎 🐖 🐏 🐑 🦙 🐐 🦌 🫎 🐕 🐩 🦮 🐕‍🦺 🐈 🐈‍⬛ 🪽 🪶 🐓 🦃 🦤 🦚 🦜 🦢 🪿 🦩 🕊 🐇 🦝 🦨 🦡 🦫 🦦 🦥 🐁 🐀 🐿 🦔 🐾 🐉 🐲 🌵 🎄 🌲 🌳 🌴 🪹 🪺 🪵 🌱 🌿 ☘️ 🍀 🎍 🪴 🎋 🍃 🍂 🍁 🍄 🐚 🪨 🌾 💐 🌷 🪷 🌹 🥀 🌺 🌸 🪻 🌼 🌻 🌞 🌝 🌛 🌜 🌚 🌕 🌖 🌗 🌘 🌑 🌒 🌓 🌔 🌙 🌎 🌍 🌏 🪐 💫 ⭐️ 🌟 ✨ ⚡️ ☄️ 💥 🔥 🌪 🌈 ☀️ 🌤 ⛅️ 🌥 ☁️ 🌦 🌧 ⛈ 🌩 🌨 ❄️ ☃️ ⛄️ 🌬 💨 💧 💦 🫧 ☔️ ☂️ 🌊 🌫""";

  final foodAndDrink = """🍏 🍎 🍐 🍊 🍋 🍌 🍉 🍇 🍓 🫐 🍈 🍒 🍑 🥭 🍍 🥥 🥝 🍅 🍆 🥑 🥦 🫛 🥬 🥒 🌶 🫑 🌽 🥕 🫒 🧄 🧅 🫚 🥔 🍠 🫘 🥐 🥯 🍞 🥖 🥨 🧀 🥚 🍳 🧈 🥞 🧇 🥓 🥩 🍗 🍖 🦴 🌭 🍔 🍟 🍕 🫓 🥪 🥙 🧆 🌮 🌯 🫔 🥗 🥘 🫕 🥫 🍝 🍜 🍲 🍛 🍣 🍱 🥟 🦪 🍤 🍙 🍚 🍘 🍥 🥠 🥮 🍢 🍡 🍧 🍨 🍦 🥧 🧁 🍰 🎂 🍮 🍭 🍬 🍫 🍿 🍩 🍪 🌰 🥜 🍯 🥛 🍼 🫖 ☕️ 🍵 🧃 🥤 🧋 🫙 🍶 🍺 🍻 🥂 🍷 🫗 🥃 🍸 🍹 🧉 🍾 🧊 🥄 🍴 🍽 🥣 🥡 🥢 🧂""";

  final activityAndSports = """⚽️ 🏀 🏈 ⚾️ 🥎 🎾 🏐 🏉 🥏 🎱 🪀 🏓 🏸 🏒 🏑 🥍 🏏 🪃 🥅 ⛳️ 🪁 🏹 🎣 🤿 🥊 🥋 🎽 🛹 🛼 🛷 ⛸ 🥌 🎿 ⛷ 🏂 🪂 🏋️‍♀️ 🏋️ 🏋️‍♂️ 🤼‍♀️ 🤼 🤼‍♂️ 🤸‍♀️ 🤸 🤸‍♂️ ⛹️‍♀️ ⛹️ ⛹️‍♂️ 🤺 🤾‍♀️ 🤾 🤾‍♂️ 🏌️‍♀️ 🏌️ 🏌️‍♂️ 🏇 🧘‍♀️ 🧘 🧘‍♂️ 🏄‍♀️ 🏄 🏄‍♂️ 🏊‍♀️ 🏊 🏊‍♂️ 🤽‍♀️ 🤽 🤽‍♂️ 🚣‍♀️ 🚣 🚣‍♂️ 🧗‍♀️ 🧗 🧗‍♂️ 🚵‍♀️ 🚵 🚵‍♂️ 🚴‍♀️ 🚴 🚴‍♂️ 🏆 🥇 🥈 🥉 🏅 🎖 🏵 🎗 🎫 🎟 🎪 🤹 🤹‍♂️ 🤹‍♀️ 🎭 🩰 🎨 🎬 🎤 🎧 🎼 🎹 🥁 🪘 🪇 🎷 🎺 🪗 🎸 🪕 🎻 🪈 🎲 ♟ 🎯 🎳 🎮 🎰 🧩""";

  final travelAndPlaces = """🚗 🚕 🚙 🚌 🚎 🏎 🚓 🚑 🚒 🚐 🛻 🚚 🚛 🚜 🦯 🦽 🦼 🛴 🚲 🛵 🏍 🛺 🚨 🚔 🚍 🚘 🚖 🛞 🚡 🚠 🚟 🚃 🚋 🚞 🚝 🚄 🚅 🚈 🚂 🚆 🚇 🚊 🚉 ✈️ 🛫 🛬 🛩 💺 🛰 🚀 🛸 🚁 🛶 ⛵️ 🚤 🛥 🛳 ⛴ 🚢 ⚓️ 🛟 🪝 ⛽️ 🚧 🚦 🚥 🚏 🗺 🗿 🗽 🗼 🏰 🏯 🏟 🎡 🎢 🛝 🎠 ⛲️ ⛱ 🏖 🏝 🏜 🌋 ⛰ 🏔 🗻 🏕 ⛺️ 🛖 🏠 🏡 🏘 🏚 🏗 🏭 🏢 🏬 🏣 🏤 🏥 🏦 🏨 🏪 🏫 🏩 💒 🏛 ⛪️ 🕌 🕍 🛕 🕋 ⛩ 🛤 🛣 🗾 🎑 🏞 🌅 🌄 🌠 🎇 🎆 🌇 🌆 🏙 🌃 🌌 🌉 🌁""";

  final objects = """⌚️ 📱 📲 💻 ⌨️ 🖥 🖨 🖱 🖲 🕹 🗜 💽 💾 💿 📀 📼 📷 📸 📹 🎥 📽 🎞 📞 ☎️ 📟 📠 📺 📻 🎙 🎚 🎛 🧭 ⏱ ⏲ ⏰ 🕰 ⌛️ ⏳ 📡 🔋 🪫 🔌 💡 🔦 🕯 🪔 🧯 🛢 🛍️ 💸 💵 💴 💶 💷 🪙 💰 💳 💎 ⚖️ 🪮 🪜 🧰 🪛 🔧 🔨 ⚒ 🛠 ⛏ 🪚 🔩 ⚙️ 🪤 🧱 ⛓ 🧲 🔫 💣 🧨 🪓 🔪 🗡 ⚔️ 🛡 🚬 ⚰️ 🪦 ⚱️ 🏺 🔮 📿 🧿 🪬 💈 ⚗️ 🔭 🔬 🕳 🩹 🩺 🩻 🩼 💊 💉 🩸 🧬 🦠 🧫 🧪 🌡 🧹 🪠 🧺 🧻 🚽 🚰 🚿 🛁 🛀 🧼 🪥 🪒 🧽 🪣 🧴 🛎 🔑 🗝 🚪 🪑 🛋 🛏 🛌 🧸 🪆 🖼 🪞 🪟 🛍 🛒 🎁 🎈 🎏 🎀 🪄 🪅 🎊 🎉 🪩 🎎 🏮 🎐 🧧 ✉️ 📩 📨 📧 💌 📥 📤 📦 🏷 🪧 📪 📫 📬 📭 📮 📯 📜 📃 📄 📑 🧾 📊 📈 📉 🗒 🗓 📆 📅 🗑 🪪 📇 🗃 🗳 🗄 📋 📁 📂 🗂 🗞 📰 📓 📔 📒 📕 📗 📘 📙 📚 📖 🔖 🧷 🔗 📎 🖇 📐 📏 🧮 📌 📍 ✂️ 🖊 🖋 ✒️ 🖌 🖍 📝 ✏️ 🔍 🔎 🔏 🔐 🔒 🔓""";

  final symbols = """❤️ 🩷 🧡 💛 💚 💙 🩵 💜 🖤 🩶 🤍 🤎 ❤️‍🔥 ❤️‍🩹 💔 ❣️ 💕 💞 💓 💗 💖 💘 💝 💟 ☮️ ✝️ ☪️ 🪯 🕉 ☸️ ✡️ 🔯 🕎 ☯️ ☦️ 🛐 ⛎ ♈️ ♉️ ♊️ ♋️ ♌️ ♍️ ♎️ ♏️ ♐️ ♑️ ♒️ ♓️ 🆔 ⚛️ 🉑 ☢️ ☣️ 📴 📳 🈶 🈚️ 🈸 🈺 🈷️ ✴️ 🆚 💮 🉐 ㊙️ ㊗️ 🈴 🈵 🈹 🈲 🅰️ 🅱️ 🆎 🆑 🅾️ 🆘 ❌ ⭕️ 🛑 ⛔️ 📛 🚫 💯 💢 ♨️ 🚷 🚯 🚳 🚱 🔞 📵 🚭 ❗️ ❕ ❓ ❔ ‼️ ⁉️ 🔅 🔆 〽️ ⚠️ 🚸 🔱 ⚜️ 🔰 ♻️ ✅ 🈯️ 💹 ❇️ ✳️ ❎ 🌐 💠 Ⓜ️ 🌀 💤 🏧 🚾 ♿️ 🅿️ 🛗 🈳 🈂️ 🛂 🛃 🛄 🛅 🚹 🚺 🚼 ⚧ 🚻 🚮 🎦 🛜 📶 🈁 🔣 ℹ️ 🔤 🔡 🔠 🆖 🆗 🆙 🆒 🆕 🆓 0️⃣ 1️⃣ 2️⃣ 3️⃣ 4️⃣ 5️⃣ 6️⃣ 7️⃣ 8️⃣ 9️⃣ 🔟 🔢 #️⃣ *️⃣ ⏏️ ▶️ ⏸ ⏯ ⏹ ⏺ ⏭ ⏮ ⏩ ⏪ ⏫ ⏬ ◀️ 🔼 🔽 ➡️ ⬅️ ⬆️ ⬇️ ↗️ ↘️ ↙️ ↖️ ↕️ ↔️ ↪️ ↩️ ⤴️ ⤵️ 🔀 🔁 🔂 🔄 🔃 🎵 🎶 ➕ ➖ ➗ ✖️ 🟰 ♾ 💲 💱 ™️ ©️ ®️ 〰️ ➰ ➿ 🔚 🔙 🔛 🔝 🔜 ✔️ ☑️ 🔘 🔴 🟠 🟡 🟢 🔵 🟣 ⚫️ ⚪️ 🟤 🔺 🔻 🔸 🔹 🔶 🔷 🔳 🔲 ▪️ ▫️ ◾️ ◽️ ◼️ ◻️ 🟥 🟧 🟨 🟩 🟦 🟪 ⬛️ ⬜️ 🟫 🔈 🔇 🔉 🔊 🔔 🔕 📣 📢 👁‍🗨 💬 💭 🗯 ♠️ ♣️ ♥️ ♦️ 🃏 🎴 🀄️ 🕐 🕑 🕒 🕓 🕔 🕕 🕖 🕗 🕘 🕙 🕚 🕛 🕜 🕝 🕞 🕟 🕠 🕡 🕢 🕣 🕤 🕥 🕦 🕧""";

  final flags = """🏳️ 🏴 🏁 🚩 🏳️‍🌈 🏳️‍⚧️ 🏴‍☠️ 🇦🇫 🇦🇽 🇦🇱 🇩🇿 🇦🇸 🇦🇩 🇦🇴 🇦🇮 🇦🇶 🇦🇬 🇦🇷 🇦🇲 🇦🇼 🇦🇺 🇦🇹 🇦🇿 🇧🇸 🇧🇭 🇧🇩 🇧🇧 🇧🇾 🇧🇪 🇧🇿 🇧🇯 🇧🇲 🇧🇹 🇧🇴 🇧🇦 🇧🇼 🇧🇷 🇮🇴 🇻🇬 🇧🇳 🇧🇬 🇧🇫 🇧🇮 🇰🇭 🇨🇲 🇨🇦 🇮🇨 🇨🇻 🇧🇶 🇰🇾 🇨🇫 🇹🇩 🇨🇱 🇨🇳 🇨🇽 🇨🇨 🇨🇴 🇰🇲 🇨🇬 🇨🇩 🇨🇰 🇨🇷 🇨🇮 🇭🇷 🇨🇺 🇨🇼 🇨🇾 🇨🇿 🇩🇰 🇩🇯 🇩🇲 🇩🇴 🇪🇨 🇪🇬 🇸🇻 🇬🇶 🇪🇷 🇪🇪 🇪🇹 🇪🇺 🇫🇰 🇫🇴 🇫🇯 🇫🇮 🇫🇷 🇬🇫 🇵🇫 🇹🇫 🇬🇦 🇬🇲 🇬🇪 🇩🇪 🇬🇭 🇬🇮 🇬🇷 🇬🇱 🇬🇩 🇬🇵 🇬🇺 🇬🇹 🇬🇬 🇬🇳 🇬🇼 🇬🇾 🇭🇹 🇭🇳 🇭🇰 🇭🇺 🇮🇸 🇮🇳 🇮🇩 🇮🇷 🇮🇶 🇮🇪 🇮🇲 🇮🇱 🇮🇹 🇯🇲 🇯🇵 🎌 🇯🇪 🇯🇴 🇰🇿 🇰🇪 🇰🇮 🇽🇰 🇰🇼 🇰🇬 🇱🇦 🇱🇻 🇱🇧 🇱🇸 🇱🇷 🇱🇾 🇱🇮 🇱🇹 🇱🇺 🇲🇴 🇲🇰 🇲🇬 🇲🇼 🇲🇾 🇲🇻 🇲🇱 🇲🇹 🇲🇭 🇲🇶 🇲🇷 🇲🇺 🇾🇹 🇲🇽 🇫🇲 🇲🇩 🇲🇨 🇲🇳 🇲🇪 🇲🇸 🇲🇦 🇲🇿 🇲🇲 🇳🇦 🇳🇷 🇳🇵 🇳🇱 🇳🇨 🇳🇿 🇳🇮 🇳🇪 🇳🇬 🇳🇺 🇳🇫 🇰🇵 🇲🇵 🇳🇴 🇴🇲 🇵🇰 🇵🇼 🇵🇸 🇵🇦 🇵🇬 🇵🇾 🇵🇪 🇵🇭 🇵🇳 🇵🇱 🇵🇹 🇵🇷 🇶🇦 🇷🇪 🇷🇴 🇷🇺 🇷🇼 🇼🇸 🇸🇲 🇸🇦 🇸🇳 🇷🇸 🇸🇨 🇸🇱 🇸🇬 🇸🇽 🇸🇰 🇸🇮 🇬🇸 🇸🇧 🇸🇴 🇿🇦 🇰🇷 🇸🇸 🇪🇸 🇱🇰 🇧🇱 🇸🇭 🇰🇳 🇱🇨 🇵🇲 🇻🇨 🇸🇩 🇸🇷 🇸🇿 🇸🇪 🇨🇭 🇸🇾 🇹🇼 🇹🇯 🇹🇿 🇹🇭 🇹🇱 🇹🇬 🇹🇰 🇹🇴 🇹🇹 🇹🇳 🇹🇷 🇹🇲 🇹🇨 🇹🇻 🇻🇮 🇺🇬 🇺🇦 🇦🇪 🇬🇧 🏴󠁧󠁢󠁥󠁮󠁧󠁿 🏴󠁧󠁢󠁳󠁣󠁴󠁿 🏴󠁧󠁢󠁷󠁬󠁳󠁿 🇺🇳 🇺🇸 🇺🇾 🇺🇿 🇻🇺 🇻🇦 🇻🇪 🇻🇳 🇼🇫 🇪🇭 🇾🇪 🇿🇲 🇿🇼""";

  final nonEmojiSymbols = """✢ ✣ ✤ ✥ ✦ ✧ ★ ☆ ✯ ✡︎ ✩ ✪ ✫ ✬ ✭ ✮ ✶ ✷ ✵ ✸ ✹ → ⇒ ⟹ ⇨ ⇾ ➾ ⇢ ☛ ☞ ➔ ➜ ➙ ➛ ➝ ➞ ♠︎ ♣︎ ♥︎ ♦︎ ♤ ♧ ♡ ♢ ♚ ♛ ♜ ♝ ♞ ♟ ♔ ♕ ♖ ♗ ♘ ♙ ⚀ ⚁ ⚂ ⚃ ⚄ ⚅ 🂠 ⚈ ⚉ ⚆ ⚇ 𓀀 𓀁 𓀂 𓀃 𓀄 𓀅 𓀆 𓀇 𓀈 𓀉 𓀊 𓀋 𓀌 𓀍 𓀎 𓀏 𓀐 𓀑 𓀒 𓀓 𓀔 𓀕 𓀖 𓀗 𓀘 𓀙 𓀚 𓀛 𓀜 𓀝""";
}




