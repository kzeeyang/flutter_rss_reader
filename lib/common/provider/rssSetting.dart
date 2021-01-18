import 'package:flutter/cupertino.dart';
import 'package:flutter_rss_reader/common/apis/api.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';

class RssSetting {
  String rssName;
  String url;
  String iconUrl;
  bool opened;

  RssSetting({this.rssName, this.url, this.iconUrl, this.opened});

  RssSetting.fromJson(Map<String, dynamic> json) {
    rssName = json['rssName'];
    url = json['url'];
    if (json['iconUrl'] != null || json['iconUrl'] != '') {
      iconUrl = json['iconUrl'];
    }
    if (json['iconUrl'] == null) {
      Future(() async {
        print('rsssetting get iconurl: $url');
        RssEntity rssEntity =
            await Rss.getRss(this.url, context: null, getIconUrl: true);
        if (rssEntity.iconUrl == null || rssEntity.iconUrl == '') {
          iconUrl = rssName.trim().substring(0, 1);
        } else {
          iconUrl = rssEntity.iconUrl;
        }
        debugPrint("iconUrl: $iconUrl");
      });
    }
    opened = json['opened'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rssName'] = this.rssName;
    data['url'] = this.url;
    data['iconUrl'] = this.iconUrl;
    data['opened'] = this.opened;
    return data;
  }
}
