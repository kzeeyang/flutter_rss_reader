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
    if (isFirstOpen) {
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
      if (_appStateJSON != null) {
        appState = AppState.fromJson(_appStateJSON);
      }
    }
    debugPrint("appstate: ${appState.isDarkMode}");
    debugPrint("cateLength: ${appState.mapLength}");
  }

  // 持久化 用户信息
  static Future<bool> saveAppState() {
    return StorageUtil().setJSON(STORAGE_APP_DATA_KEY, appState);
  }

  static addRssByCategoryName(String cate, RssSetting rss) {
    if (hadCategory(cate)) {
      appState.categories[cate].add(rss);
    }
    saveAppState();
  }

  static List<RssSetting> getRssSettings(String cate) {
    if (hadCategory(cate)) {
      return appState.categories[cate];
    }
    return [];
  }

  static RssSetting getRssSetting(String cate, rssUrl, rssName) {
    var index = getRssIndex(cate, rssUrl, rssName);
    if (index != -1) {
      return appState.categories[cate][index];
    }
    return null;
  }

  static setRssOpend(String cate, rssUrl, rssName, bool value) {
    var index = getRssIndex(cate, rssUrl, rssName);
    if (index != -1) {
      appState.categories[cate][index].opened = value;
    }
    saveAppState();
  }

  static deleteRss(String cate, rssUrl, rssName) {
    var index = getRssIndex(cate, rssUrl, rssName);
    if (index != -1) {
      appState.categories[cate].removeAt(index);
    }
    saveAppState();
  }

  static deleteCategory(String cate) {
    if (hadCategory(cate)) {
      appState.categories.remove(cate);
    }
    saveAppState();
  }

  // getCategoryIndex
  static bool hadCategory(String cate) {
    return appState.categories.containsKey(cate);
  }

  static int getRssIndex(String cate, rssUrl, rssName) {
    if (!hadCategory(cate)) {
      return -1;
    }
    for (var i = 0; i < appState.categories[cate].length; i++) {
      if (appState.categories[cate][i].url == rssUrl &&
          appState.categories[cate][i].rssName == rssName) {
        return i;
      }
    }
    return -1;
  }
}
