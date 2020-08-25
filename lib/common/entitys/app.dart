import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app.g.dart';

@JsonSerializable(nullable: false)
class AppEntity with ChangeNotifier {
  final bool darkMode;
  final List<Category> categories;
  AppEntity({this.darkMode = false, this.categories});
  factory AppEntity.fromJson(Map<String, dynamic> json) =>
      _$AppEntityFromJson(json);
  Map<String, dynamic> toJson() => _$AppEntityToJson(this);
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
