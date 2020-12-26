import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_rss_reader/common/entitys/entitys.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

/// 全局配置
class Global {
  /// 用户配置
  static UserLoginResponseEntity profile = UserLoginResponseEntity(
    accessToken: null,
  );

  /// 是否第一次打开
  static bool isFirstOpen = true;

  /// 是否离线登录
  static bool isOfflineLogin = false;

  /// 应用状态
  static AppState appState = AppState();

  static PanelController panelController = new PanelController();
  static EasyRefreshController refreshController = new EasyRefreshController();
  static ScrollController scrollController = new ScrollController();

  /// 是否 release
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  /// init
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();

    // 工具初始
    await StorageUtil.init();

    // 读取设备第一次打开
    isFirstOpen = StorageUtil().getBool(STORAGE_DEVICE_ALREADY_OPEN_KEY);
    if (!isFirstOpen) {
      StorageUtil().setBool(STORAGE_DEVICE_ALREADY_OPEN_KEY, true);
    }

    // android 状态栏为透明的沉浸
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

    //读取配置
    if (isFirstOpen) {
      var _appStateJSON = StorageUtil().getJSON(STORAGE_APP_DATA_KEY);
      // debugPrint("load appJson: $_appStateJSON");
      if (_appStateJSON != null) {
        appState = AppState.fromJson(_appStateJSON);
      }
    }
    // debugPrint("appstate: ${appState.isDarkMode}");
    // debugPrint("cateLength: ${appState.category.length}");
  }

  // 持久化 用户信息
  static Future<bool> saveAppStateCategory() {
    var temp = appState.categoryToJson();
    debugPrint("$temp");
    return StorageUtil().setJSON(STORAGE_APP_DATA_CATEGORY_KEY, temp);
  }
}
