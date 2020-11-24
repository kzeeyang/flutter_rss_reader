import 'dart:ui';

class AppColors {
  /// 主背景 灰色
  static const Color primaryGreyBackground = Color.fromARGB(255, 238, 238, 238);

  /// 主背景 白色
  static const Color primaryWhiteBackground =
      Color.fromARGB(255, 255, 255, 255);

  /// 主文本 灰色
  static const Color primaryText = Color.fromARGB(255, 45, 45, 47);

  /// 主控件-背景 蓝色
  static const Color primaryElement = Color.fromARGB(255, 41, 103, 255);

  /// 主控件-文本 白色
  static const Color primaryElementText = Color.fromARGB(255, 255, 255, 255);

  // *****************************************

  /// 第二种控件-背景色 淡灰色
  static const Color secondaryElement = Color.fromARGB(255, 246, 246, 246);

  /// 第二种控件-文本 浅蓝色
  static const Color secondaryElementText = Color.fromARGB(255, 41, 103, 255);

  // *****************************************

  /// 第三种控件-背景色 石墨色
  static const Color thirdElement = Color.fromARGB(255, 45, 45, 47);

  /// 第三种控件-文本 浅灰色2
  static const Color thirdElementText = Color.fromARGB(255, 141, 141, 142);

  // *****************************************

  /// tabBar 默认颜色 灰色
  static const Color tabBarElement = Color.fromARGB(255, 208, 208, 208);

  // ****************************************
  /// Montserrat
  static const String fontMontserrat = 'Montserrat';

  /// Avenir
  static const String fontAvenir = 'Avenir';
}

class AppValue {
  static const double horizontalPadding = 10.0;
  static const double verticalPadding = 5.0;

  static const double ItemBottomPadding = 10.0;
  static const double ItemShadowElevation = 5.0;
  static const Color ItemShadowColor = Color.fromARGB(125, 141, 141, 142);

  static const double titleSize = 18.0;
  static const FontWeight titleWeight = FontWeight.w400;
  static const double fontSize = 16.0;
  static const double dateSize = 14.0;
}
