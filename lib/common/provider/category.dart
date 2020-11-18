import 'rssSetting.dart';

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
