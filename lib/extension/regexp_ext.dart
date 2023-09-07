//
//  RegexpExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/9/7 16:56.
//  Copyright © 2023/9/7 shang. All rights reserved.
//

/// emoji
const emojiRegexStr = r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])';

/// emoji 正则
final RegExp emojiReg = RegExp(emojiRegexStr);


extension RegExpExt on RegExp{

  /// 匹配
  List<String> allMatchesOfString(String input, [int start = 0]) {
    final list = allMatches(input, start)
        .map((e) => e.group(0))
        .where((e) => e != null)
        .whereType<String>()
        .toList();
    return list;
  }

}