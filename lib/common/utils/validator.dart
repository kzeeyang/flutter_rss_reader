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

  String regexEmail = "^https?";
  return RegExp(regexEmail).hasMatch(input);
}
