import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  bool darkMode;
  Map<String, Category> category;

  get isDarkMode => darkMode;
  get categoryList => category.keys;

  AppState({bool darkMode = false}) {
    this.darkMode = darkMode;
    category = {};
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

  void addCategory(String catename, String iconName) {
    category[catename] = Category(
      cateName: catename,
      iconName: iconName,
      rssSettings: [],
    );
    notifyListeners();
  }

  void deleteCategory(String catename) {
    if (hadCategory(catename)) {
      category.remove(catename);
    }
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
    notifyListeners();
  }

  void deleteRss(String catename, String url, String rssname) {
    int index = rssIndex(catename, url, rssname);
    if (index != -1) {
      category[catename].rssSettings.removeAt(index);
      notifyListeners();
    }
  }

  void changeRssOpen(String catename, String url, String rssname, bool open) {
    int index = rssIndex(catename, url, rssname);
    if (index != -1) {
      category[catename].rssSettings[index].opened = open;
      notifyListeners();
    }
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

  AppState.fromJson(Map<String, dynamic> json) {
    darkMode = json['darkMode'];
    if (json['categories'] != null) {
      category = new Map<String, Category>();
      json['categories'].forEach((v) {
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
      this.category.forEach((key, value) {
        data[key] = value.toJson();
      });
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
