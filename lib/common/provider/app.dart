import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app.g.dart';

@JsonSerializable(nullable: false)
class AppState with ChangeNotifier {
  bool darkMode;
  List<Category> categories;
  get darkmode => darkMode;
  get category => categories;
  AppState({bool darkMode = false}) {
    this.darkMode = darkMode;
  }

  //change darkmode
  switctDarkMode() {
    darkMode = !darkMode;
    notifyListeners();
  }

  //update app data
  updateCategories(List<Category> tCategories) {
    categories = tCategories;
    notifyListeners();
  }

  //add category
  addCategory(Category category) {
    categories.add(category);
    notifyListeners();
  }

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);
  Map<String, dynamic> toJson() => _$AppStateToJson(this);
}

@JsonSerializable(nullable: false)
class Category with ChangeNotifier {
  String cateName;
  List<RssSetting> rssSettings;
  Category({this.cateName, this.rssSettings});
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable(nullable: false)
class RssSetting with ChangeNotifier {
  String rssName;
  String url;
  bool opened;
  RssSetting({this.rssName, this.url, this.opened});
  factory RssSetting.fromJson(Map<String, dynamic> json) =>
      _$RssSettingFromJson(json);
  Map<String, dynamic> toJson() => _$RssSettingToJson(this);
}
