import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:xml/xml.dart' as xml;

/// 检查邮箱格式
bool duIsEmail(String input) {
  if (input == null || input.isEmpty) return false;
  // 邮箱正则
  String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
  return RegExp(regexEmail).hasMatch(input);
}

/// 检查字符长度
bool duCheckStringLength(String input, int length) {
  if (input == null || input.isEmpty) return false;
  return input.length >= length;
}

/// 检查字符长度
bool duCheckStringEmpty(String input) {
  if (input == null || input.isEmpty) return false;
  return true;
}

/// URL检测
bool duIsURL(String input) {
  if (input == null || input.isEmpty) return false;

  String header = "^https?";
  return RegExp(header).hasMatch(input);
}

bool checkHadUrl(List<RssSetting> rsses, String url) {
  var had = false;
  if (rsses.length == 0) {
    return had;
  }

  rsses.forEach((element) {
    if (element.url == url) {
      had = true;
      return;
    }
  });
  return had;
}
