// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppState _$AppStateFromJson(Map<String, dynamic> json) {
  return AppState(
    darkMode: json['darkMode'] as bool,
  );
}

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
      'darkMode': instance.darkMode,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    cateName: json['cateName'] as String,
    rssSettings: (json['rssSettings'] as List)
        .map((e) => RssSetting.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'cateName': instance.cateName,
      'rssSettings': instance.rssSettings,
    };

RssSetting _$RssSettingFromJson(Map<String, dynamic> json) {
  return RssSetting(
    rssName: json['rssName'] as String,
    url: json['url'] as String,
    opened: json['opened'] as bool,
  );
}

Map<String, dynamic> _$RssSettingToJson(RssSetting instance) =>
    <String, dynamic>{
      'rssName': instance.rssName,
      'url': instance.url,
      'opened': instance.opened,
    };
