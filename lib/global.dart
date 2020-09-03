import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/common/entitys/entitys.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';

/// 全局配置
class Global {
  /// 用户配置
  static UserLoginResponseEntity profile = UserLoginResponseEntity(
    accessToken: null,
  );

  /// 是否第一次打开
  static bool isFirstOpen = false;

  /// 是否离线登录
  static bool isOfflineLogin = false;

  /// 应用状态
  static AppState appState = AppState();

  /// 是否 release
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  ///全局
  // static AppEntity appState = AppEntity();

  /// init
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();

    // 工具初始
    await StorageUtil.init();

    // 读取设备第一次打开
    isFirstOpen = !StorageUtil().getBool(STORAGE_DEVICE_ALREADY_OPEN_KEY);
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
    print(isFirstOpen);
    if (!isFirstOpen) {
      appState = StorageUtil().getJSON(STORAGE_APP_DATA_KEY);
    }
    debugPrint("appstate: ${appState.darkMode}");
    debugPrint("cateLength: ${appState.categoryLenth}");
  }

  // 持久化 用户信息
  static Future<bool> saveAppState() {
    return StorageUtil().setJSON(STORAGE_APP_DATA_KEY, appState);
  }

  static Future<bool> addRssByCategoryName(String cate, RssSetting rss) {
    var index = getCategoryIndex(cate);
    appState.categories[index].rssSettings.add(rss);
    return saveAppState();
  }

  // getCategoryIndex
  static int getCategoryIndex(String cate) {
    if (cate == null || cate.isEmpty) {
      return -1;
    }
    for (var i = 0; i < appState.categories.length; i++) {
      if (appState.categories[i].cateName == cate) {
        return i;
      }
    }
    return -1;
  }
}
