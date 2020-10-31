import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AppState with ChangeNotifier {
  bool darkMode;
  // String appBarTitle;
  Category showCategory;
  Map<String, Category> category;

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
    notifyListeners();
  }

  void changePanelOpen(bool open) {
    panelOpen = open;
    notifyListeners();
  }

  void changeShowCategory(String catename) {
    if (hadCategory(catename)) {
      showCategory = category[catename];
    } else {
      if (category.keys.toList().length == 0) {
        showCategory = null;
      } else {
        showCategory = category[0];
      }
    }

    // if (showCategory != null || showCategory.cateName != "") {
    //   appBarTitle = showCategory.cateName;
    // } else {
    //   appBarTitle = "";
    // }

    notifyListeners();
  }

  bool showRssOpened(int index) {
    return this.showCategory.rssSettings[index].opened;
  }

  void changeShowRssOpened(int index) {
    this.showCategory.rssSettings[index].opened =
        !this.showCategory.rssSettings[index].opened;
    notifyListeners();
  }

  void addCategory(String catename, String iconName) {
    category[catename] = Category(
      cateName: catename,
      iconName: iconName,
      rssSettings: [],
    );

    changeShowCategory(catename);
    notifyListeners();
  }

  void deleteCategory(String catename) {
    if (hadCategory(catename)) {
      category.remove(catename);
    }
    changeShowCategory(catename);
    notifyListeners();
  }

  String categoryIconName(String catename) {
    return category[catename].iconName;
  }

  bool hadCategory(String cate) {
    return category.containsKey(cate);
  }

  void addRss(String catename, RssSetting rssSetting) {
    category[catename].rssSettings.add(rssSetting);
    changeShowCategory(catename);
    notifyListeners();
  }

  void deleteRss(String catename, String url, String rssname) {
    int index = rssIndex(catename, url, rssname);
    if (index != -1) {
      category[catename].rssSettings.removeAt(index);
    }
    changeShowCategory(catename);
    notifyListeners();
  }

  void changeRssOpen(String catename, String url, String rssname, bool open) {
    int index = rssIndex(catename, url, rssname);
    if (index != -1) {
      category[catename].rssSettings[index].opened = open;
    }
    changeShowCategory(catename);
    notifyListeners();
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
        if (this.showCategory == null ||
            this.showCategory.cateName == data.cateName) {
          this.showCategory = data;
        }
      });
    }
  }

  AppState.fromJson(Map<String, dynamic> json) {
    darkMode = json['darkMode'];
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

class Category {
  String iconName;
  String cateName;
  List<RssSetting> rssSettings;

  Category({this.iconName, this.cateName, this.rssSettings});

  Category.fromJson(Map<String, dynamic> json) {
    iconName = json['iconName'];
    cateName = json['cateName'];
    if (json['rssSettings'] != null) {
      rssSettings = new List<RssSetting>();
      json['rssSettings'].forEach((v) {
        rssSettings.add(new RssSetting.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iconName'] = this.iconName;
    data['cateName'] = this.cateName;
    if (this.rssSettings != null) {
      data['rssSettings'] = this.rssSettings.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RssSetting {
  String rssName;
  String url;
  bool opened;

  RssSetting({this.rssName, this.url, this.opened});

  RssSetting.fromJson(Map<String, dynamic> json) {
    rssName = json['rssName'];
    url = json['url'];
    opened = json['opened'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rssName'] = this.rssName;
    data['url'] = this.url;
    data['opened'] = this.opened;
    return data;
  }
}
