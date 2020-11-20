import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/apis/api.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/global.dart';

class AppState with ChangeNotifier {
  bool darkMode;
  // String appBarTitle;
  Map<String, Category> category;
  Category showCategory;
  List<MRssItem> mRssItems;

  // 上滑是否开启
  bool panelOpen;

  get isDarkMode => darkMode;
  get categoryList => category.keys;
  get categoryLength => category.keys.length;

  AppState({
    bool darkMode = false,
    bool panelOpen = false,
  }) {
    this.darkMode = darkMode;
    // appBarTitle = "";
    this.showCategory = null;
    this.category = {};
    this.mRssItems = List();

    this.panelOpen = panelOpen;
  }

  List<RssSetting> rssList(String catename) {
    if (hadCategory(catename)) {
      return category[catename].rssSettings;
    }
    return [];
  }

  //change darkmode
  void switctDarkMode() {
    darkMode = !darkMode;
    save();
  }

  void changePanelOpen(bool open) {
    panelOpen = open;
    notifyListeners();
    save();
  }

  void clearMRssItems() {
    this.mRssItems.clear();
    notifyListeners();
  }

  void addMRssItems(List<MRssItem> items) {
    if (this.mRssItems == null) {
      this.mRssItems = List();
    }
    this.mRssItems.addAll(items);
    notifyListeners();
  }

  bool mRssItemIsShow(String rssname) {
    bool opend = false;
    for (var i = 0; i < this.showCategory.rssSettings.length; i++) {
      if (rssname == this.showCategory.rssSettings[i].rssName) {
        opend = this.showCategory.rssSettings[i].opened;
        break;
      }
    }
    return opend;
  }

  RssSetting getShowCategoryRssSetting(String name) {
    RssSetting rssSetting;
    // print('app: ${this.showCategory.cateName}');
    for (var i = 0; i < this.showCategory.rssSettings.length; i++) {
      // print('$name : ${this.showCategory.rssSettings[i].rssName}');
      if (this.showCategory.rssSettings[i].rssName == name) {
        rssSetting = this.showCategory.rssSettings[i];
      }
    }
    return rssSetting;
  }

  Future<void> changeShowCategory(String catename) async {
    if (hadCategory(catename)) {
      showCategory = category[catename];
    } else {
      if (category.isEmpty) {
        showCategory = null;
      } else {
        showCategory = category.values.toList().first;
      }
    }

    // if (showCategory != null || showCategory.cateName != "") {
    //   appBarTitle = showCategory.cateName;
    // } else {
    //   appBarTitle = "";
    // }

    clearMRssItems();
    for (var i = 0; i < showCategory.rssSettings.length; i++) {
      print('channels: ${showCategory.rssSettings[i].rssName}');
      if (showCategory.rssSettings[i].url.isNotEmpty) {
        var mRssItems = await Rss.getMRssItems(showCategory.rssSettings[i].url,
            showCategory.rssSettings[i].iconUrl,
            context: null);
        Global.appState.mRssItems.addAll(mRssItems);
      }
    }

    notifyListeners();
    save();
  }

  bool showRssOpened(int index) {
    return this.showCategory.rssSettings[index].opened;
  }

  void changeShowRssOpened(int index) {
    this.showCategory.rssSettings[index].opened =
        !this.showCategory.rssSettings[index].opened;
    notifyListeners();
    save();
  }

  void addCategory(String catename, String iconName) {
    category[catename] = Category(
      cateName: catename,
      iconName: iconName,
      rssSettings: [],
    );
    if (showCategory != null) {
      return;
    }
    changeShowCategory(catename);
    notifyListeners();
    save();
  }

  void deleteCategory(String catename) {
    if (hadCategory(catename)) {
      category.remove(catename);
    }
    if (showCategory.cateName == catename) {
      changeShowCategory(catename);
    }

    notifyListeners();
    save();
  }

  String categoryIconName(String catename) {
    return category[catename].iconName;
  }

  bool hadCategory(String cate) {
    return category.containsKey(cate);
  }

  void addRss(String catename, RssSetting rssSetting) {
    category[catename].rssSettings.add(rssSetting);
    if (showCategory.cateName == catename) {
      changeShowCategory(catename);
    }

    notifyListeners();
    save();
  }

  void deleteRss(String catename, String url, String rssname) {
    int index = rssIndex(catename, url, rssname);
    if (index != -1) {
      category[catename].rssSettings.removeAt(index);
    }
    if (catename == this.showCategory.cateName) {
      changeShowCategory("");
    }

    notifyListeners();
    save();
  }

  void changeRssOpen(String catename, String url, String rssname, bool open) {
    int index = rssIndex(catename, url, rssname);
    if (index != -1) {
      category[catename].rssSettings[index].opened = open;
    }
    if (this.showCategory == null) {
      changeShowCategory(catename);
    }

    notifyListeners();
    save();
  }

  int rssIndex(String catename, url, rssname) {
    int length = category[catename].rssSettings.length;
    for (int i = 0; i < length; i++) {
      RssSetting rss = category[catename].rssSettings[i];
      if (rss.url == url && rss.rssName == rssname) {
        return i;
      }
    }
    return -1;
  }

  void refresh() {
    notifyListeners();
  }

  void save() {
    Global.saveAppState();
  }

  void addByJson(String jsonData) {
    final postJsonConverted = json.decode(jsonData);
    if (postJsonConverted['category'] != null) {
      if (category == null) {
        category = new Map<String, Category>();
      }
      postJsonConverted['category'].forEach((v) {
        Category data = Category.fromJson(v);
        if (category.keys.toList().length >= 12) {
          return;
        }

        category[data.cateName] = data;

        if (this.showCategory != null &&
            this.showCategory.cateName == data.cateName) {
          changeShowCategory(data.cateName);
        }
      });
    }

    if (this.showCategory == null) {
      changeShowCategory('');
    }
    notifyListeners();
    save();
  }

  AppState.fromJson(Map<String, dynamic> json) {
    darkMode = json['darkMode'];
    showCategory = Category.fromJson(json['showCategory']);
    if (json['category'] != null) {
      category = new Map<String, Category>();
      json['category'].forEach((v) {
        Category data = Category.fromJson(v);
        category[data.cateName] = data;
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['darkMode'] = this.darkMode;
    data['showCategory'] = this.showCategory.toJson();
    if (this.category != null) {
      this.category.forEach((key, value) {
        data[key] = value.toJson();
      });
    }
    return data;
  }

  Map<String, dynamic> categoryToJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.category != null) {
      final listData = this.category.values.toList();
      data['category'] = listData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
