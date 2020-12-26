import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/apis/api.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/global.dart';

class AppState with ChangeNotifier {
  // String appBarTitle;
  Map<String, Category> category;
  Category showCategory;
  List<MRssItem> mRssItems = new List();

  /// panel 开启
  bool panelOpen = false;
  bool isDragging = false;
  int draggingChoice = 0;

  get categoryList => category.keys;
  get categoryLength => category.keys.length;

  AppState({
    bool darkMode = false,
    bool panelOpen = false,
  }) {
    // appBarTitle = "";
    this.showCategory = null;
    this.category = {};
    this.mRssItems = List();

    this.panelOpen = panelOpen;
    isDragging = false;
    draggingChoice = 0;
  }

  List<RssSetting> rssList(String catename) {
    if (hadCategory(catename)) {
      return category[catename].rssSettings;
    }
    return [];
  }

  //change darkmode
  // void switctDarkMode() {
  //   darkMode = !darkMode;
  //   save();
  // }

  void changePanelOpen(bool open) {
    this.panelOpen = open;
    notifyListeners();
  }

  void changeDragging(bool open) {
    this.isDragging = open;
    notifyListeners();
  }

  void changeDragChoice(int choice) {
    this.draggingChoice = choice;
    notifyListeners();
  }

  void clearMRssItems() {
    this.mRssItems.clear();
    notifyListeners();
  }

  Future<List<MRssItem>> reloadMRssItems() async {
    this.mRssItems.clear();

    // for (var i = 0; i < showCategory.rssSettings.length; i++) {
    //   // print('channels: ${showCategory.rssSettings[i].rssName}');
    //   if (showCategory.rssSettings[i].url.isNotEmpty) {
    this.mRssItems =
        await Rss.getMRssItems(showCategory.rssSettings, context: null);
    return this.mRssItems;
    // notifyListeners();
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
      if (showCategory.cateName == catename) {
        return;
      }
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

    reloadMRssItems();
    notifyListeners();
    save();
  }

  bool showRssOpened(int index) {
    return this.showCategory.rssSettings[index].opened;
  }

  void changeShowRssOpened(int index) {
    this.showCategory.rssSettings[index].opened =
        !this.showCategory.rssSettings[index].opened;
    // save();
    notifyListeners();
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

  void save(int type) {
    switch (type) {
      case 0:
        Global.saveAppStateCategory();
        break;
      case 1:
        break;
      case 2:
        break;
    }
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
    // darkMode = json['darkMode'];
    showCategory = Category.fromJson(json['showCategory']);
    if (json['category'] != null) {
      category = new Map<String, Category>();
      json['category'].forEach((v) {
        Category data = Category.fromJson(v);
        category[data.cateName] = data;
      });
    }
    if (json['mRssItems'] != null) {
      mRssItems = new List<MRssItem>();
      json['rssSettings'].forEach((v) {
        mRssItems.add(new MRssItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['darkMode'] = this.darkMode;
    data['showCategory'] = this.showCategory.toJson();
    if (this.category != null) {
      this.category.forEach((key, value) {
        data[key] = value.toJson();
      });
    }
    if (this.mRssItems != null) {
      data['mRssItems'] = this.mRssItems.map((v) => v.toJson()).toList();
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
